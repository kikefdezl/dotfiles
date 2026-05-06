import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { findMatchingRule } from "./evaluator.js";
import { askForUserPermission } from "./ui.js";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash" || typeof event.input.command !== "string") {
      return undefined;
    }

    const command = event.input.command;
    const rule = findMatchingRule(command);

    if (!rule) {
      return undefined; // No rule matched, allow execution
    }

    if (rule.action === "reject") {
      return {
        block: true,
        reason:
          rule.message ||
          "This bash command is explicitly blocked by guardrails.",
      };
    }

    if (rule.action === "ask") {
      if (!ctx.hasUI) {
        return {
          block: true,
          reason: `Command requires user confirmation, but no UI is available: ${command}`,
        };
      }

      const allowed = await askForUserPermission(command, rule.message, ctx);
      if (!allowed) {
        return { block: true, reason: "Execution denied by the user." };
      }
    }

    return undefined;
  });
}
