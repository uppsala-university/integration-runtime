class java {

        $version = "1.7.0"

        package { "java-$version-openjdk":
                ensure          => present
        }
}
