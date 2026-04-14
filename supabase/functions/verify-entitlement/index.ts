import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      }
    );

    const {
      data: { user },
    } = await supabaseClient.auth.getUser();

    if (!user) throw new Error("User not found");

    const { data: subscription, error: subError } = await supabaseClient
      .from("user_subscriptions")
      .select("*")
      .eq("user_id", user.id)
      .single();

    if (subError && subError.code !== "PGRST116") {
      throw subError;
    }

    const { feature_id } = await req.json().catch(() => ({}));

    // Logic: 
    // plus/family has access to everything
    // free has access to core features only
    
    const tier = subscription?.tier ?? "free";
    const status = subscription?.status ?? "active";
    const validUntil = subscription?.valid_until ? new Date(subscription.valid_until) : null;
    const graceUntil = subscription?.grace_period_until ? new Date(subscription.grace_period_until) : null;
    
    let entitled = false;
    const now = new Date();

    if (tier === "plus" || tier === "family") {
      if (status === "active" || (validUntil && validUntil > now) || (graceUntil && graceUntil > now)) {
        entitled = true;
      }
    }

    // Features allowed for FREE tier
    const freeFeatures = ["mood_rooms", "breathing_room", "quiet_hours", "check_in", "text_messaging", "image_messaging"];
    if (feature_id && freeFeatures.includes(feature_id)) {
      entitled = true;
    }

    return new Response(
      JSON.stringify({
        entitled,
        tier,
        status,
        expires_at: validUntil?.toISOString(),
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
