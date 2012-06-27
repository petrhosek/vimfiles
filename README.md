# [@petrh](http://github.com/petrh)'s Vim

To use this Vim configuration:

1.  Clone the repository:

      git clone https://github.com/petrh/vimfiles.git ~/.vim

2.  Download the plugin submodules:

      cd ~/.vim && git submodule init && git submodule update

3.  Make sure Vim finds the vimrc file by either symlinking it:

      ln -s ~/.vim/vimrc ~/.vimrc

    or by sourcing it from your own `~/.vimrc`:

      source ~/.vim/vimrc

Modeline and Notes {
vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
}
## Bundles

Using [Pathogen](https://github.com/tpope/vim-pathogen) package format for Vim _packages_
together with [Vundle](https://github.com/gmarik/vundle) as a Pathogen package manager.

Call infect to get the bundle handling started

    call pathogen#infect()
## Basic Setup

    set nocompatible      " Use vim, no vi defaults
    set number            " Show line numbers
    set ruler             " Show line and column number
    syntax enable         " Turn on syntax highlighting allowing local overrides
    set encoding=utf-8    " Set default encoding to UTF-8
### Whitespace

    set nowrap                        " don't wrap lines
    set tabstop=2                     " a tab is two spaces
    set shiftwidth=2                  " an autoindent (with <<) is two spaces
    set expandtab                     " use spaces, not tabs
    set list                          " Show invisible characters
    set backspace=indent,eol,start    " backspace through everything in insert mode
    
    if exists("g:enable_mvim_shift_arrow")
      let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
    endif
List chars

    set listchars=""                  " Reset the listchars
set listchars=tab:\ \              a tab should display as "  ", trailing whitespace as "."

    set listchars=tab:▸\              " a tab should display as "▸"
    set listchars+=trail:·            " show trailing spaces as "·"
set listchars+=eol:¬

    set listchars+=extends:◄          " The character to show in the last column when wrap is off and the line continues beyond the right of the screen
    set listchars+=precedes:►         " The character to show in the last column when wrap is off and the line continues beyond the right of the screen
### Searching

    set hlsearch    " highlight matches
    set incsearch   " incremental searching
    set ignorecase  " searches are case insensitive...
    set smartcase   " ... unless they contain at least one capital letter
### Wild settings
TODO: Investigate the precise meaning of these settings
set wildmode=list:longest,list:full
Disable output and VCS files

    set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
Disable archive files

    set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
Ignore bundler and sass cache

    set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
Disable temp and backup files

    set wildignore+=*.swp,*~,._*
### Backup and swap files

    set backupdir=~/.vim/backup//    " where to put backup files.
    set directory=~/.vim/swap//      " where to put swap files.
## Autocommands

    if has("autocmd")
      if exists("g:autosave_on_blur")
        au FocusLost * silent! wall
      endif
    endif
## Filetypes
Some file types should wrap their text

    function! s:setupWrapping()
      set wrap
      set linebreak
      set textwidth=72
      set nolist
    endfunction
    
    filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)
    
    if has("autocmd")
      " In Makefiles, use real tabs, not tabs expanded to spaces
      au FileType make set noexpandtab
    
      " Make sure all Markdown files have the correct filetype set and setup wrapping
      au BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn,txt,tex} setf markdown | call s:setupWrapping()
    
      " Treat JSON files like JavaScript
      au BufNewFile,BufRead *.json set ft=javascript
    
      " Make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
      au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
    
      " Enable autoindent for Dart
      au FileType dart set autoindent
    
      " Remember last location in file, but not for commit messages.
      au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
    
      " Switch to working directory of the open file
      au BufEnter * if expand('%:p') !~ '://' | cd %:p:h | endif
    endif
## User interface
Command line

    if has('cmdline_info')
      set ruler
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
      set showcmd
    endif
Status bar

    if has('statusline')
      set laststatus=2
      " Broken down into easily includeable segments
      set statusline=%<%f\    " Filename
      set statusline+=%w%h%m%r " Options
      "set statusline+=%{fugitive#statusline()} " Git Hotness
      "set statusline+=\ [%{&ff}/%Y]            " filetype
      "set statusline+=\ [%{getcwd()}]          " current dir
      set statusline+=%#warningmsg#
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*
      let g:syntastic_enable_signs=1
      set statusline+=%=%-14.(%l,%c%V%)\ %p%%     " Right aligned file nav info
    endif
Graphical user interface

    if has("gui_running")
      " Use nice fonts
      set guifont=Menlo\ 9
      " Start without the toolbar
      set guioptions-=T
      " Start without the menu
      set guioptions-=m
    
      " Default color scheme
      color molokai
    
      if has("autocmd")
        " Automatically resize splits when resizing MacVim window
        autocmd VimResized * wincmd =
      endif
    
      if has("gui_macvim")
        macmenu &File.New\ Tab key=<D-S-t>
      endif
    endif
## Mappings
### General Mappings (Normal, Visual, Operator-pending)
use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
(it will prompt for sudo password when writing)

    cmap w!! %!sudo tee > /dev/null %
Toggle paste mode

    nmap <silent> <F4> :set invpaste<CR>:set paste?<CR>
    imap <silent> <F4> <ESC>:set invpaste<CR>:set paste?<CR>
Set the keys to turn spell checking on/off

    nmap <silent> <F8> <Esc>:setlocal spell spelllang=en_us<CR>
    nmap <silent> <S-F8> <Esc>:setlocal nospell<CR>
format the entire file

    nmap <leader>fef ggVG=
upper/lower word

    nmap <leader>u mQviwU`Q
    nmap <leader>l mQviwu`Q
upper/lower first char of word

    nmap <leader>U mQgewvU`Q
    nmap <leader>L mQgewvu`Q
cd to the directory containing the file in the buffer

    nmap <silent> <leader>cd :lcd %:h<CR>
Create the directory containing the file in the buffer

    nmap <silent> <leader>md :!mkdir -p %:p:h<CR>
Some helpers to edit mode
http://vimcasts.org/e/14

    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%
Swap two words

    nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'
Underline the current line with '='

    nmap <silent> <leader>ul :t.\|s/./=/g\|:nohls<cr>
set text wrapping toggles

    nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>
find merge conflict markers

    nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>
Map the arrow keys to be based on display lines, not physical lines

    map <Down> gj
    map <Up> gk
Toggle hlsearch with <leader>hs

    nmap <leader>hs :set hlsearch! hlsearch?<CR>
Adjust viewports to the same size

    map <Leader>= <C-w>=
    
    if has("gui_macvim") && has("gui_running")
      " Map command-[ and command-] to indenting or outdenting while keeping the original selection in visual mode
      vmap <D-]> >gv
      vmap <D-[> <gv
    
      nmap <D-]> >>
      nmap <D-[> <<
    
      omap <D-]> >>
      omap <D-[> <<
    
      imap <D-]> <Esc>>>i
      imap <D-[> <Esc><<i
    
      " Bubble single lines
      nmap <D-Up> [e
      nmap <D-Down> ]e
      nmap <D-k> [e
      nmap <D-j> ]e
    
      " Bubble multiple lines
      vmap <D-Up> [egv
      vmap <D-Down> ]egv
      vmap <D-k> [egv
      vmap <D-j> ]egv
    
      " Map Command-# to switch tabs
      map  <D-0> 0gt
      imap <D-0> <Esc>0gt
      map  <D-1> 1gt
      imap <D-1> <Esc>1gt
      map  <D-2> 2gt
      imap <D-2> <Esc>2gt
      map  <D-3> 3gt
      imap <D-3> <Esc>3gt
      map  <D-4> 4gt
      imap <D-4> <Esc>4gt
      map  <D-5> 5gt
      imap <D-5> <Esc>5gt
      map  <D-6> 6gt
      imap <D-6> <Esc>6gt
      map  <D-7> 7gt
      imap <D-7> <Esc>7gt
      map  <D-8> 8gt
      imap <D-8> <Esc>8gt
      map  <D-9> 9gt
      imap <D-9> <Esc>9gt
    else
      " Map command-[ and command-] to indenting or outdenting while keeping the original selection in visual mode
      vmap <A-]> >gv
      vmap <A-[> <gv
    
      nmap <A-]> >>
      nmap <A-[> <<
    
      omap <A-]> >>
      omap <A-[> <<
    
      imap <A-]> <Esc>>>i
      imap <A-[> <Esc><<i
    
      " Bubble single lines
      nmap <C-Up> [e
      nmap <C-Down> ]e
      nmap <C-k> [e
      nmap <C-j> ]e
    
      " Bubble multiple lines
      vmap <C-Up> [egv
      vmap <C-Down> ]egv
      vmap <C-k> [egv
      vmap <C-j> ]egv
    
      " Make shift-insert work like in Xterm
      map <S-Insert> <MiddleMouse>
      map! <S-Insert> <MiddleMouse>
    
      " Tab control
      nnoremap <S-C-T> :tabnew<CR>
      nnoremap <S-C-left> :tabprev<CR>
      nnoremap <S-C-right> :tabnext<CR>
      noremap <S-l> gt
      nnoremap <S-h> gT
      "map <C-W> :tabclose<CR>
    
      " Map Control-# to switch tabs
      map  <C-0> 0gt
      imap <C-0> <Esc>0gt
      map  <C-1> 1gt
      imap <C-1> <Esc>1gt
      map  <C-2> 2gt
      imap <C-2> <Esc>2gt
      map  <C-3> 3gt
      imap <C-3> <Esc>3gt
      map  <C-4> 4gt
      imap <C-4> <Esc>4gt
      map  <C-5> 5gt
      imap <C-5> <Esc>5gt
      map  <C-6> 6gt
      imap <C-6> <Esc>6gt
      map  <C-7> 7gt
      imap <C-7> <Esc>7gt
      map  <C-8> 8gt
      imap <C-8> <Esc>8gt
      map  <C-9> 9gt
      imap <C-9> <Esc>9gt
    endif
### Command-Line Mappings
Insert the current directory into a command-line path

    cmap <C-P> <C-R>=expand("%:p:h") . "/"<CR>
## Plugins
### Ack

    if has("gui_macvim") && has("gui_running")
      " Command-Shift-F on OSX
      map <D-F> :Ack<space>
    else
      " Define <C-F> to a dummy value to see if it would set <C-f> as well.
      map <C-F> :dummy
    
      if maparg("<C-f>") == ":dummy"
        " <leader>f on systems where <C-f> == <C-F>
        map <leader>f :Ack<space>
      else
        " <C-F> if we can still map <C-f> to <S-Down>
        map <C-F> :Ack<space>
      endif
    
      map <C-f> <S-Down>
    endif
### CtrlP

    let g:ctrlp_map = ''
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.pyc$\|\.pyo$\|\.rbc$|\.rbo$\|\.class$\|\.o$\|\~$\',
        \ }
    if has("gui_macvim") && has("gui_running")
      map <C-p> :CtrlP<CR>
      imap <C-p> <ESC>:CtrlP<CR>
    else
      map <C-p> :CtrlP<CR>
      imap <C-p> <ESC>:CtrlP<CR>
    endif
### Fugitive

    nmap <leader>gb :Gblame<CR>
    nmap <leader>gs :Gstatus<CR>
    nmap <leader>gd :Gdiff<CR>
    nmap <leader>gl :Glog<CR>
    nmap <leader>gc :Gcommit<CR>
    nmap <leader>gp :Git push<CR>
### Gist

    if executable("pbcopy")
      " The copy command
      let g:gist_clip_command = 'pbcopy'
    elseif executable("xclip")
      " The copy command
      let g:gist_clip_command = 'xclip -selection clipboard'
    elseif executable("putclip")
      " The copy command
      let g:gist_clip_command = 'putclip'
    end
Detect filetype if vim failed auto-detection

    let g:gist_detect_filetype = 1
### Gundo
Toggle Gundo

    nmap <F5> :GundoToggle<CR>
    imap <F5> <ESC>:GundoToggle<CR>
### NERDCommenter

    if has("gui_macvim") && has("gui_running")
      map <D-/> <plug>NERDCommenterToggle<CR>
      imap <D-/> <ESC><plug>NERDCommenterToggle<CR>i
    else
      map <Leader>/ <plug>NERDCommenterToggle<CR>
      imap <Leader>/ <ESC><plug>NERDCommenterToggle<CR>i
    endif
### NERDTree

    let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']
    let NERDTreeHijackNetrw = 0
Default mapping

    map <F9> :NERDTreeToggle<CR>
    
    augroup AuNERDTreeCmd
    autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
    autocmd AuNERDTreeCmd FocusGained * call s:UpdateNERDTree()
If the parameter is a directory, cd into it

    function s:CdIfDirectory(directory)
      let explicitDirectory = isdirectory(a:directory)
      let directory = explicitDirectory || empty(a:directory)
    
      if explicitDirectory
        exe "cd " . fnameescape(a:directory)
      endif
    
      " Allows reading from stdin
      " ex: git diff | mvim -R -
      if strlen(a:directory) == 0
        return
      endif
    
      if directory
        NERDTree
        wincmd p
        bd
      endif
    
      if explicitDirectory
        wincmd p
      endif
    endfunction
NERDTree utility function

    function s:UpdateNERDTree(...)
      let stay = 0
    
      if(exists("a:1"))
        let stay = a:1
      end
    
      if exists("t:NERDTreeBufName")
        let nr = bufwinnr(t:NERDTreeBufName)
        if nr != -1
          exe nr . "wincmd w"
          exe substitute(mapcheck("R"), "<CR>", "", "")
          if !stay
            wincmd p
          end
        endif
      endif
    endfunction
### Syntastic

    let g:syntastic_enable_signs = 1
    let g:syntastic_quiet_warnings = 0
    let g:syntastic_auto_loc_list = 2
### Tagbar
Toggle Tagbar

    nmap <F7> :TagbarToggle<CR>
    imap <F7> <ESC>:TagbarToggle<CR>
### Unimpaired
Normal Mode: Bubble single lines

    nmap <C-Up> [e
    nmap <C-Down> ]e
Visual Mode: Bubble multiple lines

    vmap <C-Up> [egv
    vmap <C-Down> ]egv
### ZoomWin
Map <Leader><Leader> to ZoomWin

    map <Leader>zw :ZoomWin<CR>
