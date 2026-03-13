# 🎁 Adding Your Custom Logo - Quick Start

## ✅ What I've Already Done:

1. ✅ Created `assets/images/` folder
2. ✅ Updated `pubspec.yaml` to load images
3. ✅ Updated Splash Screen to display your logo
4. ✅ Updated Home Screen AppBar to show logo

## 📸 What You Need to Do:

### Step 1: Save Your Logo Image
Your blue gift box logo needs to be saved as:
- **File name:** `app_logo.png`
- **Location:** `assets/images/app_logo.png`
- **Format:** PNG (with transparency recommended)
- **Size:** At least 512x512 pixels (image will auto-scale)

### Step 2: Export Your Logo

If you have the logo as:
- **From attachment:** Download the blue gift box image
- **From design tool:** Export as PNG
- **From Figma/Sketch:** Export as PNG (transparent background)

### Step 3: Place in Project

```
don_tro/
  └── assets/
      └── images/
          └── app_logo.png  ← PUT YOUR LOGO HERE
```

### Step 4: Run Your App

```bash
cd c:\Users\YLS\Documents\DUT\PFE\don_tro
flutter pub get
flutter run
```

## 🎯 Where Your Logo Will Appear:

1. **Splash Screen** - Shows when app starts
2. **Home Screen AppBar** - Shows next to "Don & Troc" title
3. **Both locations** - Professional branding!

## 📝 If You Need Different Sizes:

For best quality on different devices, create:
- `app_logo.png` - 512x512 px (standard)
- `app_logo@2x.png` - 1024x1024 px (high DPI)

Then update `pubspec.yaml`:
```yaml
assets:
  - assets/images/app_logo.png
  - assets/images/app_logo@2x.png
```

## ✨ After You Add the Logo:

The app will:
- ✅ Display your blue gift box logo on splash screen
- ✅ Show logo in app bar header
- ✅ Look professional for your academic project
- ✅ Match your app branding

## 🚀 Done! 

Just save your logo image to `assets/images/app_logo.png` and the app will automatically use it!
