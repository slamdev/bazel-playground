java_library(
    name = "lib",
    srcs = glob(["src/main/java/importboms/*.java"]),
    deps = [
        "@maven//:ch_qos_logback_logback_classic",
        "@maven//:org_apache_maven_maven_resolver_provider",
        "@maven//:org_apache_maven_resolver_maven_resolver_api",
        "@maven//:org_apache_maven_resolver_maven_resolver_connector_basic",
        "@maven//:org_apache_maven_resolver_maven_resolver_impl",
        "@maven//:org_apache_maven_resolver_maven_resolver_spi",
        "@maven//:org_apache_maven_resolver_maven_resolver_transport_file",
        "@maven//:org_apache_maven_resolver_maven_resolver_transport_http",
        "@maven//:org_apache_maven_resolver_maven_resolver_util",
        "@maven//:org_slf4j_slf4j_api",
    ],
)

java_binary(
    name = "cli",
    main_class = "importboms.Main",
    runtime_deps = [":lib"],
)

load("//platform/java:java_lint_macros.bzl", "checkstyle", "pmd", "spotbugs")

checkstyle(
    name = "checkstyle",
    srcs = glob(["src/main/java/importboms/*.java"]),
)

pmd(
    name = "pmd",
    srcs = glob(["src/main/java/importboms/*.java"]),
)

spotbugs(
    name = "spotbugs",
    srcs = [":lib"],
)
