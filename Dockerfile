FROM ubuntu:latest as builder
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget sqlite3 libsqlite3-dev
RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

#Installing Android SDK
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/user/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;30.0.3" "patcher;v4" "platform-tools" "platforms;android-33" "sources;android-33"
ENV PATH "$PATH:/home/user/Android/sdk/platform-tools"

#Installing Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/user/flutter/bin"
# RUN flutter channel dev
RUN flutter upgrade
RUN flutter doctor

#Add project files
RUN mkdir -p projects
WORKDIR /home/user/projects
# ADD . .
# RUN rm pubspec.lock && rm -r .dart_tool
# RUN echo $USER
RUN pwd
RUN ls
# RUN chown -R user /home/user/flutter
# RUN chown -R user /home/user/projects/Xpensis
RUN git clone https://github.com/mateen-demah/Xpensis.git
# RUN sudo -E apt install -y sqlite3 libsqlite3-dev
# RUN cd Xpensis && flutter test