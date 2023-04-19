
# This is a Dockerfile for the ubi8/openjdk-11:1.15 image.


## START target image ubi8/openjdk-11:1.15
## \
    FROM registry.access.redhat.com/ubi8/ubi-minimal


    USER root

###### START module 'jboss.container.user:1.0'
###### \
        # Copy 'jboss.container.user' module content
        COPY modules/jboss.container.user /tmp/scripts/jboss.container.user
        # Switch to 'root' user to install 'jboss.container.user' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.user' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y shadow-utils \
            && microdnf clean all \
            && rpm -q shadow-utils
        # Set 'jboss.container.user' module defined environment variables
        ENV \
            HOME="/home/jboss"
        # Custom scripts from 'jboss.container.user' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.user/configure.sh" ]
###### /
###### END module 'jboss.container.user:1.0'

###### START module 'jboss.container.openjdk.jdk:11'
###### \
        # Copy 'jboss.container.openjdk.jdk' module content
        COPY modules/jboss.container.openjdk.jdk /tmp/scripts/jboss.container.openjdk.jdk
        # Switch to 'root' user to install 'jboss.container.openjdk.jdk' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.openjdk.jdk' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y java-11-openjdk-devel \
            && microdnf clean all \
            && rpm -q java-11-openjdk-devel
        # Set 'jboss.container.openjdk.jdk' module defined environment variables
        ENV \
            JAVA_HOME="/usr/lib/jvm/java-11" \
            JAVA_VENDOR="openjdk" \
            JAVA_VERSION="11" \
            JBOSS_CONTAINER_OPENJDK_JDK_MODULE="/opt/jboss/container/openjdk/jdk"
        # Set 'jboss.container.openjdk.jdk' module defined labels
        LABEL \
            org.jboss.product="openjdk" \
            org.jboss.product.openjdk.version="11" \
            org.jboss.product.version="11"
        # Custom scripts from 'jboss.container.openjdk.jdk' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.openjdk.jdk/configure.sh" ]
###### /
###### END module 'jboss.container.openjdk.jdk:11'

###### START module 'jboss.container.prometheus:8.6.11'
###### \
        # Copy 'jboss.container.prometheus' module content
        COPY modules/jboss.container.prometheus /tmp/scripts/jboss.container.prometheus
        # Switch to 'root' user to install 'jboss.container.prometheus' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.prometheus' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y prometheus-jmx-exporter-openjdk11 \
            && microdnf clean all \
            && rpm -q prometheus-jmx-exporter-openjdk11
        # Set 'jboss.container.prometheus' module defined environment variables
        ENV \
            AB_PROMETHEUS_JMX_EXPORTER_CONFIG="/opt/jboss/container/prometheus/etc/jmx-exporter-config.yaml" \
            JBOSS_CONTAINER_PROMETHEUS_MODULE="/opt/jboss/container/prometheus"
        # Custom scripts from 'jboss.container.prometheus' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.prometheus/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.prometheus/backwards_compatibility.sh" ]
###### /
###### END module 'jboss.container.prometheus:8.6.11'

###### START module 'jboss.container.jolokia:8.2'
###### \
        # Copy 'jboss.container.jolokia' module content
        COPY modules/jboss.container.jolokia /tmp/scripts/jboss.container.jolokia
        # Switch to 'root' user to install 'jboss.container.jolokia' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.jolokia' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y jolokia-jvm-agent \
            && microdnf clean all \
            && rpm -q jolokia-jvm-agent
        # Set 'jboss.container.jolokia' module defined environment variables
        ENV \
            AB_JOLOKIA_AUTH_OPENSHIFT="true" \
            AB_JOLOKIA_HTTPS="true" \
            AB_JOLOKIA_PASSWORD_RANDOM="true" \
            JBOSS_CONTAINER_JOLOKIA_MODULE="/opt/jboss/container/jolokia" \
            JOLOKIA_VERSION="1.6.2"
        # Set 'jboss.container.jolokia' module defined labels
        LABEL \
            io.fabric8.s2i.version.jolokia="1.6.2-redhat-00002"
        # Exposed ports in 'jboss.container.jolokia' module
        EXPOSE 8778
        # Custom scripts from 'jboss.container.jolokia' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.jolokia/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.jolokia/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.jolokia:8.2'

###### START module 'jboss.container.maven.module:3.6'
###### \
        # Copy 'jboss.container.maven.module' module content
        COPY modules/jboss.container.maven.module /tmp/scripts/jboss.container.maven.module
        # Custom scripts from 'jboss.container.maven.module' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.maven.module/configure.sh" ]
###### /
###### END module 'jboss.container.maven.module:3.6'

###### START module 'jboss.container.maven:8.6.3.6.11'
###### \
        # Copy 'jboss.container.maven' module content
        COPY modules/jboss.container.maven /tmp/scripts/jboss.container.maven
        # Switch to 'root' user to install 'jboss.container.maven' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.maven' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y maven-openjdk11 \
            && microdnf clean all \
            && rpm -q maven-openjdk11
        # Set 'jboss.container.maven' module defined environment variables
        ENV \
            JBOSS_CONTAINER_MAVEN_36_MODULE="/opt/jboss/container/maven/36/" \
            MAVEN_VERSION="3.6"
        # Set 'jboss.container.maven' module defined labels
        LABEL \
            io.fabric8.s2i.version.maven="3.6"
        # Custom scripts from 'jboss.container.maven' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.maven/configure.sh" ]
###### /
###### END module 'jboss.container.maven:8.6.3.6.11'

###### START module 'jboss.container.s2i.core.api:1.0'
###### \
        # Set 'jboss.container.s2i.core.api' module defined environment variables
        ENV \
            S2I_SOURCE_DEPLOYMENTS_FILTER="*"
        # Set 'jboss.container.s2i.core.api' module defined labels
        LABEL \
            io.openshift.s2i.destination="/tmp" \
            io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
            org.jboss.container.deployments-dir="/deployments"
###### /
###### END module 'jboss.container.s2i.core.api:1.0'

###### START module 'jboss.container.s2i.core.bash:1.0'
###### \
        # Copy 'jboss.container.s2i.core.bash' module content
        COPY modules/jboss.container.s2i.core.bash /tmp/scripts/jboss.container.s2i.core.bash
        # Switch to 'root' user to install 'jboss.container.s2i.core.bash' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.s2i.core.bash' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y findutils rsync \
            && microdnf clean all \
            && rpm -q findutils rsync
        # Set 'jboss.container.s2i.core.bash' module defined environment variables
        ENV \
            JBOSS_CONTAINER_S2I_CORE_MODULE="/opt/jboss/container/s2i/core/"
        # Custom scripts from 'jboss.container.s2i.core.bash' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.s2i.core.bash/configure.sh" ]
###### /
###### END module 'jboss.container.s2i.core.bash:1.0'

###### START module 'jboss.container.maven.api:1.0'
###### \
###### /
###### END module 'jboss.container.maven.api:1.0'

###### START module 'jboss.container.java.jvm.api:1.0'
###### \
###### /
###### END module 'jboss.container.java.jvm.api:1.0'

###### START module 'jboss.container.proxy.api:2.0'
###### \
###### /
###### END module 'jboss.container.proxy.api:2.0'

###### START module 'jboss.container.java.proxy.bash:2.0'
###### \
        # Copy 'jboss.container.java.proxy.bash' module content
        COPY modules/jboss.container.java.proxy.bash /tmp/scripts/jboss.container.java.proxy.bash
        # Set 'jboss.container.java.proxy.bash' module defined environment variables
        ENV \
            JBOSS_CONTAINER_JAVA_PROXY_MODULE="/opt/jboss/container/java/proxy"
        # Custom scripts from 'jboss.container.java.proxy.bash' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.proxy.bash/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.proxy.bash/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.java.proxy.bash:2.0'

###### START module 'jboss.container.java.jvm.bash:1.0'
###### \
        # Copy 'jboss.container.java.jvm.bash' module content
        COPY modules/jboss.container.java.jvm.bash /tmp/scripts/jboss.container.java.jvm.bash
        # Set 'jboss.container.java.jvm.bash' module defined environment variables
        ENV \
            JBOSS_CONTAINER_JAVA_JVM_MODULE="/opt/jboss/container/java/jvm"
        # Custom scripts from 'jboss.container.java.jvm.bash' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.jvm.bash/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.jvm.bash/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.java.jvm.bash:1.0'

###### START module 'jboss.container.util.logging.bash:1.0'
###### \
        # Copy 'jboss.container.util.logging.bash' module content
        COPY modules/jboss.container.util.logging.bash /tmp/scripts/jboss.container.util.logging.bash
        # Set 'jboss.container.util.logging.bash' module defined environment variables
        ENV \
            JBOSS_CONTAINER_UTIL_LOGGING_MODULE="/opt/jboss/container/util/logging/"
        # Custom scripts from 'jboss.container.util.logging.bash' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.util.logging.bash/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.util.logging.bash/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.util.logging.bash:1.0'

###### START module 'jboss.container.maven.default:1.0'
###### \
        # Copy 'jboss.container.maven.default' module content
        COPY modules/jboss.container.maven.default /tmp/scripts/jboss.container.maven.default
        # Switch to 'root' user to install 'jboss.container.maven.default' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.maven.default' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y findutils tar \
            && microdnf clean all \
            && rpm -q findutils tar
        # Set 'jboss.container.maven.default' module defined environment variables
        ENV \
            JBOSS_CONTAINER_MAVEN_DEFAULT_MODULE="/opt/jboss/container/maven/default/"
        # Custom scripts from 'jboss.container.maven.default' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.maven.default/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.maven.default/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.maven.default:1.0'

###### START module 'jboss.container.maven.s2i:1.0'
###### \
        # Copy 'jboss.container.maven.s2i' module content
        COPY modules/jboss.container.maven.s2i /tmp/scripts/jboss.container.maven.s2i
        # Switch to 'root' user to install 'jboss.container.maven.s2i' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.maven.s2i' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y tar \
            && microdnf clean all \
            && rpm -q tar
        # Set 'jboss.container.maven.s2i' module defined environment variables
        ENV \
            JBOSS_CONTAINER_MAVEN_S2I_MODULE="/opt/jboss/container/maven/s2i"
        # Custom scripts from 'jboss.container.maven.s2i' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.maven.s2i/configure.sh" ]
###### /
###### END module 'jboss.container.maven.s2i:1.0'

###### START module 'jboss.container.java.run:1.0'
###### \
        # Copy 'jboss.container.java.run' module content
        COPY modules/jboss.container.java.run /tmp/scripts/jboss.container.java.run
        # Set 'jboss.container.java.run' module defined environment variables
        ENV \
            JAVA_DATA_DIR="/deployments/data" \
            JBOSS_CONTAINER_JAVA_RUN_MODULE="/opt/jboss/container/java/run"
        # Custom scripts from 'jboss.container.java.run' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.run/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.run/backward_compatibility.sh" ]
###### /
###### END module 'jboss.container.java.run:1.0'

###### START module 'jboss.container.java.s2i.bash:1.0'
###### \
        # Copy 'jboss.container.java.s2i.bash' module content
        COPY modules/jboss.container.java.s2i.bash /tmp/scripts/jboss.container.java.s2i.bash
        # Switch to 'root' user to install 'jboss.container.java.s2i.bash' module defined packages
        USER root
        # Install packages defined in the 'jboss.container.java.s2i.bash' module
        RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y rsync \
            && microdnf clean all \
            && rpm -q rsync
        # Set 'jboss.container.java.s2i.bash' module defined environment variables
        ENV \
            JBOSS_CONTAINER_JAVA_S2I_MODULE="/opt/jboss/container/java/s2i" \
            S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar"
        # Custom scripts from 'jboss.container.java.s2i.bash' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.s2i.bash/configure.sh" ]
###### /
###### END module 'jboss.container.java.s2i.bash:1.0'

###### START module 'jboss.container.util.pkg-update:1.0'
###### \
        # Copy 'jboss.container.util.pkg-update' module content
        COPY modules/jboss.container.util.pkg-update /tmp/scripts/jboss.container.util.pkg-update
        # Custom scripts from 'jboss.container.util.pkg-update' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.util.pkg-update/execute.sh" ]
###### /
###### END module 'jboss.container.util.pkg-update:1.0'

###### START module 'jboss.container.java.singleton-jdk:1.0'
###### \
        # Copy 'jboss.container.java.singleton-jdk' module content
        COPY modules/jboss.container.java.singleton-jdk /tmp/scripts/jboss.container.java.singleton-jdk
        # Custom scripts from 'jboss.container.java.singleton-jdk' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/jboss.container.java.singleton-jdk/configure.sh" ]
###### /
###### END module 'jboss.container.java.singleton-jdk:1.0'

###### START image 'ubi8/openjdk-11:1.15'
###### \
        # Set 'ubi8/openjdk-11' image defined environment variables
        ENV \
            JBOSS_IMAGE_NAME="ubi8/openjdk-11" \
            JBOSS_IMAGE_VERSION="1.15" \
            LANG="C.utf8" \
            PATH="$PATH:"/usr/local/s2i""
        # Set 'ubi8/openjdk-11' image defined labels
        LABEL \
            com.redhat.component="openjdk-11-ubi8-container" \
            com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI" \
            description="Source To Image (S2I) image for Red Hat OpenShift providing OpenJDK 11" \
            io.cekit.version="4.3.0" \
            io.k8s.description="Platform for building and running plain Java applications (fat-jar and flat classpath)" \
            io.k8s.display-name="Java Applications" \
            io.openshift.tags="builder,java" \
            maintainer="Red Hat OpenJDK <openjdk@redhat.com>" \
            name="ubi8/openjdk-11" \
            summary="Source To Image (S2I) image for Red Hat OpenShift providing OpenJDK 11" \
            usage="https://access.redhat.com/documentation/en-us/openjdk/11/html/using_openjdk_11_source-to-image_for_openshift/index" \
            version="1.15"
        # Exposed ports in 'ubi8/openjdk-11' image
        EXPOSE 8080 8443
###### /
###### END image 'ubi8/openjdk-11:1.15'



    # Switch to 'root' user and remove artifacts and modules
    USER root
    RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
    RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
    # Clear package manager metadata
    RUN microdnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum

    # Define the user
    USER 185
    # Define the working directory
    WORKDIR /home/jboss
    # Define run cmd
    CMD ["/usr/local/s2i/run"]
## /
## END target image