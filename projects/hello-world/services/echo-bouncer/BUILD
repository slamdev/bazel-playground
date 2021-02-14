java_library(
    name = "lib",
    srcs = glob(["src/main/java/echobouncer/*.java"]),
    resources = glob(["src/main/resources/**"]),
    deps = [
        "@maven//:org_springframework_boot_spring_boot_starter_web",
        "@maven//:org_springframework_boot_spring_boot_autoconfigure",
        "@maven//:org_springframework_boot_spring_boot",
    ],
)

java_binary(
    name = "jar",
    main_class = "echobouncer.EchoBouncer",
    runtime_deps = [
        ":lib",
    ],
)

load("@io_bazel_rules_docker//java:image.bzl", "java_image")

java_image(
    name = "docker",
    main_class = "echobouncer.EchoBouncer",
    runtime_deps = [
        ":lib"
    ],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")

container_push(
    name = "image-push",
    format = "Docker",
    image = ":docker",
    registry = "index.docker.io",
    repository = "slamdev/bazel-playground-hello-world-echo-bouncer",
)
