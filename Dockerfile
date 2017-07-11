FROM ubuntu:latest

WORKDIR /root

RUN apt-get -qq update

RUN apt-get install -y build-essential bzip2 gcc python python-dev vim wget 

RUN touch user-config.jam \
    && echo "# user-config.jam file" >> user-config.jam \
    && echo "# Defines which standalone toolchains to use for building." >> user-config.jam \
    && echo -e "\nstandalone_toolchain_dir = /portal/Desktop/standalone_toolchains ;" >> user-config.jam \
    && echo -e "\n# Uncomment to build using preferred toolchain." >> user-config.jam \
    && echo -e "\nusing clang : arm : $(standalone_toolchain_dir)/arm/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : armv7a : $(standalone_toolchain_dir)/arm/bin/clang++ : <cxxflags>\"-march=armv7-a -std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : arm64 : $(standalone_toolchain_dir)/arm64/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : mips : $(standalone_toolchain_dir)/mips/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : mips64 : $(standalone_toolchain_dir)/mips64/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : x86 : $(standalone_toolchain_dir)/x86/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam \
    && echo "# using clang : x86_64 : $(standalone_toolchain_dir)/x86_64/bin/clang++ : <cxxflags>\"-std=c++11\" ;" \
            >> user-config.jam

RUN touch bootstrap.sh \
    && echo "mkdir standalone_toolchains" >> bootstrap.sh \
    && echo "mkdir boost-android" >> bootstrap.sh
    && echo "wget https://dl.google.com/android/repository/android-ndk-r15b-linux-x86_64.zip" >> bootstrap.sh \
    && echo "unzip android-ndk-r15b-linux-x86_64.zip" >> bootstrap.sh \
    && echo "android-ndk-r15b-linux-x86_64/build/tools/make_standalone_toolchain.py --arch arm --install-dir ~/standalone_toolchains/arm" >> bootstrap.sh \
    && echo "android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch arm64 --install-dir ~/standalone_toolchains/arm64" >> bootstrap.sh \
    && echo "android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch mips --install-dir ~/standalone_toolchains/mips" >> bootstrap.sh \
    && echo "android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch mips64 --install-dir ~/standalone_toolchains/mips64" >> bootstrap.sh \
    && echo "android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch x86 --install-dir ~/standalone_toolchains/x86" >> bootstrap.sh \
    && echo "android-ndk-r15b/build/tools/make_standalone_toolchain.py --arch x86_64 --install-dir ~/standalone_toolchains/x86_64" >> bootstrap.sh

CMD /bin/bash

