java_library(
    name = "lib",
    srcs = glob(["src/main/java/simplejava/*.java"]),
    deps = [
        "//platform/java/libs/logging-filter:main_lib",
    ],
)

java_binary(
    name = "jar",
    main_class = "simplejava.Main",
    runtime_deps = [":lib"],
)

load("@io_bazel_rules_docker//java:image.bzl", "java_image")

java_image(
    name = "docker",
    main_class = "simplejava.Main",
    runtime_deps = [":lib"],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")

container_push(
    name = "image-push",
    format = "Docker",
    image = ":docker",
    registry = "index.docker.io",
    repository = "slamdev/bazel-playground-hello-world-simple-java",
)
