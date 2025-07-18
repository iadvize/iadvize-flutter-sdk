plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val versions_buildTools: String = "35.0.0"
val versions_minSdk: Int = 24
val versions_compileSdk: Int = 35
val versions_kotlin: String = "2.1.20"
val versions_gradle: String = "8.10.1"
val versions_ndk: String = "29.0.13113456"

android {
    namespace = "com.example.sample"
    compileSdk = versions_compileSdk
    buildToolsVersion = versions_buildTools
    ndkVersion = versions_ndk

    defaultConfig {
        applicationId = "com.example.sample"
        minSdk = versions_minSdk
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.toVersion(17)
        targetCompatibility = JavaVersion.toVersion(17)
    }

    kotlin {
        jvmToolchain(17)
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
