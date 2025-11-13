/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const crypto = require("crypto");
const admin = require("firebase-admin");
const functions = require("firebase-functions");

functions.setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

admin.initializeApp();

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;
const logger = functions.logger;

// TODO: Ürün kimliklerini gerçek Adapty ürünlerinizle güncelleyin.
// Abonelikler kullanıcı katmanını belirler.
const SUBSCRIPTION_PRODUCTS = {
  // Örnek: "com.aemove.premium.monthly": {tier: "premium", monthlyCredits: 100},
};

// Kredi paketleri mevcut kredilere eklenir.
const CREDIT_PACK_PRODUCTS = {
  // Örnek: "com.aemove.credits.10": 10,
};

exports.healthcheck = functions.https.onRequest((req, res) => {
  res.status(200).json({ok: true, timestamp: new Date().toISOString()});
});

exports.consumeCredits = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Oturum açmış bir kullanıcı gereklidir.",
    );
  }

  const amount = Number(data?.amount ?? 0);
  if (!Number.isFinite(amount) || amount <= 0) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Geçerli bir kredi miktarı belirtmelisiniz.",
    );
  }

  const userRef = db.collection("users").doc(context.auth.uid);

  const newBalance = await db.runTransaction(async (tx) => {
    const snapshot = await tx.get(userRef);
    const current = snapshot.exists ? snapshot.get("credits") ?? 0 : 0;
    if (current < amount) {
      throw new functions.https.HttpsError(
          "failed-precondition",
          "Yetersiz kredi.",
      );
    }

    tx.set(userRef, {
      credits: FieldValue.increment(-amount),
      updatedAt: FieldValue.serverTimestamp(),
    }, {merge: true});

    return current - amount;
  });

  logger.info("Krediler düşüldü", {
    uid: context.auth.uid,
    amount,
    balance: newBalance,
  });

  await logTransaction(context.auth.uid, {
    type: "debit",
    amount,
    source: "consumeCredits",
  });

  return {balance: newBalance};
});

exports.handleAdaptyWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).send("Method Not Allowed");
    return;
  }

  const secret = functions.config().adapty?.webhook_secret;
  if (!secret) {
    logger.error("Adapty webhook sırrı tanımlı değil.");
    res.status(500).json({error: "not_configured"});
    return;
  }

  const signature = req.get("x-adapty-signature");
  if (!signature) {
    res.status(401).json({error: "missing_signature"});
    return;
  }

  const computedSignature = crypto
      .createHmac("sha256", secret)
      .update(req.rawBody)
      .digest("hex");

  if (computedSignature !== signature) {
    res.status(401).json({error: "invalid_signature"});
    return;
  }

  const event = req.body;
  logger.info("Adapty webhook alındı", {
    eventType: event?.event_type,
  });

  try {
    await handleAdaptyEvent(event);
    res.json({ok: true});
  } catch (error) {
    logger.error("Adapty webhook işlenemedi", error);
    res.status(500).json({error: "internal_error"});
  }
});

async function handleAdaptyEvent(event) {
  const eventType = event?.event_type;
  const profileId = event?.profile_id ?? event?.data?.profile_id;
  const payload = event?.data ?? event?.event_data ?? event;
  const userId = payload?.attributes?.customer_user_id ??
    payload?.customer_user_id ??
    payload?.user_id;

  if (!userId) {
    logger.warn("Adapty etkinliğinde userId bulunamadı.", {
      profileId,
      eventType,
    });
    return;
  }

  switch (eventType) {
    case "subscription_activated":
    case "subscription_renewed":
      await applySubscription(userId, payload);
      break;
    case "subscription_cancelled":
    case "subscription_expired":
      await cancelSubscription(userId, payload);
      break;
    case "non_subscription_purchase_activated":
      await applyCreditPack(userId, payload);
      break;
    default:
      logger.info("Ele alınmayan Adapty etkinliği", {eventType});
  }
}

async function applySubscription(userId, payload) {
  const productId = payload?.attributes?.vendor_product_id ??
    payload?.vendor_product_id;
  const config = SUBSCRIPTION_PRODUCTS[productId];

  if (!config) {
    logger.warn("Bilinmeyen abonelik ürünü", {productId});
    return;
  }

  const userRef = db.collection("users").doc(userId);
  await userRef.set({
    tier: config.tier,
    subscription: {
      productId,
      status: "active",
      renewedAt: FieldValue.serverTimestamp(),
    },
    updatedAt: FieldValue.serverTimestamp(),
  }, {merge: true});

  if (config.monthlyCredits) {
    await userRef.set({
      credits: FieldValue.increment(config.monthlyCredits),
    }, {merge: true});

    await logTransaction(userId, {
      type: "credit",
      amount: config.monthlyCredits,
      source: "subscription",
      productId,
    });
  }
}

async function cancelSubscription(userId, payload) {
  const productId = payload?.attributes?.vendor_product_id ??
    payload?.vendor_product_id;

  const userRef = db.collection("users").doc(userId);
  await userRef.set({
    tier: "free",
    subscription: {
      productId,
      status: "cancelled",
      updatedAt: FieldValue.serverTimestamp(),
    },
    updatedAt: FieldValue.serverTimestamp(),
  }, {merge: true});
}

async function applyCreditPack(userId, payload) {
  const productId = payload?.attributes?.vendor_product_id ??
    payload?.vendor_product_id;
  const credits = CREDIT_PACK_PRODUCTS[productId];

  if (!credits) {
    logger.warn("Bilinmeyen kredi paketi", {productId});
    return;
  }

  const userRef = db.collection("users").doc(userId);
  await userRef.set({
    credits: FieldValue.increment(credits),
    updatedAt: FieldValue.serverTimestamp(),
  }, {merge: true});

  await logTransaction(userId, {
    type: "credit",
    amount: credits,
    source: "credit_pack",
    productId,
  });
}

async function logTransaction(userId, data) {
  const payload = {
    uid: userId,
    createdAt: FieldValue.serverTimestamp(),
    ...data,
  };

  await db.collection("transactions").add(payload);
}
