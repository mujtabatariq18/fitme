/**
 * FitMe — AI Proxy Edge Function
 * ================================
 * Keeps provider API keys server-side by acting as a thin proxy between the
 * Flutter app and the AI vendor (OpenRouter / OpenAI / Anthropic).
 *
 * POST /functions/v1/ai-proxy
 * Headers:
 *   Authorization: Bearer <supabase-jwt>   (required)
 *   Content-Type:  application/json
 * Body:
 *   {
 *     "provider": "openrouter" | "openai" | "anthropic",
 *     "model":    "<model-id>",
 *     "messages": [ { "role": "user" | "assistant" | "system", "content": "..." }, ... ],
 *     "max_tokens": 1024          // optional, default 1024
 *   }
 *
 * Environment secrets (set via `supabase secrets set KEY=value`):
 *   OPENROUTER_API_KEY
 *   OPENAI_API_KEY
 *   ANTHROPIC_API_KEY
 *
 * Deploy:
 *   supabase functions deploy ai-proxy
 */

const CORS_HEADERS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ---------------------------------------------------------------------------
// Vendor endpoint registry
// ---------------------------------------------------------------------------
interface VendorConfig {
  endpoint: string;
  envKey: string;
  /** Transform the generic request body to the vendor's expected shape. */
  buildBody: (model: string, messages: Message[], maxTokens: number) => unknown;
  /** Additional headers required by the vendor. */
  extraHeaders?: (apiKey: string) => Record<string, string>;
}

interface Message {
  role: "system" | "user" | "assistant";
  content: string;
}

const VENDORS: Record<string, VendorConfig> = {
  openrouter: {
    endpoint: "https://openrouter.ai/api/v1/chat/completions",
    envKey: "OPENROUTER_API_KEY",
    buildBody: (model, messages, max_tokens) => ({
      model,
      messages,
      max_tokens,
    }),
    extraHeaders: (_key) => ({
      "HTTP-Referer": "https://fitme.app",
      "X-Title": "FitMe",
    }),
  },
  openai: {
    endpoint: "https://api.openai.com/v1/chat/completions",
    envKey: "OPENAI_API_KEY",
    buildBody: (model, messages, max_tokens) => ({
      model,
      messages,
      max_tokens,
    }),
  },
  anthropic: {
    endpoint: "https://api.anthropic.com/v1/messages",
    envKey: "ANTHROPIC_API_KEY",
    buildBody: (model, messages, max_tokens) => {
      // Anthropic separates the system prompt from the messages array.
      const system = messages.find((m) => m.role === "system")?.content ?? "";
      const filtered = messages.filter((m) => m.role !== "system");
      return { model, system, messages: filtered, max_tokens };
    },
    extraHeaders: (_key) => ({
      "anthropic-version": "2023-06-01",
      "x-api-key": _key,
    }),
  },
};

// ---------------------------------------------------------------------------
// Request handler
// ---------------------------------------------------------------------------
Deno.serve(async (req: Request) => {
  // Handle CORS pre-flight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: CORS_HEADERS });
  }

  // Only accept POST
  if (req.method !== "POST") {
    return jsonError("Method not allowed", 405);
  }

  // ---- Auth check ---------------------------------------------------------
  // We verify that a Supabase JWT was provided.  Full token verification is
  // handled automatically by the Supabase gateway when the function is invoked
  // via the client SDK.  Here we just guard against unauthenticated raw calls.
  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) {
    return jsonError("Missing or invalid Authorization header", 401);
  }
  // Note: the Supabase edge-function runtime validates the JWT signature
  // before the function body runs when using the standard invocation path.
  // The check above is an additional safety net for direct HTTP calls.

  // ---- Parse body ---------------------------------------------------------
  let body: {
    provider?: string;
    model?: string;
    messages?: Message[];
    max_tokens?: number;
  };

  try {
    body = await req.json();
  } catch {
    return jsonError("Invalid JSON body", 400);
  }

  const { provider, model, messages, max_tokens = 1024 } = body;

  if (!provider || !model || !Array.isArray(messages) || messages.length === 0) {
    return jsonError("Body must include provider, model, and a non-empty messages array", 400);
  }

  // ---- Vendor lookup -------------------------------------------------------
  const vendor = VENDORS[provider.toLowerCase()];
  if (!vendor) {
    return jsonError(
      `Unknown provider "${provider}". Supported: ${Object.keys(VENDORS).join(", ")}`,
      400,
    );
  }

  const apiKey = Deno.env.get(vendor.envKey) ?? "";
  if (!apiKey) {
    // Secret not configured — return a clear server-side error (not the missing key itself).
    return jsonError(`Server secret ${vendor.envKey} is not configured`, 500);
  }

  // ---- Proxy to vendor -----------------------------------------------------
  const vendorBody = vendor.buildBody(model, messages, max_tokens);

  const vendorHeaders: Record<string, string> = {
    "Content-Type": "application/json",
    // Most vendors use Bearer auth; Anthropic overrides via extraHeaders.
    ...(provider !== "anthropic" ? { Authorization: `Bearer ${apiKey}` } : {}),
    ...(vendor.extraHeaders ? vendor.extraHeaders(apiKey) : {}),
  };

  let vendorResponse: Response;
  try {
    vendorResponse = await fetch(vendor.endpoint, {
      method: "POST",
      headers: vendorHeaders,
      body: JSON.stringify(vendorBody),
    });
  } catch (err) {
    return jsonError(`Failed to reach vendor: ${(err as Error).message}`, 502);
  }

  // Stream the vendor's response body back to the caller, preserving status.
  return new Response(vendorResponse.body, {
    status: vendorResponse.status,
    headers: {
      ...CORS_HEADERS,
      "Content-Type": vendorResponse.headers.get("content-type") ?? "application/json",
    },
  });
});

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
function jsonError(message: string, status: number): Response {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}
