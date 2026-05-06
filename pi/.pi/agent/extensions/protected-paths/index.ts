import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { findMatchingRule } from "./evaluator.js";
import { askForUserPermission } from "./ui.js";

/** Extracts path parameters from native tools */
function extractNativePaths(input: Record<string, unknown>): string[] {
  return [
    input.path,
    ...(Array.isArray(input.paths) ? input.paths : []),
    input.directory,
    ...(Array.isArray(input.directories) ? input.directories : []),
    ...(Array.isArray(input.files) ? input.files : []),
  ].filter((val) => typeof val === "string") as string[];
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    // 1. Gather all paths we need to check
    let pathsToCheck: string[] = [];

    if (event.toolName === "bash" && typeof event.input.command === "string") {
      // For bash, we check the entire command string to see if it references a protected file
      pathsToCheck = [event.input.command];
    } else {
      // For native tools (read, write, etc), extract the targeted paths
      pathsToCheck = extractNativePaths(event.input);
    }

    // 2. Evaluate paths against our rules
    for (const pathStr of pathsToCheck) {
      const rule = findMatchingRule(pathStr);
      if (!rule) continue;

      if (rule.action === "reject") {
        return {
          block: true,
          reason:
            rule.message || `Access to guarded path "${pathStr}" is blocked.`,
        };
      }

      if (rule.action === "ask") {
        if (!ctx.hasUI) {
          return {
            block: true,
            reason: `Path access requires user confirmation, but no UI is available: ${pathStr}`,
          };
        }

        const allowed = await askForUserPermission(
          event.toolName,
          pathStr,
          rule.message,
          ctx,
        );
        if (!allowed) {
          return { block: true, reason: "Path access denied by the user." };
        }
      }
    }

    return undefined;
  });
}
