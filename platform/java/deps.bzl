load("@rules_jvm_external//:defs.bzl", "maven_install")

def maven_deps():
    maven_install(
        artifacts = [
            "org.springframework.boot:spring-boot-starter-web:2.4.2",
            "org.springframework.boot:spring-boot:2.4.2",
            "org.slf4j:slf4j-api:1.7.30",
            "org.projectlombok:lombok:1.18.16",
            "com.fasterxml.jackson.core:jackson-databind:2.11.3",
            "org.springframework:spring-web:5.2.10.RELEASE",
            "org.springframework:spring-core:5.2.10.RELEASE",
            "org.springframework:spring-context:5.2.10.RELEASE",
            "org.springframework:spring-beans:5.2.10.RELEASE",
            "com.fasterxml.jackson.core:jackson-annotations:2.11.3",
            "com.github.slamdev.openapispringgenerator:cli:0.1.1",
        ],
        repositories = [
            "https://jcenter.bintray.com/",
            "https://slamdev:a16cdddffba4c620c9766b456b7e9afa4a29317a@maven.pkg.github.com/slamdev/openapi-spring-generator",
        ],
    )
