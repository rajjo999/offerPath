# OfferPath Setup & Build Instructions

## ✅ Prerequisites
- macOS Ventura 13.0+ or later
- Xcode 15.0+ (from App Store or Apple Developer)
- iOS 17.0+ SDK
- Git (usually pre-installed on macOS)
- Apple ID (for signing & TestFlight)

## 📦 Step 1: Clone or Copy the Project
If you haven't already:
```bash
git clone <your-repo-url> OfferPath
# OR copy the OfferPath folder to your desired location
```

Navigate into the project:
```bash
cd "/Users/ranbirsingh/Documents/AppStoreApps/OfferPath"
```

## 🔧 Step 2: Open in Xcode
Double-click the `OfferPath.xcodeproj` file, or run:
```bash
open OfferPath.xcodeproj
```

## ⚙️ Step 3: Configure Signing & Capabilities
1. Select the **OfferPath** project in the Xcode project navigator
2. Select the **OfferPath** target
3. Go to the **Signing & Capabilities** tab
4. Select your **Apple Development Team** from the dropdown
5. Xcode will automatically manage signing — ensure "Automatically manage signing" is checked
6. Under **Capabilities**, enable:
   - [ ] **App Groups** (optional, for future sharing)
   - [ ] **Background Modes** → ☑️ Remote notifications
   - [ ] **Push Notifications**
   - [ ] **Widgets Extension** (if adding widgets)
   - [ ] **App Groups** (if using shared containers)

## 🔐 Step 4: Add Required Privacy Descriptions (Info.plist)
Ensure your `Info.plist` contains these keys (add if missing):

| Key | Value |
|-----|-------|
| `NSCalendarsFullAccessUsageDescription` | "OfferPath syncs job interviews and follow-ups with your Calendar app to keep your schedule up to date." |
| `NSRemindersFullAccessUsageDescription` | "OfferPath creates reminders for follow-ups and interview prep so you never miss an opportunity." |
| `NSLocationWhenInUseUsageDescription` | "OfferPath uses your location to suggest local job fairs, networking events, and company offices." _(Optional but recommended)_ |
| `UIUserInterfaceStyle` | `Dark` (to enforce dark mode) |
| `NSAppTransportSecurity` → `NSAllowsArbitraryLoads` | `YES` (only if using non-HTTPS dev backend; remove for production) |

> 💡 Tip: Right-click `Info.plist` → Open As → Source Code to edit directly.

## ▶️ Step 5: Build & Run
1. Select a destination (iPhone simulator or connected device) from the toolbar
2. Press **⌘ + R** (or click the ▶️ Run button)
3. Wait for build to complete — Xcode will launch the simulator or install to your device

## 🧪 Step 6: Run Tests (Optional but Recommended)
To verify everything works:
- Press **⌘ + U** to run all unit and UI tests
- Or select **Product → Test** from the menu

## 📱 Step 7: Test on Device (Recommended)
1. Connect your iPhone via USB
2. Trust the computer on your device when prompted
3. Select your device from the Xcode toolbar dropdown
4. Press **⌘ + R** to build and install directly

## 🛠️ Troubleshooting

| Issue | Solution |
|------|----------|
| **"No signing certificate found"** | Go to Xcode → Preferences → Accounts → Download manual profiles or renew |
| **"Failed to provision device"** | Ensure device is unlocked, trusted, and has enough storage |
| **"Calendar/Reminders access denied"** | Go to Settings → Privacy & Security → Calendars/Reminders → Enable OfferPath |
| **"Widgets not showing"** | Ensure Widget target is selected in scheme; clean build folder (⇧ + ⌘ + K) |
| **"Build takes too long"** | Clean build folder, restart Xcode, or disable indexing temporarily |
| **"dyld: Library not loaded"** | Check Frameworks are embedded: General → Frameworks, Libraries, and Embedded Content |

## 🧹 Clean Build (When Needed)
If you see strange errors:
1. **Product → Clean Build Folder** (or ⇧ + ⌘ + K)
2. Quit Xcode
3. Delete `~/Library/Developer/Xcode/DerivedData/*`
4. Reopen project and rebuild

## 🎉 You're Ready!
Once the app builds and runs successfully:
- Explore the tabs: Home, Pipeline, Calendar, Practice, Settings
- Add a test job application
- Try the AI-generated interview questions
- Set a follow-up reminder
- Check the weekly dashboard

## 🔐 Privacy Note
OfferPath stores all data **locally on your device** by default. No data leaves your phone unless you explicitly enable cloud sync (future feature).

---

## 📝 Save This File
Commit this `SETUP_CHECKLIST.md` to your repository so you and others can always reference it:
```bash
git add SETUP_CHECKLIST.md
git commit -m "Add setup and build instructions"
git push
```

---
*Last updated: 2026-09-14*  
*For questions or issues, check the Issues tab or contact maintainer.*