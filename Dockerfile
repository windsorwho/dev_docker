FROM nvcr.io/nvidia/pytorch:21.09-py3
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install tzdata -y
RUN apt-get update && apt-get --assume-yes --upgrade install cmake build-essential cmake python3-dev
# User config
ENV UHOME="/root"
RUN git clone https://github.com/VundleVim/Vundle.vim.git $UHOME/.vim/bundle/Vundle.vim
RUN git clone --depth 1  https://github.com/Valloric/YouCompleteMe \
    $UHOME/.vim/bundle/YouCompleteMe/ \
    && cd $UHOME/.vim/bundle/YouCompleteMe \
    && git submodule update --init --recursive \
    && python3 $UHOME/.vim/bundle/YouCompleteMe/install.py --clangd-completer

COPY vimrc $UHOME/.vimrc
COPY bashrc $UHOME/.bashrc
RUN vim  +PluginInstall +qall

RUN rm -rf \
    $UHOME/.vim/bundle/YouCompleteMe/third_party/ycmd/clang_includes \
    $UHOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp

USER $UNAME

ENV TERM=xterm-256color

# List of Vim plugins to disable
ENV DISABLE=""

#ENTRYPOINT ["sh", "/usr/local/bin/run"]
