load("@npm//@bazel/typescript:index.bzl", "ts_project")

# This is a workaround for https://github.com/bazelbuild/rules_nodejs/issues/2441
load("@npm//@bazel/concatjs/devserver:concatjs_devserver.bzl", concatjs_devserver = "concatjs_devserver_macro")

package(default_visibility = ["//visibility:public"])

ts_project(
    name = "app",
    srcs = glob(["src/*.tsx"]),
    tsconfig = ":tsconfig.json",
    validate = False,
    deps = [
        "@npm//@types/react",
        "@npm//@types/react-dom",
        "@npm//@types/styled-components",
        "@npm//react",
        "@npm//react-dom",
        "@npm//styled-components",
        "@npm//typescript",
    ],
)

filegroup(
    name = "umd_modules_for_devserver",
    srcs = [
        "@npm//react:react__umd",
        "@npm//react-dom:react-dom__umd",
        "@npm//styled-components:styled-components__umd",
    ],
    visibility = ["//visibility:private"],
)

concatjs_devserver(
    name = "devserver",
    entry_module = "bazel-playground/projects/hello-world/web/app-one/src/index.js",
    port = 8080,
    deps = [
        ":app",
        ":umd_modules_for_devserver",
    ],
    static_files = [
            "index.html",
        ],
)
