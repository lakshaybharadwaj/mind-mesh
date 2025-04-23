
Mind_mesh

A Flutter starter project with Supabase integration, featuring authentication, database operations, and real-time updates.

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=2.17.0)
- Android Studio/Xcode (for mobile builds)


### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/flutter-supabase-starter.git
cd flutter-supabase-starter

# Install dependencies
flutter pub get

# Run the app
flutter run
```



## 🔌 Supabase Setup Steps

### 1. Create Supabase Project
1. Go to [app.supabase.com](https://app.supabase.com/)
2. Click "New Project"
3. Enter project details:
   - Name: `lakshaybharadwaj9@gmail.com's Project`
   - Database Password: `************`
   

### 2. Configure Database
```sql
create table habits (
  id serial primary key,
  name text not null,
  tracking_unit text not null,
  duration text not null,
  created_at timestamp with time zone default now()
);



### 3. Enable Authentication
1. Go to Authentication → Providers
2. Enable Email/Password, Google, etc.
3. Configure redirect URLs:
   - `io.supabase.flutterstarter://login-callback/` (for mobile)
   - `http://localhost:3000` (for web)

### 4. Configure Environment Variables
Create `.env` file:
```env
SUPABASE_URL=your-project-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 🔥 Hot Reload vs Hot Restart

| Feature               | Hot Reload (`r`) | Hot Restart (`R`) |
|-----------------------|------------------|-------------------|
| Speed                 | Instant          | ~5-10 seconds     |
| App State Preserved   | ✅ Yes           | ❌ No             |
| Widget Tree Rebuilt   | Partial          | Complete          |
| Best For              | UI Tweaks        | Logic Changes     |
| Initialization Runs   | ❌ No            | ✅ Yes            |

**When to use:**
- Use **Hot Reload** when:
  - Changing UI colors/text
  - Adjusting padding/margins
  - Minor logic tweaks

- Use **Hot Restart** when:
  - Modifying `main()` method
  - Changing app initialization
  - Adding new dependencies

## 📦 Project Structure

```
lib/
├── main.dart          # App entry point
├── core/
│   ├── constants/     # App constants
│   ├── services/      # Supabase service
│         
├── widgeta/
│   ├── auth/          # Authentication flow
│   ├── DashboardScreen/          # Main app screens
│   └── NewHabitScreen/       # User profile
          
```

## 🌐 Deployment

### Android
```bash
flutter build apk --release
flutter install
```

### iOS
```bash
flutter build ios --release
open ios/Runner.xcworkspace
```

### Web
```bash
flutter build web
firebase deploy  # If using Firebase Hosting
```




