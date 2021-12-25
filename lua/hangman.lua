local hangman = {}
local letter

local hangman_win

local hangman_buf
local fails = 1


hangman.word = ""

hangman.lines = {}

local alphabet = vim.split("abcdefghijklmnopqrstuvwxyz", "")

local hangman_ascii = {
  {
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[                     ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ _                   ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ____________________]],
    [[| .__________________]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /              ]],
    [[| |/ /               ]],
    [[| | /                ]],
    [[| |/                 ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /                ]],
    [[| |/                 ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /        ||      ]],
    [[| |/         ||      ]],
    [[| |          ||      ]],
    [[| |          ()      ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /        ||.-''. ]],
    [[| |/         |/  _  \]],
    [[| |          ||  `/,|]],
    [[| |          (\\`_.' ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /        ||.-''. ]],
    [[| |/         |/  _  \]],
    [[| |          ||  `/,|]],
    [[| |          (\\`_.' ]],
    [[| |         .-`--'.  ]],
    [[| |         Y . . Y  ]],
    [[| |          |   |   ]],
    [[| |          | . |   ]],
    [[| |          |_ _|   ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[| |                  ]],
    [[""""""""""|_         ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /        ||.-''. ]],
    [[| |/         |/  _  \]],
    [[| |          ||  `/,|]],
    [[| |          (\\`_.' ]],
    [[| |         .-`--'.  ]],
    [[| |         Y . . Y  ]],
    [[| |          |   |   ]],
    [[| |          | . |   ]],
    [[| |          |   |   ]],
    [[| |          ||'||   ]],
    [[| |          || ||   ]],
    [[| |          || ||   ]],
    [[| |          || ||   ]],
    [[| |         / | | \  ]],
    [[""""""""""|_`-' `-'  ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
  {
    [[ ___________.._______]],
    [[| .__________))______]],
    [[| | / /      ||      ]],
    [[| |/ /       ||      ]],
    [[| | /        ||.-''. ]],
    [[| |/         |/  _  \]],
    [[| |          ||  `/,|]],
    [[| |          (\\`_.' ]],
    [[| |         .-`--'.  ]],
    [[| |        /Y . . Y\ ]],
    [[| |       // |   | \\]],
    [[| |      //  | . |  \]],
    [[| |     ')   |   |   ]],
    [[| |          ||'||   ]],
    [[| |          || ||   ]],
    [[| |          || ||   ]],
    [[| |          || ||   ]],
    [[| |         / | | \  ]],
    [[""""""""""|_`-' `-'  ]],
    [[|"|"""""""\ \        ]],
    [[| |        \ \       ]],
    [[: :         \ \      ]],
    [[. .          `'      ]],
  },
}

local letters_used = {
  a = false,
  b = false,
  c = false,
  d = false,
  e = false,
  f = false,
  g = false,
  h = false,
  i = false,
  j = false,
  k = false,
  l = false,
  m = false,
  n = false,
  o = false,
  p = false,
  q = false,
  r = false,
  s = false,
  t = false,
  u = false,
  v = false,
  w = false,
  x = false,
  y = false,
  z = false,
}

local guessed_word = {}
local function guessed()
  if not vim.tbl_contains(guessed_word,"_") then
    return true
  else
    return false
  end
end

local function set_lines()
  hangman.lines = {}
  for _, line in ipairs(hangman_ascii[fails]) do
    table.insert(hangman.lines, line)
  end
end

local function display()
  vim.api.nvim_buf_set_lines(hangman_buf,0,-1, true, {})
  vim.api.nvim_buf_set_lines(hangman_buf,0,-1, true, hangman.lines)
  vim.api.nvim_buf_set_option(hangman_buf, "bufhidden", "wipe")
  local width = vim.api.nvim_win_get_width(0)

  hangman_win = vim.api.nvim_open_win(
    hangman_buf,
    true,
    {
      relative = "win",
      win = 0,
      width = math.floor(width * 0.9),
      height = 28,
      col = 1,
      row = 1,
      border = "shadow",
      style = "minimal",
    })

end

local function redraw()
  vim.api.nvim_buf_set_lines(hangman_buf,0,-1, true, {})
  vim.api.nvim_buf_set_lines(hangman_buf,0,-1, true, hangman.lines)
end

local function reset()
  if hangman_win~=nil then
    vim.api.nvim_win_close(hangman_win, true)
  end
  letters_used = {
  a = false,
  b = false,
  c = false,
  d = false,
  e = false,
  f = false,
  g = false,
  h = false,
  i = false,
  j = false,
  k = false,
  l = false,
  m = false,
  n = false,
  o = false,
  p = false,
  q = false,
  r = false,
  s = false,
  t = false,
  u = false,
  v = false,
  w = false,
  x = false,
  y = false,
  z = false,
}
  guessed_word = {}
  hangman_buf = vim.api.nvim_create_buf(false, true)
  fails = 1
  hangman.word = nil
end

function hangman.play_hangman()
  reset()
  hangman.word = vim.api.nvim_exec("!curl -s https://random-word-api.herokuapp.com/word",true)
  hangman.word = hangman.word:sub(54,-1):gsub('%[%"(.+)%"%]',"%1")
  hangman.word = vim.trim(hangman.word)
  for _ = 1, #hangman.word, 1 do
    table.insert(guessed_word, "_")
  end
  set_lines()
  table.insert(hangman.lines, table.concat(guessed_word, " "))

  display()
  for _, char in ipairs(alphabet) do
    vim.api.nvim_buf_set_keymap(hangman_buf, "n", char, "<cmd>lua require'hangman'.input("..'"'..char..'"'..")<CR>", {noremap = true,silent = true})
  end
  redraw()
end
local function play()
  local used_letters = {}
  if not letters_used[letter] then
    hangman.lines = {}
    letters_used[letter]=true
    local used = false
    for i = 1, #hangman.word, 1 do
      if letter == string.sub(hangman.word,i,i) then
        guessed_word[i]= letter
        used = true
      end
    end
    if not used then
      fails = fails+1
      set_lines()
      table.insert(hangman.lines, "That letter isn't part of the word.")
    end
    set_lines()
    table.insert(hangman.lines,table.concat(guessed_word, " "))
    for _, alph_letter in pairs(alphabet) do
      if letters_used[alph_letter] then
        table.insert(used_letters,alph_letter)
      end
    end
    table.insert(hangman.lines, "Used letters:")
    table.insert(hangman.lines, table.concat(used_letters))
    used_letters = {}
    if not guessed() then
      if fails>=#hangman_ascii then
        hangman.lines = hangman_ascii[fails]
        table.insert(hangman.lines, "You died.")
        table.insert(hangman.lines, "The word was "..hangman.word)
        redraw()
        return
      end
    else
      hangman.lines = hangman_ascii[fails]
      table.insert(hangman.lines, table.concat(guessed_word))
      table.insert(hangman.lines, "Congratulations you got the word")
      redraw()
    end
    redraw()
  else
    hangman.lines = {}
    set_lines()
    table.insert(hangman.lines, "You already used that letter")
      table.insert(hangman.lines, table.concat(guessed_word," "))
    for _, alph_letter in pairs(alphabet) do
      if letters_used[alph_letter] then
        table.insert(used_letters,alph_letter)
      end
    end
    table.insert(hangman.lines, "Used letters:")
    table.insert(hangman.lines, table.concat(used_letters))
    used_letters = {}
    redraw()
  end
end

function hangman.input(input_letter)
  letter = input_letter
  play()
end
return hangman
