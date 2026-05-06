export type RuleAction = "ask" | "reject";

export interface BashRule {
  matches: string[];
  action: RuleAction;
  message?: string;
}

export const RULES: BashRule[] = [
  {
    matches: ["git add", "git add *", "git commit", "git commit *"],
    action: "reject",
    message: "This command is explicitly disallowed by repository rules.",
  },
  {
    matches: ["terraform apply", "terraform apply *", "tf apply", "tf apply *"],
    action: "reject",
    message: "Terraform apply is explicitly disallowed by repository rules.",
  },
  {
    matches: ["gcloud", "gcloud *"],
    action: "reject",
    message: "gcloud commands are explicitly disallowed by repository rules.",
  },
  {
    matches: ["rm -rf *"],
    action: "ask",
  },
];
