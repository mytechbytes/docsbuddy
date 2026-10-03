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

// Plugin modules need two things aligned with the app: JVM target 17 (some compile at 1.8/11, which AGP rejects) and
// compileSdk 36 (a transitive dependency requires it, and Flutter doesn't propagate the app's compileSdk to plugins).
// Both are set in the AGP `finalizeDsl` hook, which runs after a plugin's own script configures `android {}` but before
// AGP locks the DSL (earlier attempts lost to the plugin's script or hit "too late to set compileSdk").
// Kotlin's jvmTarget isn't AGP-managed, so a lazy `configureEach` override covers that half.
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
