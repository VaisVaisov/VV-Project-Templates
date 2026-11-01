# FPGA (Verilog) build & simulation container - Arch Linux
# FOSS toolchain (iverilog/verilator/yosys/gtkwave/openFPGALoader) plus 32- and
# 64-bit runtime libraries so a host-installed Quartus can run inside this container.
#
# Quartus itself is NOT installed here (proprietary, huge). Mount the host install:
#   -v /opt/intelFPGA:/opt/intelFPGA:ro
# Build/run must use --network=host (VPN) and --user $(id -u):$(id -g).

FROM archlinux:latest

# Enable multilib + pick fast mirrors
RUN printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --noconfirm archlinux-keyring reflector && \
    reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm

# FOSS toolchain + 64-bit (Quartus 25.1) and 32-bit (Quartus II 13.0sp1) runtime libs
RUN pacman -S --noconfirm --needed \
        base-devel git neovim zsh \
        iverilog verilator yosys gtkwave openfpgaloader \
        alsa-lib bzip2 dbus expat fontconfig freetype2 gcc-libs glib2 \
        libdrm libice libpulse libsm libx11 libxau libxext libxi libxml2 \
        libxrender libxtst libxcrypt-compat util-linux-libs zlib \
        lib32-glibc lib32-gcc-libs lib32-zlib lib32-xz lib32-expat \
        lib32-ncurses lib32-libx11 lib32-libxau lib32-libxdmcp lib32-libxext \
        lib32-libxrender lib32-libxtst lib32-libsm lib32-libice lib32-util-linux \
        lib32-libpng lib32-freetype2 lib32-fontconfig && \
    pacman -Scc --noconfirm

# Locale (avoids "cannot change locale" warnings from Quartus' qenv.sh)
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && \
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
ENV LANG=en_US.UTF-8

WORKDIR /workspace
