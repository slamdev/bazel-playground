java_library(
    name = "lib",
    srcs = glob(["src/main/java/echobouncer/*.java"]),
    plugins = ["//platform/java:lombok"],
    resources = glob(["src/main/resources/**"]),
    deps = [
        "//projects/hello-world/services/echo-bouncer/openapi:openapi_server_spec",
        "@maven//:org_projectlombok_lombok",
        "@maven//:org_slf4j_slf4j_api",
        "@maven//:org_springframework_boot_spring_boot",
        "@maven//:org_springframework_boot_spring_boot_autoconfigure",
        "@maven//:org_springframework_boot_spring_boot_starter_web",
    ],
)

java_binary(
    name = "jar",
    main_class = "echobouncer.EchoBouncer",
    runtime_deps = [":lib"],
)

load("@io_bazel_rules_docker//java:image.bzl", "java_image")

java_image(
    name = "docker",
    main_class = "echobouncer.EchoBouncer",
    runtime_deps = [":lib"],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")

container_push(
    name = "image-push",
    format = "Docker",
    image = ":docker",
    registry = "index.docker.io",
    repository = "slamdev/bazel-playground-hello-world-echo-bouncer",
)

load("//platform/java:java_lint_macros.bzl", "checkstyle", "pmd", "spotbugs")

checkstyle(
    name = "checkstyle",
    srcs = glob(["src/main/java/echobouncer/*.java"]),
)

pmd(
    name = "pmd",
    srcs = glob(["src/main/java/echobouncer/*.java"]),
)

spotbugs(
    name = "spotbugs",
    srcs = [":lib"],
)
