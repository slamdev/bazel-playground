workspace(name = "bazel-playground", managed_directories = {"@npm": ["node_modules"]})

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

###
### Download external rules
###

# https://github.com/bazelbuild/rules_docker/releases
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59d5b42ac315e7eadffa944e86e90c2990110a1c8075f1cd145f487e999d22b3",
    strip_prefix = "rules_docker-0.17.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.17.0/rules_docker-v0.17.0.tar.gz"],
)

# https://github.com/bazelbuild/rules_jvm_external/releases
RULES_JVM_EXTERNAL_TAG = "4.0"

RULES_JVM_EXTERNAL_SHA = "31701ad93dbfe544d597dbe62c9a1fdd76d81d8a9150c2bf1ecf928ecdf97169"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

# https://github.com/bazelbuild/bazel-skylib/releases
http_archive(
    name = "bazel_skylib",
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
    ],
)

# https://github.com/junit-team/junit5-samples/pull/133
git_repository(
    name = "bazel_junit5",
    # branch = "open-source-BazelJUnit5ConsoleLauncher",
    commit = "58ae26dcac159c6179b42bad2ac0c4253fa76d6b",
    remote = "https://github.com/asinbow/junit5-samples.git",
    shallow_since = "1603169101 +0800",
)

# https://github.com/bazelbuild/rules_nodejs/releases
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "5c40083120eadec50a3497084f99bc75a85400ea727e82e0b2f422720573130f",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.0.0-beta.0/rules_nodejs-4.0.0-beta.0.tar.gz"],
)

###
### Load repository rules
###

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("@io_bazel_rules_docker//java:image.bzl", java_image_repos = "repositories")

java_image_repos()

load("@bazel_junit5//junit5-jupiter-starter-bazel:junit5.bzl", "junit_jupiter_java_repositories", "junit_platform_java_repositories")

junit_jupiter_java_repositories(version = "5.7.1")

junit_platform_java_repositories(version = "1.7.1")

load("//platform/java:deps.bzl", "maven_deps")

maven_deps()

load("//platform/js:deps.bzl", "npm_deps")

npm_deps()
