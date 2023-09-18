FROM archlinux:base-devel

RUN pacman -Syu --noconfirm git wget arm-none-eabi-gcc arm-none-eabi-newlib arm-none-eabi-binutils zip

RUN wget https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil -O /usr/bin/nrfutil
RUN chmod +x /usr/bin/nrfutil

RUN useradd --user-group --system --create-home --no-log-init chameleon-cloud

USER chameleon-cloud
WORKDIR /home/chameleon-cloud

RUN nrfutil install completion device nrf5sdk-tools trace

USER root

COPY ./build.sh /home/chameleon-cloud/build.sh
RUN chown chameleon-cloud:users /home/chameleon-cloud/build.sh
RUN chmod +x /home/chameleon-cloud/build.sh
USER chameleon-cloud

RUN git clone https://aur.archlinux.org/jlink-software-and-documentation.git
WORKDIR /home/chameleon-cloud/jlink-software-and-documentation
USER root
RUN pacman -Sy --noconfirm $(cat PKGBUILD | tr "\n" " " | awk -F " depends=" '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1 | sed "s/'//g") $(cat PKGBUILD | tr "\n" " " | awk -F " makedepends=" '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1 | sed "s/'//g")
USER chameleon-cloud
RUN makepkg
USER root
RUN pacman -U jlink-software-and-documentation-*.pkg.tar.* --noconfirm
USER chameleon-cloud
WORKDIR /home/chameleon-cloud

RUN git clone https://aur.archlinux.org/nrf-command-line-tools-bin.git
WORKDIR /home/chameleon-cloud/nrf-command-line-tools-bin
USER root
RUN pacman -Sy --noconfirm $(cat PKGBUILD | tr "\n" " " | awk -F " depends=" '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1 | sed "s/'//g" | sed 's/jlink-software-and-documentation//g') $(cat PKGBUILD | tr "\n" " " | awk -F " makedepends=" '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1 | sed "s/'//g")
USER chameleon-cloud
RUN makepkg
USER root
RUN pacman -U nrf-command-line-tools-bin-*.pkg.tar.* --noconfirm
USER chameleon-cloud
WORKDIR /home/chameleon-cloud
