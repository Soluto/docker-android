FROM soluto/java-base:8

MAINTAINER Or Yagel <or@soluto.com>

ENV GRADLE_VERSION=4.9 \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    ANDROID_HOME="/opt/android" \
    GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/25.0.1:$ANDROID_HOME/build-tools/25.0.0:$ANDROID_HOME/build-tools/23.0.2:$ANDROID_HOME/build-tools/23.0.1:$ANT_HOME/bin:$MAVEN_HOME/bin

WORKDIR /opt

RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y wget curl maven ant gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386

# Installs Android SDK
RUN cd /opt && wget -q https://dl.google.com/android/repository/tools_r25.2.4-linux.zip -O android-sdk-tools.zip && \
    cd /opt && unzip -q android-sdk-tools.zip && \
    mkdir -p ${ANDROID_HOME} && \
    cd /opt && mv tools/ ${ANDROID_HOME}/tools/ && \
    cd /opt && rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  android list sdk --no-ui --all --extended
# (!!!) Only install one package at a time, as "echo y" will only work for one license!
#       If you don't do it this way you might get "Unknown response" in the logs,
#         but the android SDK tool **won't** fail, it'll just **NOT** install the package.
RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'

# SDKs
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter android-28 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-26 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-24 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-23 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-22 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-21 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-20 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-19 | grep 'package installed'

# build tools
# Please keep these in descending order!

RUN echo y | android update sdk --no-ui --all --filter build-tools-28.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-27.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.0 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.1 | grep 'package installed'

# Extras
RUN echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed'

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip && \
    # mv gradle-${GRADLE_VERSION} /opt/ && \
    rm gradle-${GRADLE_VERSION}-bin.zip && \

    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
ENV GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}"
ENV PATH $GRADLE_HOME/bin:$PATH
