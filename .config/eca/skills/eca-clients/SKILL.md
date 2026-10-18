---
name: eca-clients
description: Guidelines and context to understand what are the ECA clients, how their release process work, use when you need to explore ECA clients or do a release/tag to one of them
---

# ECA clients

All projects live in ~/dev/<project>, example: ~/dev/eca-emacs

## eca-emacs

First and most important ECA client, new features goes here.

### Release

1. commit and push your changes, no tag needed

## eca-vscode

Uses eca-webview project as submodule

### Release

1. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.
2. run `npm version <patch|minor|major>` considering user choice otherwise patch
3. push the new tag
4. publish to marketplace via `npm run publish`

## eca-intellij

Uses eca-webview project as submodule

### Release

1. Add entry to changelog (max 180 chars) unreleased if not there
2. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.
3. run `bb tag <version-tag>` considering user choice otherwise a patch number, CI takes care of the rest

## eca-web

Uses eca-webview project as submodule

### Release

1. Commit and push your changes
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.

## eca-desktop

Uses eca-webview project as submodule

### Release

1. Commit and push
   - if there are changes in eca-webview folder, first commit and push there then on git root after or pull if commited from other repo the webview.
2. run `npm version <patch|minor|major>` considering user choice otherwise patch
3. push the new tag, CI takes care of the rest

## eca-nvim

Outdated client, missing features, we don't change manually here but someone will in the future

## eca-cli

WIP, do not touch yet
