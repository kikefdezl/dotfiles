export type RuleAction = "ask" | "reject";

export interface PathRule {
  matches: string[];
  action: RuleAction;
  message?: string;
}

export const RULES: PathRule[] = [
  {
    matches: [".env", ".env.*"],
    action: "reject",
    message: "Access to sensitive environment files is blocked.",
  },
];
