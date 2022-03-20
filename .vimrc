set encoding=utf-8    "编码设置为utf-8,方便写中文注释
syntax on             "代码高亮
set mouse=a           "可视化模式下兼容鼠标
set number            "显示行号
set tabstop=2         "缩进配置为2格
set shiftwidth=2
set softtabstop=2  
set backspace=indent,eol,start   "开启退格跨行退格
set foldmethod=indent "开启代码折叠
set foldlevel=99
"""在三种模式下采用三种光标
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
set autoindent         "自动缩进
set cursorline         "突出显示选中的字符所在行列
set cursorcolumn 
set wildmenu           "输入命令的时候Tab显示提示
"""智能查找
set hlsearch	
exec "nohlsearch"	
set incsearch	
set ignorecase		
set smartcase
set signcolumn=yes  " 强制显示侧边栏，防止时有时无
"""在vim内部使用y和p复制粘贴
vnoremap <Leader>y "+y
nmap <Leader>p "+p
inoremap <C-l> <Right> "插入模式移动光标

"""各种语言的编译和执行（F3）、调试(F4）的环境配置(在终端中运行)
func! CompileGcc()
    exec "w"
    let compilecmd="!gcc "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpicc "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
    exec "w"
    let compilecmd="!g++ "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! RunPython()
        exec "!python %"
endfunc
func! CompileJava()
    exec "!javac %"
endfunc


func! CompileCode()
        exec "w"
        if &filetype == "cpp"
                exec "call CompileGpp()"
        elseif &filetype == "c"
                exec "call CompileGcc()"
        elseif &filetype == "python"
                exec "call RunPython()"
        elseif &filetype == "java"
                exec "call CompileJava()"
        endif
endfunc

func! RunResult()
        exec "w"
        if search("mpi\.h") != 0
            exec "!mpirun -np 4 ./%<"
        elseif &filetype == "cpp"
            exec "! ./%<"
        elseif &filetype == "c"
            exec "! ./%<"
        elseif &filetype == "python"
            exec "call RunPython"
        elseif &filetype == "java"
            exec "!java %<"
        endif
endfunc

map <F3> :call CompileCode()<CR>
imap <F3> <ESC>:call CompileCode()<CR>
vmap <F3> <ESC>:call CompileCode()<CR>

map <F4> :call RunResult()<CR>

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'frazrepo/vim-rainbow'
	let g:rainbow_active = 1 " 彩虹括号, 0代表关闭
Plug 'dense-analysis/ale'                           " 提示语法错误
Plug 'Yggdroot/indentLine'           " 显示缩进线
	"打开缩进线
	let g:indentLine_enabled = 1
	let g:indentLine_char='¦'
Plug 'itchyny/lightline.vim'         " 显示底部导航栏
Plug 'vim-airline/vim-airline'       "vim的状态栏
Plug 'valloric/youcompleteme'
	set runtimepath+=~/.vim/plugged/YouCompleteMe
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif "离开插入模式后自动关闭预览窗口"
	let g:ycm_collect_identifiers_from_tags_files = 1           " 开启 YCM基于标签引擎
	let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释与字符串中的内容也用于补全
	let g:syntastic_ignore_files=[".*\.py$"]
	let g:ycm_seed_identifiers_with_syntax = 1                  " 语法关键字补全
	let g:ycm_complete_in_comments = 1
	let g:ycm_confirm_extra_conf = 0                            " 关闭加载.ycm_extra_conf.py提示
	let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 映射按键,没有这个会拦截掉tab, 导致其他插件的tab不能用.
	let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
	let g:ycm_complete_in_comments = 1                          " 在注释输入中也能补全
	let g:ycm_complete_in_strings = 1                           " 在字符串输入中也能补全
	let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释和字符串中的文字也会被收入补全
"let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
	let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/.ycm_extra_conf.py'
	let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
	inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" 回车即选中当前项
	nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>
" 跳转到定义处
	let g:ycm_min_num_of_chars_for_completion=2                 " 从第2个键入字符就开始罗列匹配项
	let g:ycm_key_invoke_completion = '<c-z>'
	let g:ycm_semantic_triggers =  { 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'], 'cs,lua,javascript': ['re!\w{2}'], }

Plug 'octol/vim-cpp-enhanced-highlight'     "添加C++风格的高亮
	let g:cpp_class_scope_highlight = 1
	let g:cpp_member_variable_highlight = 1
	let g:cpp_class_decl_highlight = 1
	let g:cpp_experimental_simple_template_highlight = 1
	let g:cpp_experimental_template_highlight = 1
	let g:cpp_concepts_highlight = 1
Plug 'Chiel92/vim-autoformat'               "C++自动格式化插件
	let g:autoformat_autoindent = 0
	let g:autoformat_retab = 0
	let g:autoformat_remove_trailing_spaces = 0
	noremap <F3> :Autoformat<CR>
	let g:autoformat_verbosemode=1
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }      "python插件
	"开启警告
	let g:pymode_warnings = 0
	"保存文件时自动删除无用空格
	let g:pymode_trim_whitespaces = 1
	let g:pymode_options = 1
	"显示允许的最大长度的列
	let g:pymode_options_colorcolumn = 1
	"设置QuickFix窗口的最大，最小高度
	let g:pymode_quickfix_minheight = 3
	let g:pymode_quickfix_maxheight = 10
	"使用python3
	let g:pymode_python = 'python3'
	"使用PEP8风格的缩进
	let g:pymode_indent = 1
	"取消代码折叠
	let g:pymode_folding = 0
	"开启python-mode定义的移动方式
	let g:pymode_motion = 1
	"启用python-mode内置的python文档，使用K进行查找
	let g:pymode_doc = 1
	let g:pymode_doc_bind = 'K'
	"自动检测并启用virtualenv
	let g:pymode_virtualenv = 1
	"不使用python-mode运行python代码
	let g:pymode_run = 0
	"let g:pymode_run_bind = '<Leader>r'
	"不使用python-mode设置断点
	let g:pymode_breakpoint = 0
	"let g:pymode_breakpoint_bind = '<leader>b'
	"启用python语法检查
	let g:pymode_lint = 1
	"修改后保存时进行检查
	let g:pymode_lint_on_write = 0
	"编辑时进行检查
	let g:pymode_lint_on_fly = 0
	let g:pymode_lint_checkers = ['pyflakes', 'pep8']
	"发现错误时不自动打开QuickFix窗口
	let g:pymode_lint_cwindow = 0
	"侧边栏不显示python-mode相关的标志
	let g:pymode_lint_signs = 0
	"let g:pymode_lint_todo_symbol = 'WW'
	"let g:pymode_lint_comment_symbol = 'CC'
	"let g:pymode_lint_visual_symbol = 'RR'
	"let g:pymode_lint_error_symbol = 'EE'
	"let g:pymode_lint_info_symbol = 'II'
	"let g:pymode_lint_pyflakes_symbol = 'FF'
	"启用重构
	let g:pymode_rope = 1
	"不在父目录下查找.ropeproject，能提升响应速度
	let g:pymode_rope_lookup_project = 0
	"光标下单词查阅文档
	let g:pymode_rope_show_doc_bind = '<C-c>d'
	"项目修改后重新生成缓存
	let g:pymode_rope_regenerate_on_write = 1
	"开启补全，并设置<C-Tab>为默认快捷键
	let g:pymode_rope_completion = 1
	let g:pymode_rope_complete_on_dot = 1
	let g:pymode_rope_completion_bind = '<C-Tab>'
	"<C-c>g跳转到定义处，同时新建竖直窗口打开
	let g:pymode_rope_goto_definition_bind = '<C-c>g'
	let g:pymode_rope_goto_definition_cmd = 'vnew'
	"重命名光标下的函数，方法，变量及类名
	let g:pymode_rope_rename_bind = '<C-c>rr'
	"重命名光标下的模块或包
	let g:pymode_rope_rename_module_bind = '<C-c>r1r'
	"开启python所有的语法高亮
	let g:pymode_syntax = 1
	let g:pymode_syntax_all = 1
	"高亮缩进错误
	let g:pymode_syntax_indent_errors = g:pymode_syntax_all
	"高亮空格错误
	let g:pymode_syntax_space_errors = g:pymode_syntax_all
Plug 'skywind3000/asyncrun.vim'
Plug 'flazz/vim-colorschemes'           "vim颜色主题
call plug#end()

"""自动补全括号
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
"inoremap < <><Esc>i
inoremap { {}<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
inoremap { {<CR>}<Esc>O


" NERDTree.vim
" let g:NERDTreeWinPos="left"
let g:NERDTreeWinSize=25
" let g:NERDTreeShowLineNumbers=1
" let g:neocomplcache_enable_at_startup = 1
" 将打开文件树的操作映射到F8键
nnoremap <c-n> :NERDTreeToggle<cr>

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
        exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='.a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
        exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'.a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

"=================================================================
"asyncrun

" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1
" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

let g:asyncrun_mode='async'


"=================================================================
"Quickly Run  f5运行程序（自带窗口）
""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python3 %"
    endif
endfunc
map <F5> :call RunPython()<CR>
func! RunPython()
    exec "w"
    if &filetype == 'python'
            if search("@profile")
                    exec "AsyncRun kernprof -l -v %"
                    exec "copen"
                    exec "wincmd p"
             elseif search("set_trace()")
                     exec "!python3 %"
             else
                    exec "AsyncRun -raw python3 %"
                    exec "copen"
                    exec "wincmd p"
            endif
    endif
endfunc

"-- QuickFix setting --
" 按下F6，执行make clean
map <F6> :make clean<CR><CR><CR>
" 按下F7，执行make编译程序，并打开quickfix窗口，显示编译信息
map <F7> :make<CR><CR><CR> :copen<CR><CR>
" 按下F8，光标移到上一个错误所在的行
map <F8> :cp<CR>
" 按下F9，光标移到下一个错误所在的行
map <F9> :cn<CR>
" 以上的映射是使上面的快捷键在插入模式下也能用
imap <F6> <ESC>:make clean<CR><CR><CR>
imap <F7> <ESC>:make<CR><CR><CR> :copen<CR><CR>
imap <F8> <ESC>:cp<CR>
imap <F9> <ESC>:cn<CR>
