_DEFAULT_ATTRS = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = True, providers = [JavaInfo]),
        "cli": attr.label(allow_single_file = True, providers = [JavaInfo]),
        "_host_javabase": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
}

def _java_cmd(ctx, main_class, args):
    java_bin = ctx.attr._host_javabase[java_common.JavaRuntimeInfo].java_executable_exec_path

    jars = ctx.attr.cli[JavaInfo].transitive_compile_time_jars.to_list()
    for d in ctx.attr.deps:
        jars += d[JavaInfo].transitive_compile_time_jars.to_list()

    cmd = [java_bin]
    cmd += ["-cp"]
    cmd += ["'" + ":".join([j.short_path for j in jars]) + "'"]
    cmd += [main_class]
    cmd += args

    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(output = executable, content = " ".join(cmd))

    return struct(executable = executable, files = jars + ctx.files._host_javabase)

def _java_lint_checkstyle_test_impl(ctx):
    args = []
    args += ["-c", ctx.file.cfg_file.short_path]
    args += [" ".join([s.short_path for s in ctx.files.srcs])]
    cmd = _java_cmd(ctx, "com.puppycrawl.tools.checkstyle.Main", args)

    runfiles = ctx.runfiles(files = ctx.files.srcs + cmd.files + [ctx.file.cfg_file])
    return [DefaultInfo(executable = cmd.executable, runfiles = runfiles)]

java_lint_checkstyle_test = rule(
    implementation = _java_lint_checkstyle_test_impl,
    attrs = dict(_DEFAULT_ATTRS, **{
        "cfg_file": attr.label(allow_single_file = [".xml"], mandatory = True),
    }),
    test = True,
)

def _java_lint_pmd_test_impl(ctx):
    filelist = ctx.actions.declare_file(ctx.label.name + "-list")
    ctx.actions.write(output = filelist, content = "\n".join([s.short_path for s in ctx.files.srcs]))

    args = []
    args += ["-R", ctx.file.cfg_file.short_path]
    args += ["-filelist", filelist.short_path]
    cmd = _java_cmd(ctx, "net.sourceforge.pmd.PMD", args)

    runfiles = ctx.runfiles(files = ctx.files.srcs + cmd.files + [ctx.file.cfg_file, filelist])
    return [DefaultInfo(executable = cmd.executable, runfiles = runfiles)]

java_lint_pmd_test = rule(
    implementation = _java_lint_pmd_test_impl,
    attrs = dict(_DEFAULT_ATTRS, **{
        "cfg_file": attr.label(allow_single_file = [".xml"], mandatory = True),
    }),
    test = True,
)

def _java_lint_spotbugs_test_impl(ctx):
    auxclasspath = []
    for d in ctx.attr.srcs:
        auxclasspath += d[JavaInfo].transitive_compile_time_jars.to_list()

    args = []
    args += ["-exitcode"]
    args += ["-exclude", ctx.file.cfg_file.short_path]
    args += ["-low"]
    args += ["-auxclasspath", "'" + ":".join([j.short_path for j in auxclasspath]) + "'"]
    args += [" ".join([s.short_path for s in ctx.files.srcs])]
    cmd = _java_cmd(ctx, "edu.umd.cs.findbugs.FindBugs2", args)

    runfiles = ctx.runfiles(files = ctx.files.srcs + cmd.files + auxclasspath + [ctx.file.cfg_file])
    return [DefaultInfo(executable = cmd.executable, runfiles = runfiles)]

java_lint_spotbugs_test = rule(
    implementation = _java_lint_spotbugs_test_impl,
    attrs = dict(_DEFAULT_ATTRS, **{
        "srcs": attr.label_list(allow_files = True, allow_empty = False, providers = [JavaInfo]),
        "cfg_file": attr.label(allow_single_file = [".xml"], mandatory = True),
    }),
    test = True,
)
