import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const firebaseServiceAccount = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT') || '{}')

const supabase = createClient(supabaseUrl, supabaseServiceKey)

async function getAccessToken() {
  const { client_email, private_key } = firebaseServiceAccount
  if (!client_email || !private_key) {
    throw new Error('FIREBASE_SERVICE_ACCOUNT environment variable is missing')
  }

  const { default: jwt } = await import("https://esm.sh/jsonwebtoken@9.0.0")
  
  const now = Math.floor(Date.now() / 1000)
  const payload = {
    iss: client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    exp: now + 3600,
    iat: now,
  }

  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt.sign(payload, private_key, { algorithm: "RS256" }),
    }),
  })

  const { access_token } = await tokenResponse.json()
  return access_token
}

serve(async (req) => {
  try {
    const { user_ids, title, body, data, notification_type } = await req.json()

    if (!user_ids || !Array.isArray(user_ids)) {
      return new Response("Missing user_ids array", { status: 400 })
    }

    const accessToken = await getAccessToken()
    const projectId = firebaseServiceAccount.project_id

    // Fetch tokens for these users
    const { data: devices, error } = await supabase
      .from('user_devices')
      .select('fcm_token, user_id')
      .in('user_id', user_ids)

    if (error || !devices) {
      return new Response("Error fetching devices", { status: 500 })
    }

    const results = []
    for (const device of devices) {
      // Messaging Style Grouping Logic
      const threadId = data.room_id || data.sender_id || 'default_thread'
      
      const fcmPayload = {
        message: {
          token: device.fcm_token,
          notification: { 
            title: title || 'Tether', 
            body: body || 'New notification' 
          },
          data: {
            ...data,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            type: notification_type,
            thread_id: threadId,
          },
          android: {
            priority: "high",
            ttl: "86400s", // 24 hours
            notification: {
              channel_id: "high_importance_channel",
              icon: "ic_launcher",
              color: "#6750A4",
              tag: threadId, // Groups notifications from same thread on Android
              notification_priority: "PRIORITY_MAX",
              default_sound: true,
              default_vibrate_timings: true,
            },
          },
          apns: {
            headers: {
              "apns-priority": "10",
              "apns-topic": "com.tether.app", // Adjust to actual bundle ID if known
            },
            payload: {
              aps: {
                "thread-id": threadId, // Groups notifications on iOS
                contentAvailable: true,
                mutableContent: true, // Allows notification service extension to decrypt
                sound: "default",
                badge: 1,
              },
            },
          },
        },
      }

      const fcmResponse = await fetch(
        `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify(fcmPayload),
        }
      )
      
      const result = await fcmResponse.json()
      results.push({ user_id: device.user_id, result })
    }

    return new Response(JSON.stringify({ success: true, results }), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    })
  }
})
