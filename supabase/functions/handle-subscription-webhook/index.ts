import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4";

serve(async (req) => {
  const webhookSecret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET");
  const authHeader = req.headers.get("Authorization");

  // Simple secret validation (or use RC signature verification)
  if (webhookSecret && authHeader !== `Bearer ${webhookSecret}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  try {
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const body = await req.json();
    const event = body.event;
    const userId = event.app_user_id;
    const eventType = event.type;

    if (!userId) throw new Error("No app_user_id found in event");

    let tier = "free";
    let status = "active";
    let validUntil = null;
    let graceUntil = null;

    if (event.entitlement_ids && event.entitlement_ids.length > 0) {
      tier = event.entitlement_ids.includes("family") ? "family" : "plus";
    }

    if (event.expiration_at_ms) {
      validUntil = new Date(event.expiration_at_ms).toISOString();
    }

    switch (eventType) {
      case "INITIAL_PURCHASE":
      case "RENEWAL":
        status = "active";
        break;
      case "CANCELLATION":
        status = "cancelled";
        break;
      case "EXPIRATION":
        status = "expired";
        // 7 days grace period
        graceUntil = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
        break;
      case "BILLING_ISSUE":
        status = "grace_period";
        graceUntil = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
        break;
    }

    const { error } = await supabaseAdmin
      .from("user_subscriptions")
      .upsert({
        user_id: userId,
        tier: tier,
        status: status,
        valid_until: validUntil,
        grace_period_until: graceUntil,
        updated_at: new Date().toISOString(),
      });

    if (error) throw error;

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    console.error("Webhook error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 400,
    });
  }
});
