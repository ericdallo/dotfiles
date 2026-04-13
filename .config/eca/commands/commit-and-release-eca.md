# Commit and release guidelines for eca projects

Follow the rules below following user input: $ARG1

- Never do force pushs or rebases

## For eca-vscode

Project location: ~/dev/eca-vscode

1. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.
2. run `npm version <patch|minor|major>` considering user choice otherwise patch
3. push the new tag
4. publish to marketplace via `npm run publish`

## For eca-intellij

Project location: ~/dev/eca-intellij

1. Add entry to changelog unreleased if not there
2. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.
3. run `bb tag <version-tag>` considering user choice otherwise patch
4. run `bb publish-plugin`

## For eca-web

Project location: ~/dev/eca-web

1. Commit and push your changes
