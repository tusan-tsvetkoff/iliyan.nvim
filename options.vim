scriptencoding utf-8

set pumheight=10  " Maximum number of items to show in popup menu
set pumblend=10  " pseudo transparency for completion menu

set matchpairs+=<:>,「:」,『:』,【:】,“:”,‘:’,《:》

" highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE

set noshowmode

set winblend=10  " pseudo transparency for floating window
set pumheight=8
set pumblend=10

" Do not show "match xx of xx" and other messages during auto-completion
set shortmess+=c

" Do not show search match count on bottom right (seriously, I would strain my
" neck looking at it). Using plugins like vim-anzu or nvim-hlslens is a better
" choice, IMHO.
set shortmess+=S

" Disable showing intro message (:intro)
set shortmess+=I

" Ignore certain files and folders when globing
set wildignore+=*.o,*.obj,*.dylib,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc,*.pkl
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv
set wildignorecase  " ignore file and dir name cases in cmd-completion
