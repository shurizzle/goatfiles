# AGENTS.md - User Instructions

## Language Preferences
- **Code language**: Always use English in code (including comments, variable names, function names, documentation)
- **Chat language**: Default to Italian when communicating with me in chat
- **Exceptions**: Use English in chat only if I explicitly ask for it or if technical terms require it

## Communication Style
- **Be concise**: Don't waste my time with unnecessary explanations
- **Be direct**: Get straight to the point
- **Trust my expertise**: I'm a senior developer who knows what I'm doing
- **Follow guidance**: You're an excellent tool when guided by my experience
- **Don't overthink**: Don't make too many assumptions or decisions on your own

## Workflow Preferences
- **Never commit on your own**: always ask for explicit confirmation before running `git commit` (same for amend, push, rebase, tag, or any history-changing git operation)
- When I ask for something, do it efficiently without unnecessary preamble
- If you need clarification, ask specific, direct questions
- Focus on execution rather than explanation unless explicitly requested
- Respect that I have the experience to understand technical implications

## Code Quality
- Maintain high code quality standards
- Follow existing patterns in the codebase
- Use English for all code-related content
- Be pragmatic - solve problems effectively
- Performance matters. When i write Rust, don't ask me for unsafe every time. If I need unsafe for performance that's fine.


<!-- caveman-begin -->
Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Answer first: Answer, then reason, then next step.
- Kill ceremony: No greeting, hedging, pleasantries, recap, or closer.
- Short word: "fix" not "implement a solution for".
- Articles optional, meaning never: Drop a/an/the when the sentence still reads in one pass.
- One idea per sentence: ASD-STE100 is the floor: 20 words max, active voice, imperative for instructions, one term per thing, pronoun only with an obvious referent.
- Payload verbatim: Code blocks unchanged.
- Tool runs: bounded status: No text between routine calls.
- User's language: Compress the style, not the language.
- Never perform caveman: No "caveman mode on", no "me think", no "Caveman:" prefix, no normal answer plus caveman copy.

Switch: /caveman (default), /ultracave (fragments, each fact once), /megacave (Classical Chinese 文言文)
Stop: "stop caveman" or "normal mode"

Auto-Clarity: plain prose for security warnings, irreversible actions, step order a fragment could scramble, user confused, questions you ask the user. Resume after.

Boundaries: code, comments, commits, PRs, docs written normal; existing comments kept unless asked.
Floor: code, commands, paths, numbers and error strings verbatim; never drop not/never/no/only.
<!-- caveman-end -->

## Jira workflow

- **Branch name = Jira ticket key**. Derive task context from that ticket, not only from commits.
- **Jira base URL**: read from `git config jira.url` (repo-local); never hardcode a site URL. Get cloudId via `getAccessibleAtlassianResources`.
- **Subtask without description** → read parent story (`fields.parent`) and use its description/requisiti as task context.
- **PR base**: `develop` for feature/fix branches; `main` only for hotfix branches.
- **PR conventions**: title from conventional commit; body in Italian with Jira link(s) first, then summary and test notes; assignee `domenicoTN`; reviewer `marco-martone`.
- **Never write client names** in configs, notes, or persisted instructions.
