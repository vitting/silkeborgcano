plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.silkeborgcano"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.silkeborgcano"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    configurations {
        getByName("debugImplementation") {
            exclude(group = "io.objectbox", module = "objectbox-android")
        }
    }

    dependencies {
        // Add the Android library with ObjectBox Admin only for debug builds.
        // Note: when the objectbox package updates, check if the Android
        // library below needs to be updated as well.
        // TODO Replace <version> with the one noted in the release notes (https://github.com/objectbox/objectbox-dart/releases)
        debugImplementation("io.objectbox:objectbox-android-objectbrowser:5.0.1")
    }
}

flutter {
    source = "../.."
}
