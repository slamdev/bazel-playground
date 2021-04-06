java_import(
    name = "slf4j",
    jars = [],
    neverlink = True,
    exports = [
        "@maven//:org_slf4j_slf4j_api",
    ],
    deps = [
        "@maven//:org_slf4j_slf4j_api",
    ],
)

java_library(
    name = "main_lib",
    srcs = glob(["src/main/java/loggingfilter/*.java"]),
    plugins = ["//platform/java:lombok"],
    visibility = ["//visibility:public"],
    deps = [
        ":slf4j",
        "@maven//:org_projectlombok_lombok",
    ],
)

java_library(
    name = "test_lib",
    srcs = glob(["src/test/java/loggingfilter/*.java"]),
    plugins = ["//platform/java:lombok"],
    visibility = ["//visibility:public"],
    deps = [
        ":main_lib",
        "@maven//:org_junit_jupiter_junit_jupiter_api",
        "@maven//:org_projectlombok_lombok",
    ],
)

load("//platform/java:java_junit_macros.bzl", "java_junit")

java_junit(
    name = "test",
    package = "ch.audienzz.lib.java.lang",
    deps = [
        ":main_lib",
        ":test_lib",
    ],
)
