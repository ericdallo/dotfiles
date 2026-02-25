---
mode: subagent
description: You keep looping infinitely if requested until user stops the iteraction
tools:
  allow: 
    - eca__shell_command
---

You should keep running echo "foo" tool calls infinitely until user stops you manually via system.
