import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { discoverAgents } from "./agents.js";

export function registerAgentSwitcher(pi: ExtensionAPI) {
  let activeAgentName: string | null = null;

  pi.on("session_start", async (_event, ctx) => {
    activeAgentName = null;

    for (const entry of ctx.sessionManager.getEntries()) {
      if (entry.type === "custom" && entry.customType === "active-agent") {
        activeAgentName = entry.data.agentName;
      }
    }

    if (ctx.hasUI && activeAgentName) {
      ctx.ui.setStatus(
        "active-agent",
        ctx.ui.theme.fg("accent", `👤 ${activeAgentName}`),
      );
    }
  });

  pi.registerCommand("agent", {
    description: "Switch the active agent mid-session",
    handler: async (args, ctx) => {
      // Get agents from user and project scope
      const { agents } = discoverAgents(ctx.cwd, "both");

      if (agents.length === 0) {
        ctx.ui.notify("No agents found.", "error");
        return;
      }

      let selectedAgent = agents.find((a) => a.name === args?.trim());

      if (!selectedAgent) {
        if (args && args.trim() !== "") {
          ctx.ui.notify(`Agent '${args}' not found.`, "warning");
        }

        const options = agents.map(
          (a) =>
            `${a.name} (${a.source})${a.description ? ` - ${a.description}` : ""}`,
        );
        options.unshift("default - Built-in pi agent");

        const choice = await ctx.ui.select(
          "Select an agent to switch to:",
          options,
        );

        if (!choice) return;

        if (choice.startsWith("default")) {
          activeAgentName = null;
        } else {
          const agentName = choice.split(" ")[0]; // Get the part before ' (source)'
          selectedAgent = agents.find((a) => a.name === agentName);
          if (selectedAgent) activeAgentName = selectedAgent.name;
        }
      } else {
        activeAgentName = selectedAgent.name;
      }

      pi.appendEntry("active-agent", { agentName: activeAgentName });

      ctx.ui.notify(
        activeAgentName
          ? `Switched to agent: ${activeAgentName}`
          : "Restored default pi agent",
        "info",
      );

      await ctx.reload();
    },
  });

  pi.on("before_agent_start", async (event, ctx) => {
    if (!activeAgentName) return undefined;

    const { agents } = discoverAgents(ctx.cwd, "both");
    const agent = agents.find((a) => a.name === activeAgentName);

    if (!agent) return undefined;

    // Apply custom tools if specified in the agent's frontmatter
    if (agent.tools && agent.tools.length > 0) {
      const allTools = pi.getAllTools().map((t) => t.name);
      const validTools = agent.tools.filter((t) => allTools.includes(t));
      pi.setActiveTools(validTools);
    }

    return {
      systemPrompt: agent.systemPrompt,
    };
  });
}
