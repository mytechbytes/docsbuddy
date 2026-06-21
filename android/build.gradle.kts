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
// Pin both to 17 for every subproject so they always match the app module.
//
// NB: for an Android module the Java target comes from android.compileOptions —
// setting it on the JavaCompile task is silently overridden by AGP — so it must
// be configured through the extension (done reflectively to avoid depending on
// AGP's internal extension types). Kotlin's jvmTarget isn't AGP-managed, so the
// task-level override sticks. Both run in afterEvaluate, once the plugin (and
// its `android {}` extension) has been applied to the subproject.
subprojects {
    val applyJvm17: Project.() -> Unit = {
        extensions.findByName("android")?.withGroovyBuilder {
            "compileOptions" {
                setProperty("sourceCompatibility", JavaVersion.VERSION_17)
                setProperty("targetCompatibility", JavaVersion.VERSION_17)
            }
        }
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
    // evaluationDependsOn(":app") above forces :app to evaluate early, so it may
    // already be evaluated here — afterEvaluate would then throw. Guard on state.
    if (state.executed) applyJvm17() else afterEvaluate { applyJvm17() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
