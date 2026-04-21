# Publishing Guide

This guide explains how to publish userscripts to GreasyFork and OpenUserJS with automatic sync from GitHub.

## Overview

Both GreasyFork and OpenUserJS support **webhook-based automatic syncing** from GitHub. This means:
1. You manually upload the script once
2. Set up webhook sync
3. Future updates are automatic on every push to `main`

## GreasyFork Setup

### 1. Create Account
- Go to https://greasyfork.org/
- Sign up with GitHub OAuth

### 2. Initial Script Upload
1. Go to https://greasyfork.org/scripts/new
2. Choose **"Import from URLs"** tab
3. Paste your script's raw GitHub URL:
   ```
   https://raw.githubusercontent.com/definite-d/userscripts/main/scripts/github-add-folder-download-option.user.js
   ```
4. Click **"Import"**

### 3. Enable Webhook Sync
1. Go to your script page → **"Admin"** → **"Syncing"**
2. Enable **"Automatic syncing"**
3. Set source to your raw GitHub URL
4. Save

### 4. Set Up Repository Webhook (One-time)
1. On GreasyFork, go to **User Settings** → **"Webhooks"**
2. Copy your webhook URL (looks like `https://greasyfork.org/en/users/XXXXX/webhook`)
3. On GitHub repo → **Settings** → **Webhooks** → **"Add webhook"**
4. Paste the GreasyFork webhook URL
5. Content type: `application/json`
6. Choose **"Just the push event"**
7. Save

### 5. Get Script ID
After publishing, note the script ID from the URL:
```
https://greasyfork.org/en/scripts/XXXXXX-github-folder-download
```
The `XXXXXX` is your script ID.

## OpenUserJS Setup

### 1. Create Account
- Go to https://openuserjs.org/
- Sign up with GitHub OAuth

### 2. Link GitHub Repository
1. Go to **"Add Script"** → **"From Source"** → **"GitHub"**
2. Authorize OpenUserJS to access your repos
3. Select this repository
4. OpenUserJS will scan for `.user.js` files

### 3. Select Scripts
- Choose which scripts to import
- OpenUserJS will create script pages automatically

### 4. Webhook Auto-Sync
OpenUserJS automatically sets up webhook sync when you import from GitHub. No additional steps needed!

### 5. Get Script URL
Script URLs follow this pattern:
```
https://openuserjs.org/scripts/definite-d/GitHub_Folder_Download
```

## After Publishing

Once you have the script IDs, update `scripts/README.md`:
- Replace `XXXXXX` in GreasyFork links with actual script IDs
- Verify OpenUserJS links match the generated URLs

## Version Bump Workflow

When updating scripts:
1. Update the `@version` tag in the script
2. Commit and push to `main`
3. Webhooks automatically sync to both platforms

## Manual Sync (if needed)

If webhook fails, manually trigger sync:

**GreasyFork**: Script page → Admin → Syncing → "Sync now"

**OpenUserJS**: Script page → "Sync" button
