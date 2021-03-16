java_plugin(
    name = "lombok",
    generates_api = True,
    processor_class = "lombok.launch.AnnotationProcessorHider$AnnotationProcessor",
    visibility = ["//visibility:public"],
    deps = ["@maven//:org_projectlombok_lombok"],
)

filegroup(
    name = "checkstyle_config",
    srcs = [
        "sun_checks.xml",
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "pmd_config",
    srcs = [
        "pmd_quickstart.xml",
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "spotbugs_config",
    srcs = [
        "spotbugs_filter.xml",
    ],
    visibility = ["//visibility:public"],
)
