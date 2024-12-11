-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.o)

--**************************************--
--            "normal"
--**************************************--
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "
vim.g.indentLine_char = '︙'

vim.o.number=true
vim.o.hlsearch=true
vim.o.autoindent=false
vim.o.ruler=true

vim.o.shiftwidth=2
vim.o.softtabstop=2
vim.o.tabstop=2
vim.o.cindent=true
vim.o.expandtab=true
vim.o.autochdir=true
vim.o.showcmd=true
vim.o.smartcase=true
vim.o.smartindent=true

vim.o.tags = "./.tags;,.tags"
-- vim.o.runtimepath^=~/.vim/bundle/ag.vim
vim.o.complete = ".,w,b,u,t"
vim.o.backspace = "indent,eol,start"
vim.o.history = 1000
-- vim.o.t_ut = ""
vim.o.foldenable = false
vim.o.encoding = "utf-8"
vim.o.mouse = ""
vim.o.cursorcolumn = true
vim.o.incsearch = true

-- Add header to cc & py files
vim.cmd([[
  " Uncomment the following to have Vim jump to the last position when
  " reopening a file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif

  "****************************************
          "New file title
  "****************************************
  autocmd BufNewFile *.py call SetPythonHeader()
  autocmd BufNewFile *.hpp,*.cpp,*.cc,*.[ch],*.sh,*.java call SetHeader()
  let $author_name = "{set name in ~/.config/nvim/init.lua line 69}"
  let $author_email = "{set mail in ~/.config/nvim/init.lua line 70}"
  let $default_license = "{set license in ~/.config/nvim/init.lua line 71}"
  
  function! SetHeader()
    "*.sh
    if &filetype == 'sh'
      call setline(1,"\#########################################################################")
      call append(line("."), "\#")
      call append(line(".")+1, "\#              Author: ".$author_name)
      call append(line(".")+2, "\#                Mail: ".$author_email)
      call append(line(".")+3, "\#            FileName: ".expand("%:t"))
      call append(line(".")+4, "\#")
      call append(line(".")+5, "\#          Created On: ".strftime("%c"))
      call append(line(".")+6, "\#")
      call append(line(".")+7, "\#########################################################################")
      call append(line(".")+8, "")
      call append(line(".")+9, "\#!/bin/bash")
      call append(line(".")+10, "")
    else
      call setline(1,"/*************************************************************************")
      call append(line("."), "\*")
      call append(line(".")+1, "\*              Author: ".$author_name)
      call append(line(".")+2, "\*                Mail: ".$author_email)
      call append(line(".")+3, "\*            FileName: ".expand("%:t"))
      call append(line(".")+4, "\*")
      call append(line(".")+5, "\*          Created On: ".strftime("%c"))
      call append(line(".")+6, "\*     Licensed under The ".$default_license." License [see LICENSE for details]")
      call append(line(".")+7, "\*")
      call append(line(".")+8, "************************************************************************/")
      call append(line(".")+9, "")
    endif
    "*.cpp
    if &filetype == 'cpp'
      call append(line(".")+10, "#include <iostream>")
      call append(line(".")+11, "")
    endif
    "*.cc
    if &filetype == 'cc'
      call append(line(".")+10, "#include <iostream>")
      call append(line(".")+11, "")
    endif
    "*.c
    if &filetype == 'c'
      call append(line(".")+10, "#include <stdio.h>")
      call append(line(".")+11, "")
    endif
    "Goto end of file
    "autocmd BufEnter * normal G
  endfunc
  
  function! SetPythonHeader()
    call setline(1,"\#!/usr/bin/env python3")
    call append(line("."), "\"\"\"")
    call append(line(".")+1, "              Author: ".$author_name)
    call append(line(".")+2, "                Mail: ".$author_email)
    call append(line(".")+3, "            FileName: ".expand("%:t"))
    call append(line(".")+4, "")
    call append(line(".")+5, "          Created On: ".strftime("%c"))
    call append(line(".")+6, "     Licensed under The ".$default_license." License [see LICENSE for details]")
    call append(line(".")+7, "\"\"\"")
    " autocmd BufEnter * normal G
  endfunc

  "****************************************
          "cscope config
  "****************************************
  function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
      let path = strpart(db, 0, match(db, "/cscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db . " " . path
      set cscopeverbose
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
    endif
  endfunction
  " au BufEnter /* call LoadCscope()
  
  " nmap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  " nmap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  " nmap <Leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  " nmap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  " nmap <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  " nmap <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  " nmap <Leader>I :cs find i <C-R>=expand("<cfile>")<CR><CR>
  map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>
  nnoremap <C-]> g<C-]>

  "****************************************
          "NERDTREE config"
  "****************************************
  "autocmd vimenter * NERDTree
  wincmd w
  autocmd vimenter * wincmd w
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  
  let g:NERDTreeGitStatusUseNerdFonts = 1
  
  "****************************************
          "airline settings
  "****************************************
  let g:airline_theme="simple"
  set laststatus=2
  set t_Co=256
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline#extensions#tabline#buffer_nr_show = 1
  nnoremap <C-TAB> :bn<CR>
  nnoremap <C-S-TAB> :bp<CR>
  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols_branch = '⎇'

  "****************************************
          "vista settings
  "****************************************
  function! NearestMethodOrFunction() abort
    return get(b:, 'vista_nearest_method_or_function', '')
  endfunction
  set statusline+=%{NearestMethodOrFunction()}
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
  
  " How each level is indented and what to prepend.
  " This could make the display more compact or more spacious.
  " e.g., more compact: ["▸ ", ""]
  " Note: this option only works for the kind renderer, not the tree renderer.
  let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
  " Executive used when opening vista sidebar without specifying it.
  " See all the avaliable executives via `:echo g:vista#executives`.
  let g:vista_default_executive = 'ctags'
  " Set the executive for some filetypes explicitly. Use the explicit executive
  " instead of the default one for these filetypes when using `:Vista` without
  " specifying the executive.
  let g:vista_executive_for = {
    \ 'cpp': 'ctags',
    \ 'php': 'vim_lsp',
    \ }
  
  " Declare the command including the executable and options used to generate ctags output
  " for some certain filetypes.The file path will be appened to your custom command.
  " For example:
  let g:vista_ctags_cmd = {
        \ 'haskell': 'hasktags -x -o - -c',
        \ }
  " To enable fzf's preview window set g:vista_fzf_preview.
  " The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
  " For example:
  let g:vista_fzf_preview = ['right:50%']
  " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
  let g:vista#renderer#enable_icon = 1
  " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
  let g:vista#renderer#icons = {
  \   "function": "\uf794",
  \   "variable": "\uf71b",
  \  }
  nnoremap <silent> <F8> :Vista!!<CR>

  "****************************************
          "LeaderF settings:
  "****************************************
  let g:Lf_ShortcutF = '<C-P>'
  let g:Lf_WindowPosition = 'popup'
  let g:Lf_PreviewInPopup = 1
  let g:Lf_ReverseOrder = 1
  let g:Lf_WorkingDirectoryMode = 'AF'
  let g:Lf_RootMarkers = ['.git', '.svn', '.hg', '.project', '.root']
  let g:Lf_WildIgnore = {
      \ 'dir': ['.git', '.ccls-cache', '__pycache__'],
      \ }

  "****************************************
          "ag settings:
  "****************************************
  let g:ag_working_path_mode="r"
  nmap <F2> :Ag! --noaffinity<space>

  "****************************************
          "markdown preview:
  "****************************************
  nmap <F9>o :MarkdownPreview<CR>
  nmap <F9>q :MarkdownPreviewStop<CR>
  
  function! SetupPython()
    setlocal softtabstop=4
    setlocal tabstop=4
    setlocal shiftwidth=4
  endfunction
  command! -bar SetupPython call SetupPython()

  "****************************************
              "vimwiki"
  "****************************************
  let g:vimwiki_list = [{'path': '~/Documents/VimWiki/', 'syntax': 'markdown', 'ext': '.md'}]
  au BufRead, BufNewFile *.wiki set filetype=vimwiki
  function! ToggleCalendar()
    execute ":Calendar"
    if exists("g:calendar_open")
      if g:calendar_open == 1
        execute "q"
        unlet g:calendar_open
      else
        g:calendar_open = 1
      end
    else
      let g:calendar_open = 1
    end
  endfunction
  :autocmd FileType vimwiki map <Leader>c :call ToggleCalendar()<CR>
  :nnoremap <F7> "=strftime("%Y-%m-%d")<CR>P
  :inoremap <F7>t <C-R>=strftime("%Y-%m-%d")<CR>
  ":autocmd FileType vimwiki map c :Calendar<CR>

  "****************************************
              "vim-mark"
  "****************************************
  " let g:mwDefaultHighlightingPalette = 'extended'

  "****************************************
              "coc-ultisnips"
  "****************************************
  let $snipath = $HOME."/.vim/ultisnips"
  " let g:snippets.userSnippetsDirectory = [$snipath]
  imap <c-l> <Plug>(coc-snippets-expand)
  xmap <leader>x  <Plug>(coc-convert-snippet)

  "****************************************
              "jedi-vim"
  "****************************************
  let g:jedi#completions_enabled = 0

  "****************************************
              "python-mode"
  "****************************************
  let g:pymode_rope = 0
  let g:pymode_options_max_line_length = 120
  let g:pymode_lint_ignore = ["E501", "W0611", "W0612", "E231", "E116", "E402", "C901"]

  "****************************************
              "coc.nvim"
  "****************************************
  let g:coc_node_path='/usr/local/bin/node'

  "****************************************
                 "fzf"
  "****************************************
  set rtp+=/usr/local/opt/fzf
  
  "****************************************
             "gutentags"
  "****************************************
  " let g:gutentags_trace = 1
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  let g:gutentags_ctags_tagfile = 'tags'
  let s:vim_tags = expand('~/.cache/ctags')
  let g:gutentags_cache_dir = s:vim_tags
  let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git', 'BCLOUD']
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
  let g:gutentags_ctags_exclude = [
  \  '*.git', '*.svn', '*.hg', '*.ccls-cache',
  \  'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
  \  '*-lock.json',  '*.lock',
  \  '*.min.*',
  \  '*.bak',
  \  '*.zip',
  \  '*.pyc',
  \  '*.class',
  \  '*.sln',
  \  '*.csproj', '*.csproj.user',
  \  '*.tmp',
  \  '*.cache',
  \  '*.vscode',
  \  '*.pdb',
  \  '*.exe', '*.dll', '*.bin',
  \  '*.mp3', '*.ogg', '*.flac',
  \  '*.swp', '*.swo',
  \  '.DS_Store', '*.plist',
  \  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
  \  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
  \  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
  \  '*.yml', '*.gcc_cmd', 'output',
  \]

  if !isdirectory(s:vim_tags)
     silent! call mkdir(s:vim_tags, 'p')
  endif

  if (has("termguicolors"))
    set termguicolors
  endif

  "****************************************
        "vim-latex-live-preview"
  "****************************************
  " let g:livepreview_previewer = 'evince'
  let g:livepreview_previewer = 'zathura'
  let g:livepreview_engine = 'xelatex'
  :autocmd FileType vimwiki,tex setlocal updatetime=200
  nmap <Leader>L :set syntax=tex<CR>
  " :LLPStartPreview

  "****************************************
              "undotree"
  "****************************************
  nnoremap <F5> :UndotreeToggle<CR>
]])

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },

    -- colorschemes
    { 'tomasr/molokai' },
    { 'ku1ik/vim-monokai' },
    { 'joshdick/onedark.vim' },
    { 'kyoz/purify', },
    { 'rakr/vim-one' },
    { 'folke/tokyonight.nvim' },
    { 'NLKNguyen/papercolor-theme' },
    { 'catppuccin/nvim' },

    -- vim scripts plugins
    { 'xuhdev/vim-latex-live-preview', },
    { 'andrejlevkovitch/vim-lua-format', },
    { 'kshenoy/vim-signature', },
    { 'HiPhish/rainbow-delimiters.nvim' },
    { 'ryanoasis/vim-devicons' },
    { 'tpope/vim-commentary' },
    -- { 'easymotion/vim-easymotion' },
    { 'danro/rename.vim' },
    { 'godlygeek/tabular' },
    { 'rking/ag.vim' },
    { 'google/vim-codefmt', dependencies = {'google/vim-maktaba'} },
    { 'vim-airline/vim-airline', },
    { 'vim-airline/vim-airline-themes' },

    {
      'scrooloose/nerdtree', dependencies = { 'Xuyuanp/nerdtree-git-plugin', 'tiagofumo/vim-nerdtree-syntax-highlight' }
    },

    { 'Xuyuanp/nerdtree-git-plugin', },
    { 'tiagofumo/vim-nerdtree-syntax-highlight', },
    { 'liuchengxu/vista.vim', },
    { 'Yggdroot/LeaderF', build = ':LeaderfInstallCExtension', },
    { 'inkarkat/vim-mark', dependencies = { 'inkarkat/vim-ingo-library' }, },
    { 'vimwiki/vimwiki', },
    { 'ludovicchabant/vim-gutentags', },
    { 'python-mode/python-mode', branch='develop', },
    { 'mbbill/undotree', },

    -- snacks.nvim
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        styles= {},
        bigfile = { enabled = true },
        notifier = { enabled = true, timeout = 2500, },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true, },
        lazygit = { 
          -- automatically configure lazygit to use the current colorscheme
          -- and integrate edit with the current neovim instance
          configure = true,
          -- extra configuration for lazygit that will be merged with the default
          -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
          -- you need to double quote it: `"\"test\""`
          config = {
            os = { editPreset = "nvim-remote" },
            gui = {
              -- set to an empty string "" to disable icons
              nerdFontsVersion = "3",
            },
          },
          theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
          -- Theme for lazygit
          theme = {
            [241]                      = { fg = "Special" },
            activeBorderColor          = { fg = "MatchParen", bold = true },
            cherryPickedCommitBgColor  = { fg = "Identifier" },
            cherryPickedCommitFgColor  = { fg = "Function" },
            defaultFgColor             = { fg = "Normal" },
            inactiveBorderColor        = { fg = "FloatBorder" },
            optionsTextColor           = { fg = "Function" },
            searchingActiveBorderColor = { fg = "MatchParen", bold = true },
            selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
            unstagedChangesColor       = { fg = "DiagnosticError" },
          },
          win = {
            style = "lazygit",
          },
        },
        git = { enable = true },
        dashboard = {
          sections = {
            { section = "header" },
            {
              pane = 2,
              section = "terminal",
              cmd = "colorscript -e square",
              height = 5,
              padding = 1,
            },
            { section = "keys", gap = 1, padding = 1 },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = "hub status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
          },
        }
      },
      keys = {
        { "<leader>hh",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>hb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
        { "<leader>hf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
        { "<leader>hg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>hl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
        { "<leader>hd", function() Snacks.dashboard() end, desc = "dashboard" },
      },
    },

    -- fzf-lua
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
      end
    },

    -- coc.nvim
    {
      'neoclide/coc.nvim',
      branch = 'release'
    },

    -- nvim-treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":tsupdate",
      config= function()
        require'nvim-treesitter.configs'.setup({
          -- A list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = {"cpp", "cpp", "cmake", "cuda",
                              "lua", "python",
                              "markdown", "vim", "yaml", "json", "hjson", "proto", "xml"},

          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = true,

          -- List of parsers to ignore installing (or "all")
          ignore_install = { "javascript" },

          ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
          -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

          highlight = {
            enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            disable = { "c", "rust" },
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
        })
      end
    },

    {
      "wookayin/semshi",
       build = ":UpdateRemotePlugins",
       version = "*",  -- Recommended to use the latest release
       init = function()  -- example, skip if you're OK with the default config
         vim.g['semshi#error_sign'] = false
       end,
       config = function()
         -- any config or setup that would need to be done after plugin loading
       end,
    },

    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },

    -- ******** cscope_maps **********
    {
      "dhananjaylatkar/cscope_maps.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
        "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
        "echasnovski/mini.pick", -- optional [for picker="mini-pick"]
      },
      config= function()
        local work_path = os.getenv("PWD")
        if (work_path == os.getenv("HOME")) then
          return
        end
        local f = io.popen('find "'..work_path..'" -name cscope.out')

        local cscope_file = nil
        for file in f:lines() do                         --Loop through all files
          cscope_file = file
        end

        require("cscope_maps").setup{
          disable_maps = true,
          skip_input_prompt = true,
          vim.api.nvim_set_keymap(
            "n",
            "<leader>s",
            [[<cmd>lua require('cscope_maps').cscope_prompt('s', vim.fn.expand("<cword>"))<cr>]],
            { noremap = true, silent = true }
          ),
          cscope = {
            -- location of cscope db file
            db_file = cscope_file,
            -- cscope executable
            exec = "cscope", -- "cscope" or "gtags-cscope"
            -- choose your fav picker
            picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
            -- "true" does not open picker for single result, just JUMP
            skip_picker_for_single_result = false, -- "false" or "true"
            -- these args are directly passed to "cscope -f <db_file> <args>"
            db_build_cmd_args = { "-bqkv" },
            -- statusline indicator, default is cscope executable
            statusline_indicator = nil,
          },
        }
      end,
      opts = {
        -- USE EMPTY FOR DEFAULT OPTIONS
        -- DEFAULTS ARE LISTED BELOW
      },
    },

    {
      'echasnovski/mini.files',
      config = function()
        require("mini.files").setup({
          windows= {
            preview = true,
          },
        })
      end
    },

    {
      'skywind3000/vim-quickui',
      config = function()
        vim.cmd([[
          "****************************************
                      "quickui"
          "****************************************
          let g:asynctasks_term_pos = 'tab'
          
          let g:quickui_color_scheme = 'papercol dark'
          let g:asyncrun_open = 6
          
          call quickui#menu#reset()
          call quickui#menu#install("&File", [
          			\ [ "Leaderf &File", 'Leaderf file', 'Open file with leaderf'],
          			\ [ "Leaderf &Recently", 'Leaderf mru --regexMode', 'Open recently accessed files'],
          			\ [ "Leaderf &Buffer", 'Leaderf buffer', 'List current buffers in leaderf'],
          			\ ])
          
          call quickui#menu#install("&Build", [
          			\ ["Project &Build", 'AsyncTask build'],
          			\ ["Project &Run", 'AsyncTask run'],
          			\ ])
          
          call quickui#menu#install("&Git", [
          			\ ['&View Diff', 'Gdiff'],
          			\ ['&Show Log', 'Glog'],
          			\ ['File &Add', 'Gw'],
          			\ ])
          
          call quickui#menu#install('&Tools', [
          			\ ['List &Buffer', 'call quickui#tools#list_buffer("e")', ],
          			\ ['List &Function', 'call quickui#tools#list_function()', ],
          			\ ['Display &Messages', 'call quickui#tools#display_messages()', ],
          			\ ])
          
          call quickui#menu#install('&Plugin', [
          			\ ["&FileLists\t<space>tn", 'lua MiniFiles.open()', 'toggle nerdtree'],
          			\ ['&Tagbar', 'Vista!!', 'toggle Vista'],
          			\ ["-"],
          			\ ["&Display Calendar", "Calendar", "display a calender"],
          			\ ["-"],
          			\ ["Plugin &Status", "PlugStatus", "Check plugins status"],
          			\ ["Plugin &Update", "PlugUpdate", "Update plugin"],
          			\ ])
          
          call quickui#menu#install('Help (&?)', [
          			\ ["&Index", 'tab help index', ''],
          			\ ['Ti&ps', 'tab help tips', ''],
          			\ ['--',''],
          			\ ["&Tutorial", 'tab help tutor', ''],
          			\ ['&Quick Reference', 'tab help quickref', ''],
          			\ ['&Summary', 'tab help summary', ''],
          			\ ['--',''],
          			\ ['&Vim Script', 'tab help eval', ''],
          			\ ['&Function List', 'tab help function-list', ''],
          			\ ['&Dash Help', 'call asclib#utils#dash_ft(&ft, expand("<cword>"))'],
          			\ ], 10000)
          " let g:quickui_show_tip = 1
          
          "----------------------------------------------------------------------
          " context menu
          "----------------------------------------------------------------------
          let g:context_menu_k = [
          			\ ["&CopyHistory\t:reg", 'reg', 'Display copy history'],
          			\ ["&FileLists", 'lua MiniFiles.open()', 'toggle nerdtree'],
          			\ ['&Tagbar', 'Vista!!', 'toggle Vista'],
          			\ ['List &Buffer', 'call quickui#tools#list_buffer("e")', ],
          			\ ["&Search in Project", 'Ag! --noaffinity "<cword>"'],
          			\ [ "--", ],
          			\ [ "&Align symbol\t\:Tabularize \/symbol", ':Tabularize'],
          			\ [ "--", ],
          			\ [ "Git Add\t", 'Git add .', 'Git add .'],
          			\ [ "Git Diff\t", 'Git diff', 'Git diff'],
          			\ [ "Git Diff --cached\t", 'Git diff --cached', 'Git diff --cached'],
          			\ [ "Git Commit\t", 'Git commit', 'Git commit'],
          			\ [ "Git Commit --amend\t", 'Git commit --amend', 'Git commit --amend'],
          			\ [ "Git Push\t", 'Git push', 'Git push'],
          			\ [ "--", ],
          			\ [ "Find &Definition\t\\g", 'cs find g "<cword>"', 'Cscope search g'],
          			\ [ "Find Symbol\t\\s", 'cs find s "<cword>"', 'Cscope search s'],
          			\ [ "Find Called by this function\t\\d", 'cs find d "<cword>"', 'Cscope search d'],
          			\ [ "Find Calling this function\t\\c", 'cs find c "<cword>"', 'Cscope search c'],
          			\ [ "Find Text string\t\\t", 'cs find t "<cword>"', 'Cscope search c'],
          			\ [ "Find Files including this file\t\\i", 'cs find i "<cword>"', 'Cscope search c'],
          			\ [ "--", ],
          			\ ['Dash &Help', 'call asclib#utils#dash_ft(&ft, expand("<cword>"))'],
          			\ ['Cpp&man', 'exec "Cppman " . expand("<cword>")', '', 'c,cpp'],
          			\ ['P&ython Doc', 'call quickui#tools#python_help("")', 'python'],
          			\ ]
          
          "----------------------------------------------------------------------
          " hotkey
          "----------------------------------------------------------------------
          nnoremap <silent><leader><space> :call quickui#menu#open()<cr>
          nnoremap <silent>F :call quickui#tools#clever_context('k', g:context_menu_k, {})<cr>
          if has('gui_running') || has('nvim')
          	noremap <c-f10> :call MenuHelp_TaskList()<cr>
          endif
          
          set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
          set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor
        ]])
      end
    },
    
    {
      'nvim-telescope/telescope.nvim',
      config = function()
        vim.cmd([[
          nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
          nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
          nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
          nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
          nnoremap <leader>fr <cmd>lua require('telescope.builtin').resume()<cr>
          nnoremap <leader>ft <cmd>lua require('telescope-tabs').list_tabs()<cr>
        ]])

        local actions = require("telescope.actions")
        require('telescope').setup{
          defaults = {
            layout_strategy = 'vertical',
            layout_config = { width = 120.0},
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
              i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
              },
            }
          },
          pickers = {},
          extensions = {},
        }
      end
    },

    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
      end
    },

    {
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end
    },

    {
      'ggandor/leap.nvim',
      config = function()
        require('leap').create_default_mappings()
      end
    },

  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

