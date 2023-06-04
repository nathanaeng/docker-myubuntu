" https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/

" Disable compatibility with vi which can cause issues
set nocompatible

" Enable file type detection
filetype on
filetype plugin on
filetype indent on

syntax on
set number
set cursorcolumn
set tabstop=4
set shiftwidth=4

" Use space characters instead of tab
set expandtab

" Delete 4 space characters when deleting 'tab'
set softtabstop=4

set autoindent
set smartindent
set mouse=a
set backspace=2

" Do not let cursor scroll below or above N number of lines when scrolling
set scrolloff=10

" Searching
set incsearch
set ignorecase
set showmatch
set hlsearch
set history=1000

" Enable auto completion menu after pressing TAB
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" PLUGINS ---------------------------------------------------------------- {{{

" Run :PlugInstall in Vim to install
call plug#begin('~/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'tomasiser/vim-code-dark'
    Plug 'flrnd/candid.vim'
    Plug 'joshdick/onedark.vim'
call plug#end()
colorscheme darkblue

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

inoremap {<CR>  {<CR>}<ESC>ko
" inoremap {<CR>  {<CR>}<C-o>

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
