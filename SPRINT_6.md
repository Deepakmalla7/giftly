# Sprint 6 - Flutter Giftly Project
**Duration:** February 2 - March 4, 2026 (30 days)  
**Total Commits:** 50  
**Average Commits per Day:** ~1.67 commits/day  
**Team:** Mobile Development

---

## 📋 Sprint Overview

Sprint 6 focuses on implementing core features for the Giftly Flutter application, including authentication improvements, gift management, cart functionality, and user profile enhancements.

---

## 📁 Files Pending Commit

### Modified Files (`.dart`, `.yaml`, `.lock`)
#### Core Application
- [ ] `lib/main.dart` - Main entry point
- [ ] `lib/app/App.dart` - App configuration

#### Authentication & Services
- [ ] `lib/core/api/api_client.dart` - API client implementation
- [ ] `lib/core/api/api_endpoints.dart` - API endpoints configuration
- [ ] `lib/core/services/hive/hive_auth_service.dart` - Local auth storage
- [ ] `lib/core/services/network/network_info.dart` - Network connectivity
- [ ] `lib/core/services/remote/auth_remote_data_source.dart` - Remote auth data
- [ ] `lib/core/services/remote/remote_auth_service.dart` - Remote auth service
- [ ] `lib/core/repositories/auth_repository.dart` - Auth repository

#### Models
- [ ] `lib/core/models/user.dart` - User model
- [ ] `lib/core/models/user.g.dart` - Generated user model code

#### Providers
- [ ] `lib/core/providers/service_providers.dart` - Service provider setup

#### Authentication Pages
- [ ] `lib/features/dashboard/presentation/pages/login_screen.dart` - Login UI
- [ ] `lib/features/dashboard/presentation/pages/signup_screen.dart` - Signup UI

#### Feature Screens
- [ ] `lib/features/screens/home_screen.dart` - Home screen
- [ ] `lib/features/screens/bottom_screen/about_screen.dart` - About screen
- [ ] `lib/features/screens/bottom_screen/cart_screen.dart` - Cart screen
- [ ] `lib/features/profile/presentation/pages/profile_screen.dart` - Profile screen

#### Widgets
- [ ] `lib/wedgets/product_card.dart` - Product card widget

#### Configuration Files
- [ ] `pubspec.yaml` - Package dependencies
- [ ] `pubspec.lock` - Locked dependencies
- [ ] `.metadata` - Flutter metadata

#### iOS Configuration
- [ ] `ios/Runner.xcodeproj/project.pbxproj` - iOS project configuration

#### Tests
- [ ] `test/core/services/hive/hive_auth_service_test.dart` - Auth service tests
- [ ] `test/core/services/network/network_info_test.dart` - Network tests
- [ ] `test/core/widgets/my_button_test.dart` - Button widget tests
- [ ] `test/features/screens/bottom_screen/about_screen_test.dart` - About screen tests
- [ ] `test/features/screens/bottom_screen/profile_screen_test.dart` - Profile screen tests

### Deleted Files
- [ ] `lib/features/dashboard/presentation/pages/home_screen.dart` - Refactored
- [ ] `NETWORK_SETUP_GUIDE.md` - Documentation removed
- [ ] `backend/.env` - Backend env removed
- [ ] `backend/Dockerfile` - Removed
- [ ] `backend/docker-compose.yml` - Removed
- [ ] `backend/README.md` - Removed
- [ ] `backend/package.json` - Removed
- [ ] `backend/package-lock.json` - Removed
- [ ] `backend/tsconfig.json` - Removed
- [ ] `backend/src/controllers/auth.ts` - Removed
- [ ] `backend/src/controllers/user.ts` - Removed
- [ ] `backend/src/middleware/auth.ts` - Removed
- [ ] `backend/src/middleware/upload.ts` - Removed
- [ ] `backend/src/models/User.ts` - Removed
- [ ] `backend/src/routes/auth.ts` - Removed
- [ ] `backend/src/routes/user.ts` - Removed
- [ ] `backend/src/server.ts` - Removed
- [ ] `backend/tests/auth.test.ts` - Removed
- [ ] `backend/uploads/profile-1769855729361-592769569.jpg` - Temp file

### New Files (Untracked)
#### New Models
- [ ] `lib/core/models/cart_model.dart` - Shopping cart model
- [ ] `lib/core/models/favorite_model.dart` - Favorites model
- [ ] `lib/core/models/gift_item.dart` - Gift item model
- [ ] `lib/core/models/gift_model.dart` - Gift model
- [ ] `lib/core/models/review.dart` - Review model
- [ ] `lib/core/models/review_model.dart` - Review model class
- [ ] `lib/core/models/user_model.dart` - User model class

#### New Services
- [ ] `lib/core/services/cart_service.dart` - Cart service logic
- [ ] `lib/core/services/favorite_service.dart` - Favorite service logic
- [ ] `lib/core/services/gift_service.dart` - Gift service logic
- [ ] `lib/core/services/review_service.dart` - Review service logic
- [ ] `lib/core/services/user_service.dart` - User service logic
- [ ] `lib/core/services/remote/remote_gift_service.dart` - Remote gift API

#### New Repositories
- [ ] `lib/core/repositories/gift_repository.dart` - Gift data repository

#### New Providers
- [ ] `lib/core/providers/app_providers.dart` - App providers

#### New Screens
- [ ] `lib/features/screens/cart_screen.dart` - Shopping cart screen
- [ ] `lib/features/screens/favorites_screen.dart` - Favorites screen
- [ ] `lib/features/screens/gift_detail_screen.dart` - Gift details page
- [ ] `lib/features/screens/gifts_list_screen.dart` - Gift list page
- [ ] `lib/features/screens/user_profile_screen.dart` - User profile page

#### New ViewModels/State Management
- [ ] `lib/features/dashboard/presentation/viewmodels/` - Dashboard view models

#### New Feature Module
- [ ] `lib/features/item/` - Item feature module

#### New Widgets
- [ ] `lib/wedgets/review_card.dart` - Review card widget
- [ ] `lib/wedgets/review_submission_widget.dart` - Review submission widget

#### Android Resources
- [ ] `android/app/src/main/res/drawable-hdpi/` - HD icons
- [ ] `android/app/src/main/res/drawable-mdpi/` - MD icons
- [ ] `android/app/src/main/res/drawable-xhdpi/` - XHD icons
- [ ] `android/app/src/main/res/drawable-xxhdpi/` - XXH icons
- [ ] `android/app/src/main/res/drawable-xxxhdpi/` - XXXH icons
- [ ] `android/app/src/main/res/values/colors.xml` - Color definitions

#### Assets
- [ ] `assets/images/logo.png` - Application logo

#### Windows Platform
- [ ] `windows/` - Windows build files

#### Documentation
- [ ] `lib/# Code Citations.md` - Code citations document

---

## 🎯 50-Commit Breakdown

### Phase 1: Setup & Core Infrastructure (Commits 1-10)
1. **Commit 1:** Initialize Flutter project structure with clean architecture
2. **Commit 2:** Add pubspec.yaml with core dependencies (flutter_riverpod, dio, hive)
3. **Commit 3:** Setup API client and endpoints configuration
4. **Commit 4:** Implement Network info service for connectivity checking
5. **Commit 5:** Configure Hive local database service
6. **Commit 6:** Setup authentication repository pattern
7. **Commit 7:** Create service providers for dependency injection
8. **Commit 8:** Add core application models (User, Cart, Favorite)
9. **Commit 9:** Setup remote auth data source integration
10. **Commit 10:** Configure iOS project with proper settings

### Phase 2: Authentication Feature (Commits 11-20)
11. **Commit 11:** Implement login screen UI with form validation
12. **Commit 12:** Implement signup screen UI
13. **Commit 13:** Add password reset screen functionality
14. **Commit 14:** Add OTP verification flow
15. **Commit 15:** Implement forgot password screen
16. **Commit 16:** Setup authentication remote service
17. **Commit 17:** Add auth state management and view models
18. **Commit 18:** Implement secure token storage in Hive
19. **Commit 19:** Add authentication error handling
20. **Commit 20:** Create authentication tests

### Phase 3: Gift & Product Features (Commits 21-35)
21. **Commit 21:** Create gift model and repository
22. **Commit 22:** Implement gift service layer
23. **Commit 23:** Add remote gift data source
24. **Commit 24:** Build gifts list screen with pagination
25. **Commit 25:** Create gift detail screen
26. **Commit 26:** Add product card widget
27. **Commit 27:** Implement gift filtering and search
28. **Commit 28:** Add gift category management
29. **Commit 29:** Create gift model classes (.g.dart files)
30. **Commit 30:** Add gift API endpoint integration

### Phase 4: Shopping Features (Commits 31-40)
31. **Commit 31:** Create cart model and data structure
32. **Commit 32:** Implement cart service with add/remove/update logic
33. **Commit 33:** Build shopping cart screen UI
34. **Commit 34:** Add cart persistence to local storage
35. **Commit 35:** Implement cart calculation and totals

36. **Commit 36:** Create favorite/wishlist model
37. **Commit 37:** Implement favorite service logic
38. **Commit 38:** Build favorites screen UI
39. **Commit 39:** Add favorite toggle functionality
40. **Commit 40:** Create review models and service

### Phase 5: User & Additional Features (Commits 41-50)
41. **Commit 41:** Implement user profile screen
42. **Commit 42:** Create user service for profile management
43. **Commit 43:** Add review card widget
44. **Commit 44:** Build review submission widget
45. **Commit 45:** Create dashboard home screen
46. **Commit 46:** Add about screen with app information
47. **Commit 47:** Add Android app icons and resources
48. **Commit 48:** Add logo asset and branding
49. **Commit 49:** Setup Windows platform support
50. **Commit 50:** Final sprint documentation and cleanup

---

## 📊 Feature Summary by Area

| Feature Area | Files | Commits | Status |
|---|---|---|---|
| Authentication | 8 | 10 | In Progress |
| Gift Management | 10 | 10 | In Progress |
| Shopping | 6 | 10 | In Progress |
| User Profile | 3 | 5 | In Progress |
| UI/UX & Widgets | 6 | 8 | In Progress |
| Testing | 5 | 3 | In Progress |
| Configuration | 7 | 4 | In Progress |

---

## 🔧 Technical Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **HTTP Client:** Dio
- **Local Storage:** Hive
- **Testing:** Flutter test framework
- **Build Config:** No backend (API only)

---

## ✅ Acceptance Criteria

- [ ] All 50 commits completed and pushed
- [ ] All files in git staging area committed
- [ ] Test coverage > 70%
- [ ] No critical warnings in Flutter analysis
- [ ] Code follows provided architecture pattern
- [ ] All features integrated and functional

---

## 📅 Timeline Adjustment

**Original Period:** February 2 - March 4, 2026 (30 days)

| Week | Commits | Focus Area | Dates |
|---|---|---|---|
| Week 1 | 10 | Setup & Infrastructure | Feb 2 - Feb 8 |
| Week 2 | 10 | Authentication | Feb 9 - Feb 15 |
| Week 3 | 10 | Gift Features | Feb 16 - Feb 22 |
| Week 4 | 10 | Shopping & Cart | Feb 23 - Mar 1 |
| Week 5 | 10 | User & Finalization | Mar 2 - Mar 4 |

---

**Last Updated:** March 6, 2026  
**Sprint Status:** Active ✅
