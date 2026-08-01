import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import test from "node:test";

const validator = fileURLToPath(
  new URL("./validate-endpoints.mjs", import.meta.url),
);

function runValidator(files) {
  const directory = mkdtempSync(join(tmpdir(), "wallet-endpoints-"));

  try {
    for (const [path, contents] of Object.entries(files)) {
      const destination = join(directory, "assets", path);
      mkdirSync(dirname(destination), { recursive: true });
      writeFileSync(destination, JSON.stringify(contents));
    }

    return spawnSync(process.execPath, [validator], {
      cwd: directory,
      encoding: "utf8",
    });
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

test("reports validation errors in deterministic file order", () => {
  const result = runValidator({
    "z/info.json": { nodes: { list: [{ url: "invalid-z" }] } },
    "a/info.json": { nodes: { list: [{ url: "invalid-a" }] } },
  });

  assert.equal(result.status, 1);
  assert.deepEqual(result.stderr.trim().split("\n"), [
    'assets/a/info.json.nodes.list[0].url: expected an absolute URL, got "invalid-a"',
    'assets/z/info.json.nodes.list[0].url: expected an absolute URL, got "invalid-z"',
  ]);
});

test("reports malformed entries in an endpoint list", () => {
  const result = runValidator({
    "coin/info.json": {
      nodes: {
        list: [
          { alt_ip: "http://127.0.0.1" },
          null,
          { url: "https://node.example" },
        ],
      },
    },
  });

  assert.equal(result.status, 1);
  assert.deepEqual(result.stderr.trim().split("\n"), [
    "assets/coin/info.json.nodes.list[0].url: expected a non-empty string",
    "assets/coin/info.json.nodes.list[1]: expected an endpoint object",
  ]);
});
