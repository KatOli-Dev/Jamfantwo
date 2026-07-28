import { tool } from "@opencode-ai/plugin";
import type { Plugin } from "@opencode-ai/plugin";
import { readFile } from "node:fs/promises";
import { join } from "node:path";

const plugin: Plugin = async ({ directory }) => {
  const secretsPath = join(directory, ".opencode", "secrets.json");
  let apiKey = "";
  let baseURL = "https://api.openai.com/v1";
  let defaultModel = "mistralai/ministral-14b-instruct-2512";

  try {
    const raw = await readFile(secretsPath, "utf-8");
    const secrets = JSON.parse(raw);
    apiKey = secrets.validator?.apiKey ?? secrets.validate?.apiKey ?? secrets.image?.apiKey ?? secrets.OPENAI_API_KEY ?? "";
    baseURL = secrets.validator?.baseURL ?? secrets.validate?.baseURL ?? secrets.image?.baseURL ?? secrets.OPENAI_BASE_URL ?? "https://api.openai.com/v1";
    defaultModel = secrets.validator?.model ?? secrets.validate?.model ?? "mistralai/ministral-14b-instruct-2512";
  } catch {
    /* secrets file absent or malformed */
  }

  const redact = (text: string): string => {
    return apiKey ? text.split(apiKey).join("[REDACTED]") : text;
  };

  const redactObj = (obj: unknown): unknown => {
    if (!apiKey) return obj;
    const raw = JSON.stringify(obj);
    return raw.includes(apiKey) ? JSON.parse(raw.split(apiKey).join("[REDACTED]")) : obj;
  };

  return {
    tool: {
      image_validate: tool({
        description:
          "Validate that a generated image matches its text prompt using a vision model. " +
          "Also checks for NSFW content. Returns PASS or FAIL with a reason.",
        args: {
          image_path: tool.schema
            .string()
            .describe("Path to the image file to validate"),
          prompt: tool.schema
            .string()
            .describe("The original text prompt used to generate the image"),

        },
        execute: async (args) => {
          if (!apiKey) {
            return {
              title: "image_validate",
              output:
                "No API key configured for validation. " +
                "Add a `validate` section to `.opencode/secrets.json`. " +
                "See `.opencode/secrets.example.json` for the expected shape.",
            };
          }

          let imageBuffer: Buffer;
          try {
            imageBuffer = await readFile(args.image_path);
          } catch {
            return {
              title: "image_validate",
              output: `Could not read image at: ${args.image_path}`,
            };
          }

          const base64Image = imageBuffer.toString("base64");

          const mime =
            imageBuffer[0] === 0xff && imageBuffer[1] === 0xd8 && imageBuffer[2] === 0xff
              ? "image/jpeg"
              : imageBuffer[0] === 0x89 && imageBuffer[1] === 0x50 && imageBuffer[2] === 0x4e
                ? "image/png"
                : "image/webp";

          const payload: Record<string, unknown> = {
            model: defaultModel,
            messages: [
              {
                role: "user",
                content: [
                  {
                    type: "text",
                      text:
                      `You are an image validator. First, check whether this image could be considered ` +
                      `unsafe for a teenager. Reject anything with nudity (including partial or suggestive), ` +
                      `sexual content or innuendo, gore, violence, weapons, hate symbols, drug or alcohol ` +
                      `references, self-harm, bullying, horror themes, or disturbing imagery. ` +
                      `If it fails this check, answer: FAIL — content not suitable for teens. ` +
                      `Otherwise, does this image correctly depict the following? ` +
                      `Answer PASS or FAIL followed by a brief reason (one sentence). ` +
                      `Prompt: "${args.prompt}"`,
                  },
                  {
                    type: "image_url",
                    image_url: { url: `data:${mime};base64,${base64Image}` },
                  },
                ],
              },
            ],
            max_tokens: 100,
          };

          let body: string;
          try {
            const res = await fetch(`${baseURL}/chat/completions`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${apiKey}`,
              },
              body: JSON.stringify(payload),
            });

            body = await res.text();

            if (!res.ok) {
              return {
                title: "image_validate",
                output: `Validation API returned ${res.status}: ${redact(body)}`,
              };
            }
          } catch (err: unknown) {
            const msg = err instanceof Error ? err.message : String(err);
            return {
              title: "image_validate",
              output: `Validation request failed: ${redact(msg)}`,
            };
          }

          const json = JSON.parse(body);
          const content = json.choices?.[0]?.message?.content ?? "No response from model";

          const trimmed = content.trim();
          const isPass = /^PASS\b/i.test(trimmed);
          const reason = trimmed.replace(/^(PASS|FAIL)\s*:?\s*/i, "").trim();

          return {
            title: "image_validate",
            output: isPass
              ? `PASS: ${reason || "image matches prompt"}`
              : `FAIL: ${reason || "image does not match prompt"}`,
            metadata: {
              model: json.model ?? defaultModel,
              result: isPass ? "PASS" : "FAIL",
              prompt: args.prompt,
              reason,
            },
          };
        },
      }),
    },

    "tool.execute.after": async (_input, output) => {
      output.output = redact(output.output);
      if (output.metadata != null) {
        output.metadata = redactObj(output.metadata);
      }
    },
  };
};

export default plugin;
