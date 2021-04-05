def _path_to_short_path_mapping_for_singlejar(file):
    return file.path + ":" + file.short_path

def _path_to_short_path_mapping_for_resjar(file):
    if not file.path.endswith("spring.factories"):
        return None
    return file.path + ":" + "META-INF/spring.factories"

def _openapi_spring_gen_impl(ctx):
    ###
    ### Generate .java source files from spec yaml
    ###
    gen_dir = ctx.actions.declare_directory(ctx.attr.name)
    gen_args = ctx.actions.args()
    gen_args.add_all([
        "-jar",
        ctx.file.cli.path,
        "generate",
        "--file=" + ctx.file.src.path,
        "--output=" + gen_dir.path,
        "--type=" + ctx.attr.type.upper(),
    ])

    if ctx.attr.use_optional:
        gen_args.add("--use-optional")

    ctx.actions.run(
        executable = ctx.attr._host_javabase[java_common.JavaRuntimeInfo].java_executable_exec_path,
        arguments = [gen_args],
        inputs = ctx.files._host_javabase + [ctx.file.cli, ctx.file.src],
        outputs = [gen_dir],
        progress_message = "Generating openapi srcs {}".format(ctx.label),
    )

    ###
    ### Create .jar file with generated .java sources
    ###
    srcjar = ctx.actions.declare_file("%s-gensrc.jar" % ctx.attr.name)
    srcjar_args = ctx.actions.args()
    srcjar_args.add_all(["--normalize", "--compression"])
    srcjar_args.add("--output", srcjar)
    srcjar_args.add_all([gen_dir], before_each = "--resources", map_each = _path_to_short_path_mapping_for_singlejar)
    srcjar_args.use_param_file("@%s", use_always = True)
    srcjar_args.set_param_file_format("multiline")

    ctx.actions.run(
        inputs = [gen_dir],
        outputs = [srcjar],
        executable = ctx.executable._singlejar,
        arguments = [srcjar_args],
        progress_message = "Creating interim source jar %s for compilation" % srcjar.basename,
    )

    ###
    ### Create .jar file with generated resources
    ###
    resjar = ctx.actions.declare_file("%s-genres.jar" % ctx.attr.name)
    resjar_args = ctx.actions.args()
    resjar_args.add_all(["--normalize", "--compression"])
    resjar_args.add("--output", resjar)
    resjar_args.add_all([gen_dir], before_each = "--resources", map_each = _path_to_short_path_mapping_for_resjar)
    resjar_args.use_param_file("@%s", use_always = True)
    resjar_args.set_param_file_format("multiline")

    ctx.actions.run(
        inputs = [gen_dir],
        outputs = [resjar],
        executable = ctx.executable._singlejar,
        arguments = [resjar_args],
        progress_message = "Creating interim source jar %s for resources" % resjar.basename,
    )

    res_java_info = JavaInfo(
        output_jar = resjar,
        compile_jar = resjar,
    )

    ##
    ## Compile java library from generated jar file and dependencies
    ##
    out_jar = ctx.actions.declare_file("{}-lib.jar".format(ctx.attr.name))
    java_info = java_common.compile(
        ctx,
        java_toolchain = ctx.attr._java_toolchain[java_common.JavaToolchainInfo],
        host_javabase = ctx.attr._host_javabase[java_common.JavaRuntimeInfo],
        source_jars = [srcjar],
        output = out_jar,
        deps = [d[JavaInfo] for d in ctx.attr.deps],
        plugins = [p[JavaInfo] for p in ctx.attr.plugins],
    )

    return [
        DefaultInfo(files = depset(direct = [out_jar, resjar])),
        java_common.merge([java_info, res_java_info]),
    ]

openapi_spring_gen = rule(
    attrs = {
        "src": attr.label(allow_single_file = [".yaml", ".yml"], mandatory = True),
        "type": attr.string(mandatory = True, values = ["server", "client", "consumer", "producer"]),
        "use_optional": attr.bool(),
        "cli": attr.label(allow_single_file = True),
        "deps": attr.label_list(providers = [JavaInfo]),
        "plugins": attr.label_list(providers = [JavaInfo]),
        "_java_toolchain": attr.label(
            default = "@bazel_tools//tools/jdk:toolchain",
            providers = [java_common.JavaToolchainInfo],
        ),
        "_host_javabase": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
        "_singlejar": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:singlejar"),
            executable = True,
            allow_files = True,
        ),
    },
    fragments = ["java"],
    provides = [DefaultInfo, JavaInfo],
    implementation = _openapi_spring_gen_impl,
)
