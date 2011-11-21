" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
" }

" Setup Bundle Support (pathogen plugin) {
  filetype off
  runtime! autoload/pathogen.vim
  silent! call pathogen#runtime_append_all_bundles()
  silent! call pathogen#helptags()
" }

" Basics {
  set nocompatible

  set encoding=utf-8
  scriptencoding utf-8
  set hidden
" }

" General {
  " Syntax highlighting
  syntax enable

  set shortmess+=filmnrxoOtT
  set viewoptions=folds,options,cursor,unix,slash
  set virtualedit=onemore

  set history=50
  set backup

  " Setting up the directories {
    " Setup directories for backup, swap and view files
    "set backupdir=./.backup,.,/tmp
    "set directory=.,./.backup,/tmp

    set backupdir=~/.vim/backup
    set directory=~/.vim/backup
    set viewdir=~/.vim/view

    " Creating directories if they don't exist
    silent execute '!mkdir -p $HOME/.vim/backup'
    silent execute '!mkdir -p $HOME/.vim/view'

    " Automatically load/save view (state)
    if has('autocmd')
      autocmd BufWinLeave * silent! mkview!
      autocmd BufWinEnter * silent! loadview
    endif
  " }
" }

" Formatting {
  " Long lines settings
  set textwidth=78

  " Whitespace stuff
  set nowrap
  "set tabstop=2
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set list listchars=tab:\ \ ,trail:·

  " (auto-)indentation
  set autoindent
  set pastetoggle=<F2>
" }

" User Interface {
  set title
  set showmode
  set cursorline
  set number

  " Command line
  if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
  endif

  " Status bar
  if has('statusline')
    set laststatus=2
    set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
  endif

  set backspace=indent,eol,start
  set noequalalways

  " Use modeline overrides
  set modeline
  set modelines=10

  " Searching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

  " Tab completion
  set wildmode=list:longest,list:full
  set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

  " Scrolling
  set scrolloff=2

  " Enable code folding by syntax and disable folding by default
  setlocal foldmethod=syntax
  setlocal nofoldenable

  " Highlight any text that goes beyond the 80th character of a line
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  match OverLength /\%81v.\+/

  " Don't wake up system with blinking cursor (http://www.linuxpowertop.org/known.php)
  let &guicursor = &guicursor . ",a:blinkon0"
" }

" Filetype Specifics {
  " Only do this part when compiled with support for autocommands
  if has('autocmd')
    augroup system
      autocmd!
      " In text files, always limit the width of text to 78 characters
      autocmd BufRead *.txt set textwidth=78
      " When editing a file, always jump to the last cursor position
      autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \   exe "normal! g'\"" |
      \ endif
      " Don't write swapfile on most commonly used directories for NFS mounts or USB sticks
      autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp

      " Switch to working directory of the open file
      autocmd BufEnter * lcd %:p:h
    augroup END

    " Enable formatting based on file types
    augroup filetypes
      autocmd!
      autocmd FileType ruby,eruby,yaml,cucumber,vim,lua,latex,tex set expandtab shiftwidth=2 softtabstop=2
      autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
      autocmd FileType make set noexpandtab
      autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ai formatoptions=tcroqn2 comments=n:>
      autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set filetype=ruby
      autocmd BufRead *.json set filetype=json
      autocmd BufRead *.txt set wrap wrapmargin=72 textwidth=72
   augroup END
  endif

  " Load the plugin and indent settings for the detected filetype
  filetype plugin indent on
" }

" Key Mappings {
  " Makes ,w split windows vertically
  nnoremap <leader>w <C-w>v<C-w>l

  " Split window navigation
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  nnoremap <S-h> gT
  nnoremap <S-l> gt
  noremap <leader>w <C-w>v<C-w>l

  " Tab control
  map <S-C-T> :tabnew<CR>
  map <S-C-left> :tabprev<CR>
  map <S-C-right> :tabnext<CR>
  map <C-W> :tabclose<CR>

  " Easier moving between wrapped lines
  nmap <silent> j gj
  nmap <silent> k gk

  " Clear the search buffer
  nnoremap <silent> <leader><space> :noh<CR>
 
  " Toggle settings
  nnoremap <leader>c :set cursorline!<CR>

  " Opens an edit command with the path of the currently edited file filled in
  map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

  " Opens a tab edit command with the path of the currently edited file filled in
  map <leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

  " Inserts the path of the currently edited file into a command
  cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

  " Set the keys to turn spell checking on/off
  nmap <silent> <F8> <Esc>:setlocal spell spelllang=en_us<CR>
  nmap <silent> <S-F8> <Esc>:setlocal nospell<CR>
" }

" Functions {
  map <leader>s :call StripWhitespace ()<CR>
  function! StripWhitespace ()
      exec ':%s/ \+$//gc'
  endfunction

  map <leader>df :call DistractionFreeWriting ()<CR>
  function! DistractionFreeWriting ()
    exec ':set fuoptions='
    exec ':set fullscreen'
    exec ':set columns=80'
    exec ':set guioptions-=r'
    exec ':set textwidth=76'
    exec ':set nonumber'
    exec ':set norelativenumber'
  endfunction

  " Show syntax highlighting groups for word under cursor
  nmap <C-s-p> :call <SID>SynStack()<CR>
  function! <SID>SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunction
" }

" Plugins {
  " Ack {
    " Settings for ack.vim; uncomment suitable line if necessary
    "let g:ackprg="ack -H --nocolor --nogroup"         " if ack --version < 1.92
    "let g:ackprg="ack-grep -H --nocolor --nogroup"    " for Debian/Ubuntu
  " }

  " Command-T {
    let g:CommandTMaxHeight=20
  " }

  " Conque {
    nnoremap <leader>t :ConqueTermSplit bash<CR>
  " }

  " Gist {
    if has("mac")
      let g:gist_clip_command = 'pbcopy'
    elseif has("unix")
      let g:gist_clip_command = 'xclip -selection clipboard'
    endif
    let g:gist_detect_filetype = 1
    let g:gist_open_browser_after_post = 1
  " }

  " LaTeX {
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
  " }

  " NERDTree {
    let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
    map <F9> :NERDTreeToggle<CR>

    let NERDChristmasTree = 1
    let NERDTreeHighlightCursorline = 1
    let NERDTreeMapActivateNode='<CR>'
  " }

  " Rails {
    let g:rails_statusline=0
  " }

  " Rainbows {
    nmap <leader>R :ToggleRaibowParenthesis<CR>
  " }

  " Taglist {
    let Tlist_Use_Right_Window = 1

    map <leader>rt :!ctags --extra=+f -R *<CR><CR>
    map <C-\> :tnext<CR>
    nnoremap <silent> <F7> :TlistToggle<CR>
  " }

  " Supertab {
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<C-n>"
  " }

  " Scratch {
    function! ToggleScratch()
      if expand('%') == g:ScratchBufferName
        quit
      else
        Sscratch<CR><C-W>x<C-j>:resize 15
      endif
    endfunction

  " Define Scratch key mapping
    nmap <leader><tab> :call ToggleScratch()<CR>
  " }

  " Syntastic {
    let g:syntastic_enable_signs = 1
    let g:syntastic_quiet_warnings = 1
  " }

  " Unimpaired {
    " Bubble single lines
    nmap <C-Up> [e
    nmap <C-Down> ]e
    " Bubble multiple lines
    vmap <C-Up> [egv
    vmap <C-Down> ]egv
  " }

  " ZoomWin {
    map <Leader><Leader> :ZoomWin<CR>
  " }
" }
