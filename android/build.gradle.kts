allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Third-party Flutter plugin modules need two things aligned with the app:
//  - JVM target: some compile Kotlin at 1.8 / Java at 11, which AGP rejects as
//    "Inconsistent JVM-target compatibility". Pin both to 17.
//  - compileSdk: Flutter doesn't propagate the app's compileSdk to plugins, so
//    they sit at flutter.compileSdkVersion (34); a transitive dependency
//    (flutter_plugin_android_lifecycle) now requires consumers to compile
//    against 36. Bump to 36.
//
// Both are set via the AGP variant API's finalizeDsl hook — it runs after the
// plugin's own build script has configured its `android {}` block, but before
// AGP locks/reads the DSL. Earlier attempts (plugins.withId immediate set, or
// afterEvaluate) lost to the plugin's own script body, or hit "too late to set
// compileSdk … already been read". Keyed on com.android.library so the app
// (com.android.application, already pinned to 36 / 17 itself) is untouched.
// Kotlin's jvmTarget isn't AGP-managed, so a lazy configureEach override is
// enough for that half.
subprojects {
    plugins.withId("com.android.library") {
        extensions.findByType(com.android.build.api.variant.LibraryAndroidComponentsExtension::class.java)
            ?.finalizeDsl { ext ->
                ext.compileSdk = 36
                ext.compileOptions.sourceCompatibility = JavaVersion.VERSION_17
                ext.compileOptions.targetCompatibility = JavaVersion.VERSION_17
            }
    }
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
