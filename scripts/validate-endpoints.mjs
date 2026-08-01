import { isIP } from "node:net";
import { readdirSync, readFileSync } from "node:fs";
import { join, relative } from "node:path";

const errors = [];

function jsonFiles(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const entryPath = join(directory, entry.name);

    if (entry.isDirectory()) {
      return jsonFiles(entryPath);
    }

    return entry.isFile() && entry.name.endsWith(".json") ? [entryPath] : [];
  });
}

function validateUrl(value, location, requireIp = false) {
  let parsed;

  try {
    parsed = new URL(value);
  } catch {
    errors.push(
      `${location}: expected an absolute URL, got ${JSON.stringify(value)}`,
    );
    return;
  }

  if (!["http:", "https:"].includes(parsed.protocol)) {
    errors.push(`${location}: expected an HTTP(S) URL, got ${parsed.protocol}`);
  }

  if (requireIp && !isIP(parsed.hostname)) {
    errors.push(`${location}: alt_ip hostname must be a literal IP address`);
  }
}

function walk(value, location) {
  if (!value || typeof value !== "object") {
    return;
  }

  if (
    Array.isArray(value.list) &&
    value.list.every(
      (item) => item && typeof item === "object" && "url" in item,
    )
  ) {
    const seenUrls = new Set();

    value.list.forEach((endpoint, index) => {
      const endpointLocation = `${location}.list[${index}]`;

      if (typeof endpoint.url !== "string" || !endpoint.url) {
        errors.push(`${endpointLocation}.url: expected a non-empty string`);
      } else {
        validateUrl(endpoint.url, `${endpointLocation}.url`);

        if (seenUrls.has(endpoint.url)) {
          errors.push(
            `${endpointLocation}.url: duplicate endpoint ${endpoint.url}`,
          );
        }

        seenUrls.add(endpoint.url);
      }

      if ("alt_ip" in endpoint) {
        if (typeof endpoint.alt_ip !== "string" || !endpoint.alt_ip) {
          errors.push(
            `${endpointLocation}.alt_ip: expected a non-empty string`,
          );
        } else {
          validateUrl(endpoint.alt_ip, `${endpointLocation}.alt_ip`, true);
        }
      }
    });
  }

  for (const [key, child] of Object.entries(value)) {
    walk(child, `${location}.${key}`);
  }
}

for (const file of jsonFiles("assets")) {
  walk(JSON.parse(readFileSync(file, "utf8")), relative(".", file));
}

if (errors.length) {
  console.error(errors.join("\n"));
  process.exitCode = 1;
} else {
  console.log("All node and service endpoint lists are structurally valid");
}
