# Base Dev Container - Arch Linux
# Minimal setup for general development

FROM archlinux:latest

# Fix pacman.conf and init keyring
RUN sed -i '/NoExtract/d' /etc/pacman.conf && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --noconfirm archlinux-keyring reflector && \
    reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm

# Install base packages
RUN pacman -Sy --noconfirm \
        base-devel \
        git \
        git-delta \
        neovim \
        sudo \
        wget \
        curl \
        openssh \
        nodejs \
        npm \
        fzf \
        ripgrep \
        unzip \
        zsh \
        zsh-completions \
        github-cli \
        docker \
        docker-buildx \
        lazydocker && \
    pacman -Scc --noconfirm

# Create vscode user with sudo
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode

# Add vscode to docker group
RUN usermod -aG docker vscode

# Setup bash history persistence
RUN mkdir -p /commandhistory && \
    touch /commandhistory/.bash_history && \
    chown -R vscode:vscode /commandhistory

# Setup workspace and claude config
RUN mkdir -p /workspaces /home/vscode/.claude && \
    chown -R vscode:vscode /workspaces /home/vscode/.claude

# Switch to vscode user
USER vscode

# Setup bash
RUN echo 'export HISTFILE=/commandhistory/.bash_history' >> ~/.bashrc && \
    echo 'export HISTSIZE=10000' >> ~/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> ~/.bashrc && \
    echo 'export PROMPT_COMMAND="history -a"' >> ~/.bashrc

# Install yay-bin
RUN git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && \
    cd /tmp/yay-bin && makepkg -si --noconfirm && \
    rm -rf /tmp/yay-bin

# Install Claude Code, Qwen Code and Cline from AUR
RUN yay -S --noconfirm claude-code qwen-code-bin cline-cli

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Configure zsh
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# User configuration' >> ~/.zshrc && \
    echo 'export HISTFILE=/commandhistory/.bash_history' >> ~/.zshrc && \
    echo 'export HISTSIZE=10000' >> ~/.zshrc && \
    echo 'export SAVEHIST=10000' >> ~/.zshrc && \
    echo 'setopt SHARE_HISTORY' >> ~/.zshrc && \
    echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> ~/.zshrc && \
    echo 'typeset -g POWERLEVEL9K_MODE=nerdfont-v3' >> ~/.zshrc && \
    echo 'typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)' >> ~/.zshrc && \
    echo 'typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs virtualenv time)' >> ~/.zshrc && \
    echo 'typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0' >> ~/.zshrc && \
    echo 'typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false' >> ~/.zshrc

# Set default shell to zsh
USER root
RUN usermod -s /bin/zsh vscode
USER vscode

# Environment variables
ENV DEVCONTAINER=true
ENV SHELL=/bin/zsh
ENV EDITOR=nvim
ENV VISUAL=nvim

WORKDIR /workspaces

# Start Docker daemon and then launch shell
ENTRYPOINT ["/bin/sh", "-c", "dockerd &>/dev/null & sleep 2 && exec /bin/zsh"]
