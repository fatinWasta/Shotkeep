# ShotKeep 

**Keep your Desktop clean. Automatically.**

ShotKeep is a lightweight macOS menu bar app that detects new
screenshots and organizes them instantly into a structured folder ---
without interrupting your workflow.

No clutter. No manual sorting. No dock icon.

------------------------------------------------------------------------
## ✨ What It Does

-   Monitors your Desktop (or any selected folder)
-   Automatically moves screenshots to a destination folder
-   Organizes files by date
-   Sends subtle macOS notifications
-   Runs quietly from the menu bar

------------------------------------------------------------------------

## 📁 Default Organization

    ~/Pictures/Screenshots/
        2026-02/
            2026-02-28_14-32-10.png

Simple. Predictable. Spotlight-friendly.

------------------------------------------------------------------------

## ⚙️ How It Works

1.  Select a source folder (e.g. Desktop)
2.  Select a destination folder (e.g. Pictures/Screenshots)
3.  Enable auto-monitoring
4.  Take screenshots normally

ShotKeep detects changes and organizes them in the background.

If auto-monitoring is disabled, you'll be notified when screenshots
start piling up.

------------------------------------------------------------------------

## 🏗 Architecture

Built with:

-   SwiftUI
-   MVVM
-   Use-case driven file operations
-   DispatchSource-based directory monitoring
-   Security-scoped bookmarks (Sandbox safe)
-   Injected notification service (testable, decoupled)

Clean separation of concerns. Minimal surface area.

------------------------------------------------------------------------

## 🔐 Permissions

-   Folder access (user-selected only)
-   macOS notifications

No analytics.\
No network calls.\
No background agents.

------------------------------------------------------------------------

## 🧠 Design Philosophy

Your Desktop is a workspace, not an archive.

Screenshots should be: - Automatically organized - Easy to find - Stored
predictably - Out of your way

ShotKeep exists to remove friction --- nothing more.

------------------------------------------------------------------------

## 🚀 Future Ideas

-   Monthly basis grouping
-   Custom organizing strategies

------------------------------------------------------------------------

## Requirements

-   macOS 13+
-   Xcode 15+
-   Swift 5.9+
