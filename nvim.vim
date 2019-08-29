let g:airline_powerline_fonts = 1
let g:sneak#label = 1

call plug#begin()

Plug 'elzr/vim-json'
" Plug 'tpope/vim-sensible'
Plug 'mhinz/vim-startify'
Plug 'sonph/onehalf', {'rtp': 'vim'}
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'rhysd/clever-f.vim'
Plug 'w0rp/ale'
Plug 'zxqfl/tabnine-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'
Plug 'sickill/vim-pasta'
Plug 'yuttie/comfortable-motion.vim'
Plug 'airblade/vim-rooter'
Plug 'wsdjeg/vim-fetch'
Plug 'kshenoy/vim-signature'
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-commentary'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-sleuth'

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'janko/vim-test'
Plug 'sheerun/vim-polyglot'
Plug 'tfnico/vim-gradle'

call plug#end()

" PlugUpgrade
" PlugUpdate
" PlugInstall

set encoding=UTF-8
set shell=/bin/zsh
colorscheme onehalfdark
let g:airline_theme = 'onehalfdark'
let test#strategy = 'basic'

nnoremap <Leader> :GFiles<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>/ :Rg<Space>
command! Q :q

" ale linting
let g:airline#extensions#ale#enabled = 1
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers.xml = [ 'xmllint']
let g:ale_fixers.json = [ 'prettier']
let g:ale_fixers.markdown = ['prettier']
let g:ale_fixers.yaml = ['prettier']
let g:ale_fixers.shell = ['shellcheck']
let g:ale_fixers.ruby = [
			\ 'trim_whitespace',
                        \ 'remove_trailing_lines',
			\ 'rubocop']
let g:ale_fixers.javascript = [
			\ 'standard' ]
let g:ale_ruby_rubocop_options = '--rails --display-style-guide'
let g:ale_fix_on_save = 1

let g:picker_custom_find_executable = 'rg'
let g:picker_custom_find_flags = '--color never --files --hidden'

let g:indent_guides_enable_on_vim_startup = 1

set autoread

set number
set termguicolors
set noswapfile
set wildmenu  "show list for autocomplete
set wildmode=list:full
"set wildmode=longest:full,full
" set wildoptions=pum

inoremap jk <Esc>

set clipboard+=unnamedplus

" coc
" if hidden is not set, TextEdit might fail.
set nocompatible hidden laststatus=2

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Remap for rename current word
nmap <leader>gg :Goyo<CR>
" coc end
