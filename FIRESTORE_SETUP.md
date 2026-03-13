# Firestore Security Rules Setup

## Problem
You're seeing `[cloud_firestore/permission-denied]` errors because your Firestore security rules are too restrictive.

## Solution

### Option 1: Using Firebase Console (Easiest)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **don-troc-app**
3. Navigate to **Firestore Database** → **Rules** tab
4. Delete all existing rules and replace with the content from `firestore.rules` file in your project
5. Review the rules and click **Publish**

### Option 2: Using Firebase CLI

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize your project (if not already done):
   ```bash
   firebase init
   ```

4. Deploy the rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

### What These Rules Do

✅ **Public Read Access**
- Anyone can read items and posts (for browsing the feed)
- Anyone can read user profiles

✅ **Authenticated Write Access**
- Only authenticated users can create items and posts
- Users can only edit/delete their own items and posts

✅ **Private Chats**
- Users can only read chats they're part of
- Only chat participants can access messages

## Rule Breakdown

```
items collection:
- Read: Allow (public feed)
- Create: Require authentication
- Update/Delete: Owner only

posts collection:
- Read: Allow (public feed)
- Create: Require authentication
- Update/Delete: Owner only

chats collection:
- Read: Only for participants
- Create: Authenticated users
- Messages: Only accessible to chat participants
```

## After Updating Rules

1. Restart your app (hot restart or full rebuild)
2. The permission errors should disappear
3. Items and Posts will load from Firestore

## Still Getting Errors?

If you still see permission errors:
1. Make sure you're logged in with an authenticated user
2. Check Firebase Console → Authentication → check if your user exists
3. Try logging out and back in
4. Verify the rules are published (check the timestamp in Firebase Console)

## For Development (Testing Only)

If you want to allow **full public access** (not recommended for production):

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **WARNING**: This is UNSAFE for production. Only use for testing!
