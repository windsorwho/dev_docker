FROM ubuntu:21.04
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install tzdata -y
RUN apt-get update && apt-get --assume-yes --upgrade install python3 pip cmake build-essential cmake python3-dev git vim
# User config
ENV UHOME="/root"
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install black flake8 python-language-server

# Flake8 compatability with Black.
RUN mkdir -p /root/.config
RUN printf "[flake8]\nmax-line-length=88\nextend-ignore=E203" >> /root/.config/flake8

# Make vim first class.
RUN echo set -o vi >> /root/.bashrc && \
    echo export VISUAL=vim >> /root/.bashrc && \
    echo export EDITOR=vim >> /root/.bashrc

# Install vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
COPY vimrc /root/.vimrc

# Install plugins

RUN vim +PluginInstall +qall
COPY vim_additions /root/vim_additions
RUN cat /root/vim_additions >> /root/.vimrc
RUN rm /root/vim_additions 

# Setup TabNine configs. Make sure the config and model are accessible.
#COPY TabNine /root/.config/TabNine
#COPY b8373e4b.tabninemodel /root/.local/share/TabNine/models/b8373e4b.tabninemodel

# Ctags setup.
RUN apt-get update
RUN apt-get install -y build-essential autoconf automake libtool pkg-config
RUN git clone https://github.com/universal-ctags/ctags.git
RUN cd ctags && ./autogen.sh && ./configure && make && make install

# Index libraries in path.
# See https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/
RUN ctags -R --fields=+l --languages=python --python-kinds=-iv -f /root/tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
RUN echo set tags=/root/tags >> /root/.vimrc

ENV TERM=xterm-256color


