
FROM ubuntu:latest

WORKDIR /root

RUN apt-get -qq update

RUN apt-get install -y wget gcc vim python python-dev bzip2

RUN mkdir standalone_toolchains \
    && mkdir boost-android

RUN wget https://dl.google.com/android/repository/android-ndk-r15b-linux-x86_64.zip \
    && unzip android-ndk-r15b-linux-x86_64.zip

RUN android-ndk-r15b-linux-x86_64/build/tools/make_standalone_toolchain.py --arch arm --install-dir ~/standalone_toolchains/arm \
    && android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm64 --install-dir ~/standalone_toolchains/arm64 \
    && android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch mips --install-dir ~/standalone_toolchains/mips \
    && android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch mips64 --install-dir ~/standalone_toolchains/mips64 \
    && android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch x86 --install-dir ~/standalone_toolchains/x86 \
    && android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch x86_64 --install-dir ~/standalone_toolchains/x86_64

RUN touch user-config.jam \
    && echo "# user-config.jam file" >> user-config.jam \
    && echo "# Defines which standalone toolchains to use for building." >> user-config.jam \
    && echo -e "\nstandaloneToolchains = /home/ubuntu/standalone_toolchains ;" >> user-config.jam \
    && echo -e "\n# Uncomment to build using preferred toolchain." >> user-config.jam \
    && echo -e "\nusing clang : arm : $(standaloneToolchains)/arm/bin/arm-linux-androideabi-clang++ ;" \
            >> user-config.jam \
    && echo "# using clang : arm64 : $(standaloneToolchains)/arm64/bin/aarch64-linux-android-clang++ ;" \
            >> user-config.jam \
    && echo "# using clang : mips : $(standaloneToolchains)/mips/bin/mipsel-linux-android-clang++ ;" \
            >> user-config.jam \
    && echo "# using clang : mips64 : $(standaloneToolchains)/mips64/bin/mips64el-linux-android-clang++ ;" \
            >> user-config.jam \
    && echo "# using clang : x86 : $(standaloneToolchains)/x86/bin/i686-linux-android-clang++ ;" \
            >> user-config.jam \
    && echo "# using clang : x86_64 : $(standaloneToolchains)/x86_64/bin/x86_64-linux-android-clang++ ;" \
            >> user-config.jam \

CMD /bin/bash

