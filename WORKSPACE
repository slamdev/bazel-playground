workspace(name = "bazel-playground")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Java

RULES_JVM_EXTERNAL_TAG = "3.3"
RULES_JVM_EXTERNAL_SHA = "d85951a92c0908c80bd8551002d66cb23c3434409c814179c0ff026b53544dab"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "org.springframework.boot:spring-boot-starter-web:2.4.2",
    ],
    repositories = [
        "https://jcenter.bintray.com/",
    ],
)

# Docker

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "1698624e878b0607052ae6131aa216d45ebb63871ec497f26c67455b34119c80",
    strip_prefix = "rules_docker-0.15.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.15.0/rules_docker-v0.15.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load(
    "@io_bazel_rules_docker//java:image.bzl",
    _java_image_repos = "repositories",
)

_java_image_repos()

# skylib

http_archive(
    name = "bazel_skylib",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
    ],
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

#

#load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

#RULES_HELM_VERSION = "49148fce1906e82d44b5375813b58e9989e492c0"
#RULES_HELM_SHA256 = "2e43dfeb0f0a330aa7668847ae03a1454c37baadd86875a9ae6dc3379febe3ef"
#
#http_archive(
#    name = "slamdev_rules_helm",
#    strip_prefix = "rules_helm-%s" % RULES_HELM_VERSION,
#    url = "https://github.com/slamdev/rules_helm/archive/%s.tar.gz" % RULES_HELM_VERSION,
#    sha256 = RULES_HELM_SHA256
#)

local_repository(
    name = "slamdev_rules_helm",
    path = "../rules_helm",
)

load("@slamdev_rules_helm//helm:repositories.bzl", "rules_helm_dependencies", "rules_helm_toolchains")

rules_helm_dependencies()

rules_helm_toolchains()
