FROM --platform=linux/amd64 ubuntu:23.04
ENV PATH="/etc/profile.d/miniconda3/bin:$PATH"

ARG USER_NAME
ARG USER_PASSWORD

ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD

# Install packages and setup user
RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    wget \
    git \
    gdb \
    valgrind \
    vim \
    zsh \
    nodejs \
    locales \
    npm \
    curl \
    fonts-powerline \
    # set up locale
    && locale-gen en_US.UTF-8 \
    # add a user
    && adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME --gecos "User" $USER_NAME \
    # update the password
    && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME

# Install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /etc/profile.d/miniconda3 \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

SHELL ["/bin/zsh", "-c"]

USER $USER_NAME

# Create .vimrc
WORKDIR /home/${USER_NAME}
COPY ./.vimrc .
WORKDIR /
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Setup zsh and p10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
RUN echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>! ~/.zshrc

CMD [ "zsh" ]

# Set /root as default directory
RUN echo "cd ~/" >> ~/.bashrc
RUN echo "cd ~/" >> ~/.zshrc