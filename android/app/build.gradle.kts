import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ── Release signing ────────────────────────────────────────────────
// The release key is read from android/key.properties (NOT committed to git).
// Without that file, debug/profile builds still work, but a RELEASE build
// stops with a clear message instead of silently using the debug key.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keystorePropertiesFile.exists()
if (hasReleaseKey) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "com.aicareer.guidance"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.aicareer.guidance"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                // Only so Gradle can configure the project. Release tasks are
                // blocked below when key.properties is missing.
                signingConfigs.getByName("debug")
            }
        }
    }
}

// Refuse to build a release APK/AAB signed with the debug key.
gradle.taskGraph.whenReady {
    val buildingRelease = allTasks.any {
        val n = it.name
        n.contains("Release") &&
            (n.startsWith("assemble") || n.startsWith("bundle") || n.startsWith("package"))
    }
    if (buildingRelease && !hasReleaseKey) {
        throw GradleException(
            "Release build blocked: android/key.properties was not found, so the app " +
                "would be signed with the DEBUG key. Create the upload keystore and " +
                "key.properties first (see README_FIX.md)."
        )
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}