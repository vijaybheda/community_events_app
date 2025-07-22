# Technical Specification Document: Community Events App (Flutter + GetWidget + Firebase)

## 1. Project Overview

Build a **Community Events App** in Flutter using the GetWidget package for UI components and Firebase for backend services. The app is designed to allow users to browse, create, manage, and RSVP to community events. The backend is *strictly limited* to the Dart runtime and Firebase (Firestore, Authentication). No other backend services are allowed.

## 2. Functional Requirements

### 2.1 Core User Actions

- View list of all community events
- Filter events by date, category, or participation status
- Search for specific events
- View details of a selected event
- RSVP to an event (mark as attending/not attending)
- Add a new event (for authorized users)
- Edit or delete your own events
- Receive feedback (SnackBar/Toast) for all actions
- View profile and manage your RSVPs


### 2.2 Non-Functional Requirements

- Fast and responsive UI on mobile (Android/iOS) and web
- Authentication via Google (with Firebase Auth)
- Data stored and synchronized via Firebase Firestore
- All UI components use GetWidget where possible


## 3. Technical Architecture

### 3.1 Overview Diagram

```
[Flutter App (Dart)]
      |        
[GetWidget UI Components]
      |
[Firebase SDK (Firestore, Auth)]
      |
[Firebase Cloud (No custom backend)]
```


## 4. Screen-by-Screen Breakdown

| Screen Name | Key Functions | Main UI Components |
| :-- | :-- | :-- |
| Splash Screen | App logo, loading state | GFLoader, Center, Image, Text |
| Login Screen | Google Sign-in via Firebase | GFButton, GFCard, GFIconButton |
| Home (Events List) | List all events, filter, search, go to Event Details | GFListTile, GFCard, GFAppBar, GFAvatar, GFSearchBar, GFTabBar |
| Event Details | Full event info, RSVP, share, view participants | GFCard, GFButton, GFChip, GFAvatar, GFListTile, GFAlert |
| Add/Edit Event | Input event info, validate, submit/save | GFForm, GFInput, GFDatePicker, GFButton, GFDropdown, GFDialog |
| My RSVPs | Shows events user has committed to, allows edit/cancel | GFListTile, GFBadge, GFCard |
| Profile | User info, settings, log out | GFCard, GFAvatar, GFButton |
| About/Help | App info, contact, FAQs | GFAccordion, GFListTile |

## 5. Detailed Screens Specifications

### 5.1 Splash Screen

- Displays app logo and title
- Animated loader using `GFLoader`
- After a delay or auth check, navigates to Login or Home


### 5.2 Login Screen

- Presents app branding and Google Sign-in option
- Utilizes `GFButton` for “Sign in with Google”
- On successful login, proceed to Home
- On failure, shows `GFToast` with message


### 5.3 Home Screen (“Events List”)

- **App bar**: Title, profile icon, “+” (add event—conditionally)
- **Tabs**: All Events | My RSVP | Past Events
- **Search/filter**: `GFSearchBar` at top for event name/date/category
- **Event List**: Each event uses `GFCard` with:
    - Event Title, Short Description
    - Date/Time with `GFIcon`
    - RSVP status as `GFBadge`
    - Thumbnail with `GFAvatar`
    - Tap leads to Event Details
- **Pull to refresh**: List updates from Firestore
- **FAB**: “+” to add event (if authorized)


### 5.4 Event Details Screen

- Presents full event info:
    - Title, Date/Time, Location (text)
    - Banner/image at top
    - Description field
    - Created by (avatar and name)
- RSVP Button (`GFButton`, Chip toggles for Attending/Not Attending)
- Show list of attendees below using `GFListTile`/`GFAvatar`
- Share button to copy/share event link
- If user created event: Edit/Delete buttons
- Feedback for RSVP/changes via `GFToast`


### 5.5 Add/Edit Event Screen

- Form fields for:
    - Title (`GFTextField`)
    - Description (`GFTextField`)
    - Category (`GFDropdown`)
    - Location (`GFTextField`)
    - Date \& Time (`GFDatePicker`)
    - Image Upload (URL or local picker—Firebase Storage)
- Submit/Cancel buttons with form validation
- Use `GFDialog` for confirmation


### 5.6 My RSVPs Screen

- List of all events user RSVPed to (`GFListTile`)
- RSVP status badge (Attending/Not Attending)
- Tap to go to details, option to revoke RSVP


### 5.7 Profile Screen

- Shows user avatar (`GFAvatar`), name, email
- Option to edit name/photo (if allowed)
- Log out button (`GFButton`)
- App version/info


### 5.8 About/Help Screen

- Static info using `GFAccordion` or expandable cards
- App description, “Contact us”, “FAQ”, link to GitHub


## 6. Detailed Technical Actions \& Flows

### 6.1 Authentication

- On app start, check for logged-in Firebase user
- If not present, route to Login
- On Login (Google Sign In via Firebase Auth), save user profile locally and in Firestore if new
- “Sign Out” clears session and returns to Login


### 6.2 Events Data (Firestore)

- Events stored in “events” collection with:
    - Document structure: `{title, description, dateTime, location, image, createdBy, attendees: [userId], category, createdOn, updatedOn}`
- Adding, editing, deletion restricted (only allowed by event creator)
- RSVP is update to user’s UID in attendees array
- Firestore queries for:
    - All events (by date)
    - Events by filter/search
    - Events for which user is an attendee


### 6.3 Event Actions

- Add Event: validates fields, creates new Firestore doc
- Edit Event: only for creator, updates existing doc
- Delete: only for creator, deletes doc after confirmation dialog
- RSVP: toggles presence of user in 'attendees' array
- All actions update UI instantly via Firestore snapshots


### 6.4 Media/File Handling

- Event images: can use Firebase Storage or image URL (picked via Flutter widget, uploaded if new)
- Avatar: Google profile pic, else default
- Image previews via `GFImageOverlay` in event cards/details


### 6.5 State Management

- Use native Flutter state management (setState, Provider, or Riverpod—choose based on project scale)
- UI reacts live to Firestore snapshot changes for event lists and RSVP status


### 6.6 UI Feedback

- Every action (add, RSVP, error) triggers `GFToast` or `GFSnackbar`
- Loader (GFLoader) for async actions, pull-to-refresh on main lists


## 7. UI Components Mapping (GetWidget)

| App Feature | GetWidget Component (Class) | Purpose |
| :-- | :-- | :-- |
| Buttons, Action Triggers | GFButton, GFIconButton | Add, RSVP, Edit, Share, Save actions |
| Lists \& Cards | GFListTile, GFCard, GFImageOverlay | Displaying events, attendees, details |
| Profile/Avatars | GFAvatar, GFBadge | User identity, RSVP status |
| Input Forms | GFForm, GFTextField, GFDropdown, GFDatePicker | Add/edit event, search, filter |
| Dialogs/Modals | GFDialog, GFAlert, GFAccordion | Confirm delete, show info, About/Help sections |
| Navigation | GFAppBar, GFTabBar, GFBreadcrumb | App structure navigation, tab switching |
| Feedback | GFSnackbar, GFToast, GFLoader | Action acknowledgment, loading states |

## 8. Data Models

### User

```dart
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
}
```


### Event

```dart
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String imageUrl;
  final String createdBy;
  final List<String> attendees;
  final String category;
  final DateTime createdOn;
  final DateTime updatedOn;
}
```


## 9. Navigation \& Routing Structure

- `/`                  - Splash (redirects to /login or /home)
- `/login`             - LoginScreen
- `/home`              - EventListScreen (with tabs)
- `/event/:id`         - EventDetailsScreen
- `/addEvent`          - AddEventScreen (conditional on permission)
- `/editEvent/:id`     - EditEventScreen
- `/profile`           - ProfileScreen
- `/myrsvp`            - MyRsvpsScreen
- `/about`             - AboutScreen


## 10. Error Handling \& Edge Cases

- Show error SnackBar for network issues, permission errors, Firestore failures
- Validate all form fields before submission
- Restrict event editing/deletion to event creators
- If list empty (no events/RVSPs), display friendly empty state with suggestions


## 11. Firebase Security (Rules High Level)

- Read: public for events; user events protected by UID
- Write: Only authenticated users can write; only creator edits/deletes
- RSVP: Only authenticated users update their RSVP status


## 12. Development Plan

### Week 1

- Project setup, Firebase integration, GetWidget config
- Splash, Login, Home screens UI


### Week 2

- Event listing, event details, RSVP UI and logic
- Add/edit event forms
- Profile and My RSVPs screens


### Week 3

- Finalize About/Help, polish UI, test error handling
- Connect image storage/upload
- Document code, GitHub setup, deployment


## 13. Deliverables

- Complete Flutter project source code (GitHub repo)
- README/documentation outlining setup, app features, and usage
- Blog article with screenshots and usage demos
- LinkedIn post reference with acknowledgment


## 14. Appendix: Third-party Packages Required

- getwidget
- firebase_core, firebase_auth, cloud_firestore, firebase_storage
- google_sign_in
- image_picker (or similar)
- Other UI essentials (provider or riverpod for state management, lottie for animations, etc.)

This document outlines all requirements, user flows, technical details, components, and actions necessary for your Flutter Community Events App using GetWidget and Firebase only. Adjust the level of depth as needed during SRS, and expand documentation per module as implementation advances.

