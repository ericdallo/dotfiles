# ECA vscode/intellij commit and release

1. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there than on git root after.
2. run `npm version <patch|minor|major>` considering user choice: $ARG1
3. push the new tag
4. publish to marketplace via `npm run publish`

