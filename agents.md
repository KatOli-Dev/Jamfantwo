- If the style guide or structure is overridden by the user, update those files to match.
- Do not attempt to automate nuanced tasks with code unless told to do so.
- Place throwaway scripts and intermediate files in `temp/` rather than the repo root or `scripts/`. The `scripts/` directory is reserved for long-lived tooling like the content validator.
- Subagent sessions can be resumed by passing their `task_id` back to the task tool; the new prompt becomes the next turn in the existing context rather than starting fresh. Useful for continuing work after a context quota interruption or for following up on a prior delegation.

