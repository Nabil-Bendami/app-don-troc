# Firebase Firestore Rules Deployment Guide

## 🚨 CRITICAL: Permission Denied Error Fix

Your app shows "Permission Denied" errors because Firestore security rules haven't been deployed.

### **Option A: Firebase Console (Easiest)**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **don-troc-app-3b071**
3. Click **Firestore Database** (left sidebar)
4. Click the **Rules** tab (top navigation)
5. Delete the default rules
6. Copy and paste the complete rules from your project:

```plaintext
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow anyone to read items (public feed)
    match /items/{document=**} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Allow anyone to read posts (public feed)
    match /posts/{document=**} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Chats - users can only access their own chats
    match /chats/{document=**} {
      allow read: if request.auth != null && 
        request.auth.uid in resource.data.userIds;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid in resource.data.userIds;
      
      // Messages in chats
      match /messages/{message=**} {
        allow read: if request.auth != null && 
          request.auth.uid in get(/databases/$(database)/documents/chats/$(document)).data.userIds;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && 
          request.auth.uid == resource.data.senderId;
      }
    }
    
    // Users - publicly readable profiles
    match /users/{userId} {
      allow read: if true;
      allow create, update: if request.auth != null && 
        request.auth.uid == userId;
      allow delete: if request.auth != null && 
        request.auth.uid == userId;
    }
  }
}
```

7. Click **Publish** button (blue button in top right)
8. Wait for confirmation message (usually 2-5 seconds)

### **Option B: Firebase CLI (Advanced)**

1. Open PowerShell in your project directory
2. Make sure you have Firebase CLI installed:
   ```powershell
   npm install -g firebase-tools
   ```

3. Login to Firebase:
   ```powershell
   firebase login
   ```

4. Deploy the rules:
   ```powershell
   firebase deploy --only firestore:rules
   ```

5. Confirm successful deployment in console output

### **Option C: Update firebase.json for Easy Future Deployments**

Edit `firebase.json` and add:

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "flutter": {
    "platforms": {
      "android": {
        "default": {
          "projectId": "don-troc-app-3b071",
          "appId": "1:772038159363:android:d10f3309e758144ecdb236",
          "fileOutput": "android/app/google-services.json"
        }
      }
    },
    "dart": {
      "lib/firebase_options.dart": {
        "projectId": "don-troc-app-3b071",
        "configurations": {
          "android": "1:772038159363:android:d10f3309e758144ecdb236",
          "ios": "1:772038159363:ios:6332f65b5b1887f7cdb236",
          "macos": "1:772038159363:ios:6332f65b5b1887f7cdb236",
          "web": "1:772038159363:web:a04db7717608c620cdb236",
          "windows": "1:772038159363:web:b66d93b9670323c7cdb236"
        }
      }
    }
  }
}
```

## ✅ Verification Steps

After deploying, verify by:

1. **Hot restart your Flutter app** (press `r` in terminal)
2. Go to **Home screen** - Items and Posts should load
3. Go to **Messages** - Your chats should load
4. Go to **Profile** - Your profile data should load

If you still see errors:
- Make sure you're logged in with a Firebase-authenticated user
- Check that `firebase-core` package is properly initialized
- Verify Firebase project ID matches in `firebase_options.dart`

## 📱 Why These Rules Are Designed This Way

- **Items & Posts**: Public read (for discovery), auth-required write (verified users only)
- **Chats & Messages**: Private (only visible to chat participants)
- **Users**: Public read (profile discovery), auth-required write (only own profile)

This ensures your marketplace has public content discovery while keeping private messages secure.
