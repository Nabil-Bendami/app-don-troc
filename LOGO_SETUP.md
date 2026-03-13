# How to Add Your Custom Logo

## Step 1: Save Your Logo Image

1. Your custom logo (blue gift box icon) needs to be saved as a PNG file
2. Place it in: `assets/images/app_logo.png`

### File Location:
```
don_tro/
  └── assets/
      └── images/
          └── app_logo.png  ← Save your logo here
```

## Step 2: Recommended Logo Sizes

For best results, create multiple sizes:
- **app_logo.png** - 192x192 px (1x)
- **app_logo@2x.png** - 384x384 px (2x) 
- **app_logo@3x.png** - 576x576 px (3x)

Or just use: **app_logo.png** at 512x512 px minimum

## Step 3: Use the Logo in Your App

### Option A: As Splash Screen Logo (Recommended)

Edit `lib/screens/splash_screen.dart`:
```dart
Image.asset(
  'assets/images/app_logo.png',
  width: 150,
  height: 150,
)
```

### Option B: As App Title Icon

Edit `lib/screens/home_screen.dart`:
```dart
AppBar(
  title: Row(
    children: [
      Image.asset(
        'assets/images/app_logo.png',
        width: 40,
        height: 40,
      ),
      const SizedBox(width: 10),
      const Text('Don & Troc'),
    ],
  ),
)
```

### Option C: As App Icon (Android/iOS)

For the actual app icon, use Flutter's icon generation:
1. Place icon at: `assets/images/app_logo.png`
2. Run: `flutter pub get`
3. Use a tool like Fluttericon to convert to app icons

## Step 4: After Adding Your Logo

1. Download your logo image
2. Save it to: `assets/images/app_logo.png`
3. Run in terminal:
   ```bash
   flutter pub get
   flutter run
   ```

## Where I've Already Set Up:

✅ Created `assets/images/` folder
✅ Updated `pubspec.yaml` to include assets
✅ Ready to use images in your app

## Next: Tell Me Where You Want the Logo!

The logo can appear in:
1. **Splash Screen** (startup screen)
2. **App Bar** (top of home screen)
3. **Drawer** (menu icon)
4. **Multiple places** (splash + app bar)

Which location would you like? I'll add the code for you!
