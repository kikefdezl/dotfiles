import type { ExtensionContext } from "@mariozechner/pi-coding-agent";

export async function askForUserPermission(
	toolName: string,
	rawPath: string,
	reason?: string,
	ctx?: ExtensionContext
): Promise<boolean> {
	if (!ctx?.hasUI) return false;

	const details = reason ? `\nReason: ${reason}\n` : "";
	const choice = await ctx.ui.select(
		`⚠️ The agent is trying to access a guarded path:\n\nTool: ${toolName}\nPath: ${rawPath}${details}\nAllow this access?`,
		["No", "Yes"]
	);

	return choice === "Yes";
}
