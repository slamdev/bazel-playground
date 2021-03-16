# bazel-playground

Experiments with Bazel

## Notes

Format bazel files with [buildifier](https://github.com/bazelbuild/buildtools):

```shell script
find . -name 'WORKSPACE' -o -name '*.bzl' -o -name 'BUILD'  -exec buildifier -v "{}" \;
```
