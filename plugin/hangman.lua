vim.cmd("command! -bang -nargs=0 Hangman :lua require('hangman').play_hangman()")
