import type { ExtensionContext } from "@mariozechner/pi-coding-agent";

export async function askForUserPermission(
	command: string,
	reason?: string,
	ctx?: ExtensionContext
): Promise<boolean> {
	if (!ctx?.hasUI) return false;

	const details = reason ? `\nReason: ${reason}\n` : "";
	const choice = await ctx.ui.select(
		`⚠️ The agent is trying to execute a guarded bash command:\n\nCommand: ${command}${details}\nAllow this execution?`,
		["No", "Yes"]
	);

	return choice === "Yes";
}
