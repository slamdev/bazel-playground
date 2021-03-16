load("//platform/bazel/rules/java_lint:defs.bzl", "java_lint_checkstyle_test", "java_lint_pmd_test")

def checkstyle(name, srcs):
    java_lint_checkstyle_test(
        name = name,
        srcs = srcs,
        cli = "@maven//:com_puppycrawl_tools_checkstyle",
        cfg_file = "//platform/java:checkstyle_config",
        visibility = ["//visibility:public"],
    )

def pmd(name, srcs):
    java_lint_pmd_test(
        name = name,
        srcs = srcs,
        cli = "@maven//:net_sourceforge_pmd_pmd_java8",
        cfg_file = "//platform/java:pmd_config",
        visibility = ["//visibility:public"],
    )
