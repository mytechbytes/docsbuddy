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

// Some plugins (e.g. flutter_timezone) compile their Kotlin at JVM 1.8 / their
// Java at 11, which AGP rejects with "Inconsistent JVM-target compatibility".
// Pin both to 17 for every plugin module so they match the app module.
//
// For an Android module the Java target comes from android.compileOptions
// (setting it on the JavaCompile task is silently overridden by AGP), but that
// value gets finalized during evaluation — so configure it from a
// `plugins.withId` hook that fires the moment the Android-library plugin is
// applied, before finalization. Keying on "com.android.library" naturally
// targets only the third-party plugin modules; the app applies
// "com.android.application" and already pins 17/17 itself. Kotlin's jvmTarget
// isn't AGP-managed, so a lazy configureEach override is enough.
subprojects {
    plugins.withId("com.android.library") {
        extensions.findByName("android")?.withGroovyBuilder {
            "compileOptions" {
                setProperty("sourceCompatibility", JavaVersion.VERSION_17)
                setProperty("targetCompatibility", JavaVersion.VERSION_17)
            }
        }
        // Flutter does not propagate the app's compileSdk to plugin modules, and
        // a plugin's own build script sets its compileSdk (34) in its body — which
        // runs after this hook. A transitive plugin now requires consumers to
        // compile against 36, so override it in afterEvaluate (runs after the
        // plugin's script body, before AGP finalizes the DSL) to win.
        afterEvaluate {
            extensions.findByName("android")?.withGroovyBuilder {
                setProperty("compileSdk", 36)
            }
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
