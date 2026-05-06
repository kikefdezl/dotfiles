import { RULES, type PathRule } from "./rules.js";

/**
 * Compiles a simple wildcard string into a RegExp for path matching.
 * Examples:
 * - ".env" -> matches ".env" exactly or within a path like "dir/.env"
 * - ".env.*" -> matches ".env.local", ".env.test", etc.
 */
export function compileMatch(match: string): RegExp {
  // Escape regex special chars EXCEPT '*'
  let regexStr = match.replace(/[.+?^${}()|[\]\\]/g, "\\$&");

  // Convert '*' to '.*'
  regexStr = regexStr.replace(/\*/g, ".*");

  // Ensure it matches as a distinct path segment or file
  return new RegExp(`(?:^|/)${regexStr}(?:/|$)`, "i");
}

export function findMatchingRule(pathToCheck: string): PathRule | undefined {
  for (const rule of RULES) {
    for (const matchStr of rule.matches) {
      const regex = compileMatch(matchStr);
      if (regex.test(pathToCheck)) {
        return rule;
      }
    }
  }
  return undefined;
}
