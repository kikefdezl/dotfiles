import { RULES, type BashRule } from "./rules.js";

/**
 * Compiles a human-readable wildcard string into a RegExp.
 * Examples:
 * - "cat" -> matches "cat" and "cat file"
 * - "git *" -> matches "git" followed by anything
 */
export function compileMatch(match: string): RegExp {
	const endsWithStar = match.trim().endsWith('*');
	
	// Escape regex special chars EXCEPT '*'
	let regexStr = match.replace(/[.+?^${}()|[\]\\]/g, '\\$&');
	
	// Convert '*' to '.*'
	regexStr = regexStr.replace(/\*/g, '.*');
	
	// Convert spaces to '\s+' to be forgiving with multiple spaces
	regexStr = regexStr.replace(/ /g, '\\s+');
	
	if (endsWithStar) {
		return new RegExp(`\\b${regexStr}`, 'i');
	} else {
		// Anchor the end of the command with a space or end of string
		// This prevents "cat" from matching "catch", but allows "cat file.txt"
		return new RegExp(`\\b${regexStr}(?:\\s|$)`, 'i');
	}
}

export function findMatchingRule(command: string): BashRule | undefined {
	for (const rule of RULES) {
		for (const matchStr of rule.matches) {
			const regex = compileMatch(matchStr);
			if (regex.test(command)) {
				return rule;
			}
		}
	}
	return undefined;
}
