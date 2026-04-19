-- 0011_notification_triggers.sql

-- Enable the "pg_net" extension for HTTP requests
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- Helper function to call the push-notifier Edge Function
CREATE OR REPLACE FUNCTION public.send_push_notification(
  user_ids UUID[],
  title TEXT,
  body TEXT,
  data JSONB DEFAULT '{}'::jsonb,
  notification_type TEXT DEFAULT 'general'
)
RETURNS VOID AS $$
BEGIN
  -- Call the Edge Function via pg_net.http_post
  PERFORM net.http_post(
    url := 'https://uqkkhpunwuvkwaqdqqtw.supabase.co/functions/v1/push-notifier',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key', true)
    ),
    body := jsonb_build_object(
      'user_ids', user_ids,
      'title', title,
      'body', body,
      'data', data,
      'notification_type', notification_type
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. Trigger for New Messages
CREATE OR REPLACE FUNCTION public.on_new_message_notify()
RETURNS TRIGGER AS $$
DECLARE
  sender_name TEXT;
BEGIN
  SELECT display_name INTO sender_name FROM profiles WHERE id = NEW.sender_id;
  
  PERFORM public.send_push_notification(
    ARRAY[NEW.receiver_id],
    sender_name || ' sent you a message',
    CASE 
      WHEN NEW.content_type = 'text' THEN 'A new message is waiting for you'
      WHEN NEW.content_type = 'image' THEN 'Sent you a photo'
      WHEN NEW.content_type = 'voice' THEN 'Sent you a voice note'
      ELSE 'Sent you a message'
    END,
    jsonb_build_object('sender_id', NEW.sender_id, 'circle_id', NEW.circle_id),
    'chat'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_on_new_message_notify ON messages;
CREATE TRIGGER trigger_on_new_message_notify
  AFTER INSERT ON messages
  FOR EACH ROW EXECUTE PROCEDURE public.on_new_message_notify();

-- 2. Trigger for SOS Alerts
CREATE OR REPLACE FUNCTION public.on_sos_alert_notify()
RETURNS TRIGGER AS $$
DECLARE
  sender_name TEXT;
  member_ids UUID[];
BEGIN
  SELECT display_name INTO sender_name FROM profiles WHERE id = NEW.user_id;
  
  -- Get all other members in the circle
  SELECT array_agg(user_id) INTO member_ids
  FROM circle_members
  WHERE circle_id = NEW.circle_id AND user_id != NEW.user_id;
  
  IF member_ids IS NOT NULL THEN
    PERFORM public.send_push_notification(
      member_ids,
      'EMERGENCY SOS: ' || sender_name,
      sender_name || ' has triggered an SOS alert! Please check in.',
      jsonb_build_object('circle_id', NEW.circle_id, 'alert_id', NEW.id),
      'sos'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_on_sos_alert_notify ON sos_alerts;
CREATE TRIGGER trigger_on_sos_alert_notify
  AFTER INSERT ON sos_alerts
  FOR EACH ROW EXECUTE PROCEDURE public.on_sos_alert_notify();

-- 3. Trigger for Family Safety Checks
CREATE OR REPLACE FUNCTION public.on_safety_check_notify()
RETURNS TRIGGER AS $$
DECLARE
  sender_name TEXT;
  member_ids UUID[];
BEGIN
  SELECT display_name INTO sender_name FROM profiles WHERE id = NEW.triggered_by;
  
  -- Get all other members in the circle
  SELECT array_agg(user_id) INTO member_ids
  FROM circle_members
  WHERE circle_id = NEW.circle_id AND user_id != NEW.triggered_by;
  
  IF member_ids IS NOT NULL THEN
    PERFORM public.send_push_notification(
      member_ids,
      'Family Safety Check',
      sender_name || ' started a safety check for the circle.',
      jsonb_build_object('circle_id', NEW.circle_id, 'check_id', NEW.id),
      'safety_check'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_on_safety_check_notify ON family_safety_checks;
CREATE TRIGGER trigger_on_safety_check_notify
  AFTER INSERT ON family_safety_checks
  FOR EACH ROW EXECUTE PROCEDURE public.on_safety_check_notify();

-- 4. Trigger for Digital Hugs
CREATE OR REPLACE FUNCTION public.on_digital_hug_notify()
RETURNS TRIGGER AS $$
DECLARE
  sender_name TEXT;
BEGIN
  SELECT display_name INTO sender_name FROM profiles WHERE id = NEW.sender_id;
  
  PERFORM public.send_push_notification(
    ARRAY[NEW.receiver_id],
    'A Digital Hug',
    sender_name || ' sent you a digital hug.',
    jsonb_build_object('sender_id', NEW.sender_id, 'circle_id', NEW.circle_id),
    'hug'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_on_digital_hug_notify ON digital_hugs;
CREATE TRIGGER trigger_on_digital_hug_notify
  AFTER INSERT ON digital_hugs
  FOR EACH ROW EXECUTE PROCEDURE public.on_digital_hug_notify();
