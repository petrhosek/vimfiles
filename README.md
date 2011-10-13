This is my ~/.vim directory provided as it is.

Installation
============

1.  Clone the repository:

    `git clone https://github.com/petrh/vimfiles.git ~/.vim`

2.  Download the plugin submodules:

    `cd ~/.vim && git submodule init && git submodule update`

3.  Make sure Vim finds the (g)vimrc files by either symlinking them:

    `ln -s ~/.vim/vimrc ~/.vimrc`
    `ln -s ~/.vim/gvimrc ~/.gvimrc`

    or by sourcing it from your own `~/.vimrc`:

    `source ~/.vim/vimrc`
