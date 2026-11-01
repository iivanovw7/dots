function gemini --description 'Run gemini-cli with Node 22'
    nvm use 22 >/dev/null 2>&1; and command gemini $argv
end
