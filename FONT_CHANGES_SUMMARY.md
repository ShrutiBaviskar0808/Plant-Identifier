# Font Size and AI Removal Changes Summary

## Changes Made:

### 1. Font Configuration
- **Updated pubspec.yaml**: Added Poppins font family configuration
- **Updated app_theme.dart**: 
  - Added comprehensive TextTheme with Poppins font family
  - Increased all font sizes across the app (body text from 14→18px, titles from 18→22px, etc.)
  - Applied Poppins font to all text styles

### 2. AI Plant Care Removal
- **Deleted files**:
  - `lib/features/care/views/care_coach_view.dart`
  - `lib/core/data/services/care_coach_service.dart`
- **Updated care_view.dart**: 
  - Removed AI Coach tool card from care tools grid
  - Removed import for deleted care_coach_view.dart

### 3. Font Size Updates Across All Views

#### Home View (`home_view.dart`)
- Greeting text: 14px → 16px
- Main title: 24px → 28px
- Action card titles: 16px → 18px
- Action card subtitles: 14px → 16px
- Section titles: 24px → 28px
- Feature card titles: 14px → 16px
- Feature card subtitles: 12px → 14px
- Featured plant names: 14px → 16px
- Notification badge: 10px → 12px
- Bottom navigation labels: Added 14px

#### Care View (`care_view.dart`)
- Care Tools title: 18px → 22px
- Tool card titles: Added 16px
- Quick Tips title: 18px → 22px
- Tip text: Added 16px
- Weather Alerts title: 18px → 22px
- Alert titles: Added 16px
- Alert messages: 12px → 14px
- Health score: 24px → 28px
- Health status: Added 18px
- Health details: Added 16px
- Sustainability metrics: Added 16px and 14px

#### Camera View (`camera_view.dart`)
- App bar title: Added 22px

#### Garden View (`garden_view.dart`)
- App bar title: Added 22px

#### Profile View (`profile_view.dart`)
- App bar title: Added 22px

#### Browse View (`plant_browse_view.dart`)
- App bar title: Added 22px
- Search hint: Added 16px
- Category chips: Added 16px
- Plant card titles: Added 18px
- Plant card subtitles: Added 16px
- Plant detail title: 20px → 24px
- Plant detail subtitle: Added 18px
- Plant description: Added 16px

#### Notifications View (`notifications_view.dart`)
- App bar title: Added 22px
- Empty state title: 18px → 20px
- Empty state subtitle: Added 16px
- Notification titles: Added 18px
- Notification messages: Added 16px
- Notification timestamps: 12px → 14px

### 4. Font Files Required
- Created `assets/fonts/README_FONTS.md` with instructions to download:
  - Poppins-Regular.ttf
  - Poppins-Medium.ttf
  - Poppins-SemiBold.ttf
  - Poppins-Bold.ttf

## Next Steps:
1. Download the required Poppins font files from Google Fonts
2. Place them in the `assets/fonts/` directory
3. Run `flutter pub get` to apply the pubspec.yaml changes
4. Test the app to ensure all fonts are properly applied

## Impact:
- ✅ All text is now larger and more readable
- ✅ Consistent Poppins font family throughout the app
- ✅ AI plant care features completely removed
- ✅ Maintained app functionality while improving accessibility