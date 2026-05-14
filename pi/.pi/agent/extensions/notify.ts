import { type ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async (event, ctx) => {
    // Only notify in interactive mode (ignores subagents running in JSON/RPC mode)
    if (!ctx.hasUI) {
      return;
    }

    try {
      await pi.exec("notify-send", ["Pi agent finished responding"]);
    } catch (err) {
      // Silently ignore notification errors
    }
  });
}
