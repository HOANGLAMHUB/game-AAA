# Aether RPG - Complete Build Guide

## System Requirements
- **OS**: Windows 10+, macOS 10.14+, Linux Ubuntu 20.04+
- **Unity**: 2022.3 LTS (recommended)
- **Android SDK**: API Level 33+
- **Java**: JDK 11+
- **RAM**: 8GB minimum (16GB recommended)
- **Storage**: 20GB free space
- **Gradle**: 8.0+ (bundled with Unity)

## Project Structure
```tree
game-AAA/
├── Assets/
│   ├── Scripts/
│   │   ├── Network/
│   │   ├── Combat/
│   │   ├── UI/
│   │   └── Systems/
│   ├── Scenes/
│   │   ├── SplashScreen.unity
│   │   ├── LoginScene.unity
│   │   ├── CharacterSelect.unity
│   │   └── GameWorld.unity
│   └── Resources/
│       └── build_settings.json
│   └── Editor/
│       └── BuildAndroid.cs
├── Builds/ (output)
├── app/
│   ├── build.gradle
│   ├── proguard-rules.pro
│   └── src/main/
│       └── AndroidManifest.xml
├── build.gradle
├── settings.gradle
├── gradle.properties
├── signing.properties
├── perform_apk_build.sh
├── perform_aab_build.sh
├── keystore_setup.sh
├── README_APK_BUILD.md
└── BUILD_GUIDE.md
```

## Step 1: Initial Setup

### 1.1 Clone Repository
```bash
git clone https://github.com/HOANGLAMHUB/game-AAA.git
cd game-AAA
```

### 1.2 Generate Android Keystore (First Time)
```bash
chmod +x keystore_setup.sh
./keystore_setup.sh
```
**Output**: `game-AAA.keystore`  
**Save credentials in**: `signing.properties`

### 1.3 Update signing.properties
```properties
storeFile=./game-AAA.keystore
storePassword=YOUR_SECURE_PASSWORD
keyAlias=aether-rpg
keyPassword=YOUR_SECURE_PASSWORD
```

## Step 2: Unity Configuration

### 2.1 Open Project in Unity
1. Launch Unity Hub  
2. Click **Open** → Select `game-AAA` folder  
3. Wait for project import (3-5 minutes first time)

### 2.2 Switch to Android Platform
1. File → Build Settings  
2. Platform list → Select **Android**  
3. Click **Switch Platform** (takes 2-3 minutes)  
4. Wait until checkmark appears

### 2.3 Configure Player Settings
File → Build Settings → Player Settings:
#### Platform Tab
- **Identification**
  - Bundle Identifier: `com.AetherRPG.OpenWorld`
  - Version: `1.0.0`
  - Bundle Version Code: `1`
- **Minimum API Level**: 24 (Android 7.0)
- **Target API Level**: 33 (Android 13)
- **Graphics APIs**: Vulkan, OpenGL ES 3
- **Color Space**: Linear

#### Quality Tab
- **Master Quality**: Fastest
- **Anti-Aliasing**: Disabled (mobile)
- **Shadow Distance**: 30
- **LOD Bias**: 0.7

#### Graphics Tab
- **Instancing**: Enabled
- **GPU Instancing**: Enabled

#### XR Plugin Management
- Ensure **Android** is checked
- Select OpenXR (optional for enterprise)

## Step 3: Build APK

### Option A: Editor Menu (Recommended for Testing)
1. File → Build Settings  
2. Scenes to Build:  
   - Assets/Scenes/SplashScreen.unity  
   - Assets/Scenes/LoginScene.unity  
   - Assets/Scenes/CharacterSelect.unity  
   - Assets/Scenes/GameWorld.unity  
3. Assets → Build → Generate APK
4. Select output folder: `Builds/APK/`
5. Click Build & Run (or Build)
6. Wait 5-10 minutes
**Output**: `Builds/APK/AetherRPG.apk` (~180MB)

### Option B: Command Line (CI/CD)
```bash
chmod +x perform_apk_build.sh
./perform_apk_build.sh
```
**Log**: `Builds/APK/build.log`

## Step 4: Build AAB (Google Play)

### Option A: Editor Menu
1. File → Build Settings  
2. Scenes same as APK step 3  
3. Assets → Build → Generate AAB  
4. Select output folder: `Builds/AAB/`
5. Click Build
6. Wait 8-12 minutes
**Output**: `Builds/AAB/AetherRPG.aab` (~150MB)

### Option B: Command Line
```bash
chmod +x perform_aab_build.sh
./perform_aab_build.sh
```

## Step 5: Testing on Device

### 5.1 Connect Android Device
1. Enable Developer Mode (tap Build Number 7x in Settings → About)
2. Enable USB Debugging (Settings → Developer Options)
3. Connect via USB
4. Run:
```bash
adb devices
```
Should show your device
#### Expected Output:
```list of attached devices
xxxxxxxx device
```

### 5.2 Install APK
```bash
adb install -r Builds/APK/AetherRPG.apk
```
#### Success Output:
```Success
```

### 5.3 Run Game
```bash
adb shell am start -n com.AetherRPG.OpenWorld/.MainActivity
```

### 5.4 View Logs
```bash
adb logcat -s "AetherRPG" # Filter for app logs
adb logcat | grep -i "error" # Show errors only
```

### 5.5 Uninstall
```bash
adb uninstall com.AetherRPG.OpenWorld
```

## Step 6: Performance Modes
Set QualitySettings in game:
```csharp
// LOW MODE (30 FPS)
Application.targetFrameRate = 30;
QualitySettings.SetQualityLevel(0);
QualitySettings.shadows = ShadowQuality.Disable;

// MEDIUM MODE (60 FPS)
Application.targetFrameRate = 60;
QualitySettings.SetQualityLevel(2);
QualitySettings.shadows = ShadowQuality.HardOnly;

// HIGH MODE (120 FPS)
Application.targetFrameRate = 120;
QualitySettings.vSyncCount = 0;
QualitySettings.SetQualityLevel(4);
QualitySettings.shadows = ShadowQuality.All;
```

## Step 7: Google Play Store Submission

### 7.1 Create Developer Account
1. Go to [Google Play Console](https://play.google.com/console)
2. Sign in with Google account
3. Pay $25 registration fee
4. Complete account setup

### 7.2 Create App
1. Click **Create App**
2. App name: **Aether RPG**
3. Default language: **English**
4. App category: **Games > Role Playing**

### 7.3 Upload AAB
1. Go to **Release** → **Production**
2. Click **Create new release**
3. Upload `Builds/AAB/AetherRPG.aab`
4. Add release notes (e.g., "Version 1.0 - Launch")
5. Review & publish to Internal Testing first

### 7.4 Complete Store Listing
1. Go to **Store listing**
2. App name: Aether RPG
3. Short description (80 chars): Open-world co-op multiplayer RPG
4. Full description (4000 chars): Complete gameplay description
5. Screenshots (min 4, max 8 in 1080x1920)
6. Feature graphic (1024x500)

### 7.5 Content Rating
1. Go to **Content rating**
2. Complete questionnaire
3. Submit for rating (typically ESRB Teen)

### 7.6 Pricing & Distribution
1. Go to **Pricing & distribution**
2. Price: Free
3. In-app purchases: Enabled (for Aether Tokens)
4. Countries: Select target markets
5. Save & continue

### 7.7 Submit for Review
1. Verify all requirements complete (green checkmarks)
2. Go to **Release** → **Production**
3. Click **Send for review**
4. Wait 24-48 hours for approval
5. Game goes live!

## Troubleshooting

### Build Errors
| Issue | Solution |
|-------|----------|
| "Android SDK not found" | Install SDK in Android Studio: SDK Manager |
| "Gradle sync failed" | Delete `Builds/` folder, rebuild |
| "OutOfMemory" | Increase heap: `gradle.properties` → `org.gradle.jvmargs=-Xmx6144m` |
| "Signing failed" | Verify keystore path & passwords in `signing.properties` |
| "Build timeout" | Run on machine with SSD, disable antivirus temporarily |

### Runtime Errors
| Issue | Solution |
|-------|----------|
| "Socket.IO connection refused" | Verify backend server running on correct IP/port |
| "Google Auth fails" | Check Google OAuth client ID configuration |
| "FPS drops below 30" | Reduce quality level or disable shadows |
| "No audio" | Check RECORD_AUDIO permission in manifest |

### Performance Optimization
- **Target ~60 FPS** for smooth gameplay
- **Use LOD** for distant objects
- **Enable GPU Instancing** on materials
- **Compress textures** to ASTC format
- **Profile** with Android Profiler in Android Studio

## File Sizes
| Component | Size | Notes |
|-----------|------|-------|
| Base APK | ~50 MB | Compressed executable |
| Scene Assets | ~80 MB | Textures, models, audio |
| Dependencies | ~50 MB | Libraries, frameworks |
| Total APK | ~180 MB | Expandable if needed |
| AAB (optimized) | ~150 MB | Google Play format |
| Uncompressed Install | ~500 MB | On device after installation |

## Security Checklist
- ✅ Token economy server-enforced
- ✅ Character ownership verified server-side
- ✅ Anti-cheat enabled (no client token modification)
- ✅ Audit logging all transactions
- ✅ HTTPS/TLS for all network communication
- ✅ JWT tokens with 24h expiry
- ✅ Request validation on all endpoints
- ✅ Rate limiting enabled (prevent spam)
- ✅ ProGuard enabled (code obfuscation)

## Next Steps
1. ✅ Complete APK build locally
2. ✅ Test on multiple Android devices (6.0 - 13.0)
3. ✅ Build AAB for store submission
4. ✅ Submit to Google Play Console
5. ✅ Monitor analytics & crashes (Firebase)
6. ✅ Deploy backend server to production
7. ✅ Launch live service events
8. ✅ Iterate based on player feedback