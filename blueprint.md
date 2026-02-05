# Recoza Application Blueprint

## Overview

Recoza is a mobile platform designed to formalize and strengthen informal recycling networks within communities. It empowers unemployed youth to become recycling collectors by building and managing a trusted client base of friends, family, and neighbors. The platform replaces chaotic, on-demand systems with an organized, predictable weekly collection schedule, turning recycling into a dignified and reliable source of income.

## Core Concepts

*   **Trust Networks:** The system is built on pre-existing social relationships. Collectors invite people they know, eliminating the safety and trust issues of dealing with strangers.
*   **Fluid User Roles:** Every user is a "Household" by default. Any household can apply to become a "Collector," creating a fluid, non-hierarchical system. A user can switch between these roles.
*   **Predictable Weekly Planning:** Collectors set a fixed collection day each week. Instead of on-demand requests, households simply log what recyclables they have available. This allows collectors to plan their routes and estimate their weekly earnings, providing stability.
*   **Offline First, Digital Log:** The physical collection happens offline based on established relationships. The app's primary role is to organize the information: what to collect, from whom, and to track the history and earnings.

## What Recoza is NOT

*   **NOT** an "Uber for recycling."
*   **NOT** on-demand or for immediate pickups.
*   **NOT** an anonymous service connecting strangers.
*   **NOT** a charity platform; it is a tool for micro-enterprise.

## Implemented Features & Structure (Current State)

This section documents the application's architecture after implementing core authentication and navigation.

### File Structure

The project has been organized by feature, with a clear separation of services, screens, and routing.

```
lib/
├── constants/
│   ├── colors.dart
│   └── strings.dart
├── models/
│   └── ... (User models etc.)
├── router/
│   └── app_router.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── activity/
│   │   └── activity_screen.dart
│   ├── collection/
│   │   └── collection_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── main_screen.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── theme/
│   ├── theme.dart
│   └── theme_provider.dart
└── main.dart
```

### Core Application Setup (`main.dart`)

*   **`MyApp`:** The root widget of the application, now a `MultiProvider` to make services like `AuthService` available to the entire widget tree.
*   **Authentication Wrapper:** The `main.dart` now includes a `StreamProvider` that listens to `authStateChanges` from `AuthService`. This stream determines whether to show the `MainScreen` or the `LoginScreen`.
*   **Theming:** Utilizes a `ThemeProvider` to manage light/dark modes.
*   **Routing:** The application now uses `go_router` for all navigation, configured in `router/app_router.dart`.

### Authentication (`auth_service.dart`, `login_screen.dart`, `signup_screen.dart`)

*   **Firebase Auth:** Integrated Firebase Authentication for email and password sign-up and sign-in.
*   **`AuthService`:** A dedicated service class to abstract all Firebase Authentication logic.
*   **Login/Signup Screens:** Clean, modern UI for users to create an account or log in. Includes form validation and error handling.
*   **Protected Routes:** `go_router` is configured with a `redirect` guard. It checks the user's authentication state and automatically redirects them to the login screen if they are not signed in.

### Main Navigation (`main_screen.dart`)

*   **Purpose:** Acts as the main container for the app's primary screens after a user logs in.
*   **`BottomNavigationBar`:** A modern, persistent navigation bar at the bottom of the screen provides access to the four main sections of the app:
    *   **Home:** The main dashboard.
    *   **Activity:** History of collections.
    *   **Collection:** View/manage collection requests.
    *   **Profile:** User settings and logout.
*   **State Management:** `MainScreen` is a `StatefulWidget` that manages the currently selected tab index to display the correct screen.

### Screens (`home`, `activity`, `collection`, `profile`)

*   **Home Screen:** The landing page after login.
*   **Activity Screen:** Placeholder for displaying user activity.
*   **Collection Screen:** Placeholder for managing collections.
*   **Profile Screen:** Contains a "Logout" button that signs the user out and redirects them to the login screen.

---

## Plan for Next Steps

**Objective:** Build out the functionality for the "Home" and "Profile" screens and establish the core user data model in Firestore.

**Steps:**

1.  **Flesh out the `HomeScreen`:**
    *   Design a UI that distinguishes between a "Household" and a "Collector" view.
    *   For now, create a welcoming UI with placeholder content.
2.  **Enhance the `ProfileScreen`:**
    *   Display user information (e.g., email).
    *   Add options to navigate to other settings screens (e.g., `Privacy Policy`, `Terms of Service`).
3.  **Implement `FirestoreService`:**
    *   Create methods in `services/firestore_service.dart` to create and retrieve user data from a `users` collection in Firestore.
4.  **User Model:**
    *   Finalize the `UserModel` class in `lib/models/user_model.dart` to represent user data stored in Firestore, including fields like `uid`, `email`, `displayName`, and `role` (e.g., 'Household').
5.  **Integrate Firestore on Sign-Up:**
    *   Modify the `signUp` method in `AuthService` to create a corresponding user document in the `users` collection in Firestore when a new user registers.
