alias dotfiles="/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias venv="source .venv/bin/activate"
alias pm="python manage.py"
alias torwal="~/dev/TorWAL/wal/.venv/bin/python ~/dev/TorWAL/wal/wal.py"
alias db="~/dev/deskbooker/.venv/bin/python ~/dev/deskbooker/deskbooker/deskbooker.py"
alias vær="finger 0475@graph.no | grep -v NRK"
# Run black, isort, flake8 on all changed files
alias pretty="git ls-files '*.py' -m | xargs -I % sh -c 'black %; isort %; flake8 %'"

# alias gl="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"

# Django
alias runserver='~/dev/tienda/.venv/bin/python manage.py runserver 0.0.0.0:8000'
alias makemigrations='POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py makemigrations'
alias showmigrations='POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py showmigrations'
alias migrate='POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py migrate'
alias shell='POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py shell_plus'
alias update-db='POSTGRES_DB="tienda" TENANT="no" ./bin/update-db'
alias manage='POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py'

alias generate="make schemas"


# Remove zsh aliases
unalias ga
unalias gr
unalias gap
unalias gl
unalias gsd
