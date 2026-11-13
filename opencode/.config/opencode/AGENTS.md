# Minimalism

Less lines of code is better. Treat code as a cost, not an asset. Every line adds context length, reading effort, and maintenance burden.

- **Optimize for simplicity and brevity.** Write plain, direct code that does strictly what is needed and nothing more. Avoid walls of code, ceremony, and unnecessary defensive checking.
- **Require necessity, not plausibility.** Do not add code, abstractions, data, or checks just because they look "complete" or guard against hypothetical cases that won't happen in practice. Everything you introduce must justify its existence against an actual, present need.
- **Think critically and prune.** When drafting a plan or writing code, question your own output: *What breaks if this is omitted? Can this be expressed more directly in fewer lines?* Default to leaving things out until they are genuinely required.
- **Treat deleting code as a win** But you should never comprimise the quality by deleting critical code or tests.
