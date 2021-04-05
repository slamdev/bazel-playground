load("//platform/java:openapi_spring_gen_macros.bzl", "client", "server")

server(
    name = "openapi_server_spec",
    src = "http-spec-v3.yaml",
)

client(
    name = "openapi_client_spec",
    src = "http-spec-v3.yaml",
)

load("//platform/java:java_lint_macros.bzl", "openapi")

openapi(
    name = "openapi_lint",
    srcs = glob(["*.yaml"]),
)
