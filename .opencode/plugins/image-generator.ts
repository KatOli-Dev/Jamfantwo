import { tool } from "@opencode-ai/plugin";
import type { Plugin } from "@opencode-ai/plugin";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";

const plugin: Plugin = async ({ directory }) => {
  const secretsPath = join(directory, ".opencode", "secrets.json");
  let apiKey = "";
  let baseURL = "https://api.openai.com/v1";

  let defaultModel: string | undefined;

  try {
    const raw = await readFile(secretsPath, "utf-8");
    const secrets = JSON.parse(raw);
    apiKey = secrets.image?.apiKey ?? secrets.OPENAI_API_KEY ?? "";
    baseURL = secrets.image?.baseURL ?? secrets.OPENAI_BASE_URL ?? "https://api.openai.com/v1";
    defaultModel = secrets.image?.model;
  } catch {
    /* secrets file absent or malformed — tool will return an error */
  }

  const detectFormat = (buf: Buffer): { ext: string; mime: string } => {
    if (buf[0] === 0xff && buf[1] === 0xd8 && buf[2] === 0xff)
      return { ext: ".jpg", mime: "image/jpeg" };
    if (buf[0] === 0x89 && buf[1] === 0x50 && buf[2] === 0x4e && buf[3] === 0x47)
      return { ext: ".png", mime: "image/png" };
    if (buf[0] === 0x52 && buf[1] === 0x49 && buf[2] === 0x46 && buf[3] === 0x46)
      return { ext: ".webp", mime: "image/webp" };
    if (buf[0] === 0x47 && buf[1] === 0x49 && buf[2] === 0x46)
      return { ext: ".gif", mime: "image/gif" };
    if (buf[0] === 0x42 && buf[1] === 0x4d)
      return { ext: ".bmp", mime: "image/bmp" };
    return { ext: ".png", mime: "image/png" };
  };

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
      image_generate: tool({
        description:
          "Generate an image from a text description using an AI image generation API. " +
          "Downloads images to the project's temp/ directory and returns local file paths.",
        args: {
          prompt: tool.schema
            .string()
            .describe("detailed description of the image to generate"),
          size: tool.schema
            .string()
            .optional()
            .describe('image size in WxH format, e.g. "1024x1024" (default: 1024x1024)'),
          n: tool.schema
            .number()
            .optional()
            .describe("number of images to return (default: 1)"),
          model: tool.schema
            .string()
            .optional()
            .describe("model to use (e.g. dall-e-3, dall-e-2; defaults to the API's default)"),
        },
        execute: async (args) => {
          if (!apiKey) {
            return {
              title: "image_generate",
              output:
                "No API key configured for image generation. " +
                "Add an `image` section with `apiKey` to `.opencode/secrets.json`. " +
                'See `.opencode/secrets.example.json` for the expected shape.',
            };
          }

          const payload: Record<string, unknown> = {
            prompt: args.prompt,
            n: args.n ?? 1,
            size: args.size ?? "1024x1024",
          };
          if (args.model) payload.model = args.model;
          else if (defaultModel) payload.model = defaultModel;

          try {
            const res = await fetch(`${baseURL}/images/generations`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${apiKey}`,
              },
              body: JSON.stringify(payload),
            });

            const body = await res.text();

            if (!res.ok) {
              return {
                title: "image_generate",
                output: `Image API returned ${res.status}: ${redact(body)}`,
              };
            }

            const json = JSON.parse(body);
            const slug = args.prompt
              .toLowerCase()
              .replace(/[^a-z0-9]+/g, "-")
              .replace(/^-+|-+$/g, "")
              .slice(0, 60);
            const ts = Date.now();
            const tempDir = join(directory, "temp");
            await mkdir(tempDir, { recursive: true });

            const localFiles: string[] = [];
            const attachments: {
              type: "file";
              mime: string;
              url: string;
              filename: string;
            }[] = [];

            for (const [i, datum] of json.data.entries()) {
              let buffer: Buffer;

              if (datum.b64_json) {
                buffer = Buffer.from(datum.b64_json, "base64");
              } else if (datum.url) {
                const imgRes = await fetch(datum.url);
                if (!imgRes.ok) {
                  localFiles.push(`[${i + 1}] failed to download: HTTP ${imgRes.status}`);
                  continue;
                }
                buffer = Buffer.from(await imgRes.arrayBuffer());
              } else {
                localFiles.push(`[${i + 1}] no image data returned`);
                continue;
              }

              const { ext, mime } = detectFormat(buffer);
              const filename = `${slug}-${ts}-${i}${ext}`;
              const filepath = join(tempDir, filename);
              await writeFile(filepath, buffer);
              localFiles.push(`[${i + 1}] ${filename}`);
              attachments.push({ type: "file", mime, url: filepath, filename });
            }

            const revised =
              json.data[0]?.revised_prompt
                ? `\n\n(revised prompt: ${json.data[0].revised_prompt})`
                : "";

            return {
              title: "image_generate",
              output: `Generated ${localFiles.length} image(s) in temp/:\n${localFiles.join("\n")}${revised}`,
              metadata: {
                model: json.model ?? "unknown",
                created: json.created,
                n: args.n ?? 1,
              },
              attachments,
            };
          } catch (err: unknown) {
            const msg = err instanceof Error ? err.message : String(err);
            return {
              title: "image_generate",
              output: `Image generation request failed: ${redact(msg)}`,
            };
          }
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
