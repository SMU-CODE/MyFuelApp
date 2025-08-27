import org.gradle.api.JavaVersion

plugins {
    // Android application plugin
    id("com.android.application")
    // Kotlin support for Android
    id("kotlin-android")
    // Flutter Gradle plugin (must be applied after Android & Kotlin)
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services plugin (for Firebase, etc.)
    id("com.google.gms.google-services")
}

android {
    // Project namespace (package name)
    namespace = "com.mu_code.myfuelapp"
    // SDK version to compile against
    compileSdk = flutter.compileSdkVersion

    // NDK version
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Enable Java 8+ API desugaring
        isCoreLibraryDesugaringEnabled = true
        // Set Java compatibility to 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Target JVM version for Kotlin
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Replace with your unique application ID
        applicationId = "com.mu_code.myfuelapp"
        // Minimum SDK version (Android 6.0+)
        minSdk = flutter.minSdkVersion
        // Target SDK version (from Flutter config)
        targetSdk = flutter.targetSdkVersion
        // Version code (incremented per release)
        versionCode = flutter.versionCode
        // Version name (e.g., "1.0.0")
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your signing config for release builds
            // Currently using debug keys for testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    dependencies {
        // Java 8+ desugaring library
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    }
}

flutter {
    // Path to the Flutter project source
    source = "../.."
}
