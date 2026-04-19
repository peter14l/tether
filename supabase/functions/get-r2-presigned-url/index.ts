import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { S3Client, GetObjectCommand, PutObjectCommand } from "https://esm.sh/@aws-sdk/client-s3";
import { getSignedUrl } from "https://esm.sh/@aws-sdk/s3-request-presigner";

const R2_ACCESS_KEY_ID = Deno.env.get('R2_ACCESS_KEY_ID')!
const R2_SECRET_ACCESS_KEY = Deno.env.get('R2_SECRET_ACCESS_KEY')!
const R2_BUCKET_NAME = Deno.env.get('R2_BUCKET_NAME')!
const R2_ENDPOINT = Deno.env.get('R2_ENDPOINT')! 

const s3Client = new S3Client({
  region: "auto",
  endpoint: R2_ENDPOINT,
  credentials: {
    accessKeyId: R2_ACCESS_KEY_ID,
    secretAccessKey: R2_SECRET_ACCESS_KEY,
  },
});

serve(async (req) => {
  try {
    const { file_name, content_type, method } = await req.json()

    if (!file_name || !method) {
      return new Response(JSON.stringify({ error: "Missing file_name or method" }), { status: 400 })
    }

    let url: string
    if (method === 'PUT') {
      const command = new PutObjectCommand({
        Bucket: R2_BUCKET_NAME,
        Key: file_name,
        ContentType: content_type || 'application/octet-stream',
      });
      url = await getSignedUrl(s3Client, command, { expiresIn: 3600 });
    } else if (method === 'GET') {
      const command = new GetObjectCommand({
        Bucket: R2_BUCKET_NAME,
        Key: file_name,
      });
      url = await getSignedUrl(s3Client, command, { expiresIn: 3600 });
    } else {
      return new Response(JSON.stringify({ error: "Invalid method" }), { status: 400 })
    }

    return new Response(JSON.stringify({ url, key: file_name }), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    })
  }
})
