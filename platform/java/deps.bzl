load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")

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
            maven.repository(
                "https://maven.pkg.github.com/slamdev/openapi-spring-generator",
                user = "PublicToken",
                password = "4 9 2 1 d 7 3 b 2 7 6 0 0 0 e 0 0 7 d d 5 d b 9 7 e 6 7 7 e 2 4 6 0 3 2 3 a d 0".replace(" ", "")
            ),
        ],
    )
