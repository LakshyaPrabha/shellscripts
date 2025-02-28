
#!/bin/bash


if ! command -v pyenv &> /dev/null; then
    echo "📌 Pyenv not found! Installing Pyenv..."
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    exec $SHELL
else
    echo " Pyenv is already installed!"
fi


if [ ! -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]; then
    echo "📌 Pyenv-Virtualenv not found! Installing Pyenv-Virtualenv..."
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    exec $SHELL
else
    echo " Pyenv-Virtualenv is already installed!"
fi


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


if ! pyenv versions | grep -q "3.8.7"; then
    echo " Python 3.8.7 not found! Installing..."
    pyenv install 3.8.7
else
    echo "Python 3.8.7 is already installed!"
fi


if ! pyenv virtualenvs | grep -q "myvirtualEn"; then
    echo " Virtual environment 'myvirtualEn' not found! Creating..."
    pyenv virtualenv 3.8.7 myvirtualEn
else
    echo " Virtual environment 'myvirtualEn' already exists!"
fi

echo " Activating virtual environment 'myvirtualEn'..."
pyenv activate myvirtualEn

echo " Python Version inside Virtual Environment:"
python --version
echo " Virtual environment 'myvirtualEn' is now active!"
 

pip install requests
if ! pip install requests; then 
    echo " Does not install requests"
else
    echo " Requests module installed successfully"
fi

#  API Endpoint
URL="https://www.flipkart.com/search?q=monitor&sid=6bo%2Cg0i%2C9no&as=on&as-show=on&otracker=AS_QueryStore_OrganicAutoSuggest_1_4_na_na_na&otracker1=AS_QueryStore_OrganicAutoSuggest_1_4_na_na_na&as-pos=1&as-type=RECENT&suggestionId=monitor%7CMonitors&requestId=6e496f8c-2acb-412c-a374-2cd146e28db0&as-searchtext=moni"

#  GET Request and Capture Response & Status Code
STATUS_CODE=$(curl -s -o response.html -w "%{http_code}" "$URL")

# Read API Response using cat
echo " API HTML Response:"
cat response.html |

#  Print HTTP Status Code
cat <<EOF
HTTP Status Code: $STATUS_CODE
EOF
