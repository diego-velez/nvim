-- University run C lab with :make
vim.opt_local.makeprg =
  'gcc -Wall -Werror -I./include ./src/main.c ./src/functions.c -o ./test/main && echo "$*" \\| ./test/main'
