def java_junit(name, deps, package):
    native.java_test(
        name = name,
        use_testrunner = False,
        main_class = "com.flexport.bazeljunit5.BazelJUnit5ConsoleLauncher",
        args = ["--select-package", package],
        runtime_deps = [
            "@bazel_junit5//junit5-jupiter-starter-bazel/bazeljunit5/src/main/java/com/flexport/bazeljunit5:bazeljunit5",
            "@maven//:org_junit_jupiter_junit_jupiter_engine",
            "@maven//:org_junit_platform_junit_platform_console",
            "@maven//:org_junit_platform_junit_platform_engine",
            "@maven//:org_junit_platform_junit_platform_launcher",
        ] + deps,
    )
