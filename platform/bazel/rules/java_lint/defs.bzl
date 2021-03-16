def _java_lint_checkstyle_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)

    java_bin = ctx.attr._host_javabase[java_common.JavaRuntimeInfo].java_executable_exec_path

    jars = ctx.attr.cli[JavaInfo].transitive_compile_time_jars.to_list()

    cmd = [java_bin]
    cmd += ["-cp"]
    cmd += ["'" + ":".join([j.path for j in jars]) + "'"]
    cmd += ["com.puppycrawl.tools.checkstyle.Main"]
    cmd += ["-c", ctx.file.cfg_file.path]
    cmd += [" ".join([s.path for s in ctx.files.srcs])]

    ctx.actions.write(output = executable, content = " ".join(cmd))

    runfiles = ctx.runfiles(files = ctx.files.srcs + ctx.files._host_javabase + jars + [ctx.file.cfg_file])
    return [DefaultInfo(executable = executable, runfiles = runfiles)]

java_lint_checkstyle_test = rule(
    implementation = _java_lint_checkstyle_test_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "cli": attr.label(allow_single_file = True, providers = [JavaInfo]),
        "cfg_file": attr.label(allow_single_file = [".xml"], mandatory = True),
        "_host_javabase": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
    },
    test = True,
)

def _java_lint_pmd_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)

    java_bin = ctx.attr._host_javabase[java_common.JavaRuntimeInfo].java_executable_exec_path

    jars = ctx.attr.cli[JavaInfo].transitive_compile_time_jars.to_list()

    cmd = [java_bin]
    cmd += ["-cp"]
    cmd += ["'" + ":".join([j.path for j in jars]) + "'"]
    cmd += ["net.sourceforge.pmd.PMD"]
    cmd += ["-R", ctx.file.cfg_file.path]
    cmd += ["-d", "'" + " ".join([s.path for s in ctx.files.srcs]) + "'"]

    ctx.actions.write(output = executable, content = " ".join(cmd))

    runfiles = ctx.runfiles(files = ctx.files.srcs + ctx.files._host_javabase + jars + [ctx.file.cfg_file])
    return [DefaultInfo(executable = executable, runfiles = runfiles)]

java_lint_pmd_test = rule(
    implementation = _java_lint_pmd_test_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "cli": attr.label(allow_single_file = True, providers = [JavaInfo]),
        "cfg_file": attr.label(allow_single_file = [".xml"], mandatory = True),
        "_host_javabase": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
    },
    test = True,
)
