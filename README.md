# bazel-playground

Experiments with Bazel

## Notes

Format bazel files with [buildifier](https://github.com/bazelbuild/buildtools):

```shell script
for f in $(find . -name 'WORKSPACE' -o -name '*.bzl' -o -name 'BUILD') ; do buildifier -v $f; done
```

### Useful bazel commands

- build everything
```shell
./baseliskw build //...
```

- update node modules
```shell
./baseliskw run @nodejs//:npm -- install
```

### Implement building only changed parts

https://github.com/Tinder/bazel-diff
