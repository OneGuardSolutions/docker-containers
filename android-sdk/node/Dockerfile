FROM runmymind/docker-android-sdk:ubuntu-standalone

RUN apt-get update \
    && apt-get install --no-install-recommends -y git curl software-properties-common gnupg build-essential \
    && mkdir /opt/gradle \
    && wget https://services.gradle.org/distributions/gradle-4.10.2-bin.zip \
    && unzip -d /opt/gradle gradle-4.10.2-bin.zip \
    && rm gradle-4.10.2-bin.zip \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:/opt/gradle/gradle-4.10.2/bin

RUN ln -s aarch64-linux-android-4.9 /opt/android-sdk-linux/ndk-bundle/toolchains/mips64el-linux-android \
    && ln -s arm-linux-androideabi-4.9 /opt/android-sdk-linux/ndk-bundle/toolchains/mipsel-linux-android \
    && /opt/tools/entrypoint.sh built-in
