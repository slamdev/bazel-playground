load("@rules_jvm_external//:defs.bzl", "maven_install")

def maven_deps():
    maven_install(
        artifacts = [
            "org.springframework.boot:spring-boot-starter-web:2.4.2",
        ],
        repositories = [
            "https://jcenter.bintray.com/",
        ],
    )
