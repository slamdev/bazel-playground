load("//platform/bazel/rules/openapi_spring_gen:defs.bzl", "openapi_spring_gen")

def server(name, src):
    openapi_spring_gen(
        name = name,
        src = src,
        type = "server",
        cli = "@maven//:com_github_slamdev_openapispringgenerator_cli",
        deps = [
            "@maven//:org_projectlombok_lombok",
            "@maven//:com_fasterxml_jackson_core_jackson_databind",
            "@maven//:com_fasterxml_jackson_core_jackson_annotations",
            "@maven//:org_springframework_spring_web",
            "@maven//:org_springframework_spring_core",
        ],
        plugins = ["//platform/java:lombok"],
        visibility = ["//visibility:public"],
    )

def client(name, src):
    openapi_spring_gen(
        name = name,
        src = src,
        type = "client",
        cli = "@maven//:com_github_slamdev_openapispringgenerator_cli",
        deps = [
            "@maven//:org_projectlombok_lombok",
            "@maven//:com_fasterxml_jackson_core_jackson_databind",
            "@maven//:com_fasterxml_jackson_core_jackson_annotations",
            "@maven//:org_springframework_spring_web",
            "@maven//:org_springframework_spring_core",
            "@maven//:org_springframework_spring_context",
            "@maven//:org_springframework_spring_beans",
            "@maven//:org_springframework_boot_spring_boot",
        ],
        plugins = ["//platform/java:lombok"],
        visibility = ["//visibility:public"],
    )
