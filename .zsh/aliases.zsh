alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias venv="source .venv/bin/activate"
alias pm="python manage.py"
alias code=codium
alias torwal="~/dev/TorWAL/wal/.venv/bin/python ~/dev/TorWAL/wal/wal.py"
alias db="~/dev/deskbooker/.venv/bin/python ~/dev/deskbooker/deskbooker/deskbooker.py"
alias vær="finger 0475@graph.no | grep -v NRK"
# Run black, isort, flake8 on all changed files
alias pretty="git ls-files '*.py' -m | xargs -I % sh -c 'black %; isort %; flake8 %'"

alias gl="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"
alias klipy="~/dev/klipy/.venv/bin/python -m klipy"

# Django
alias runserver="~/dev/tienda/.venv/bin/python manage.py runserver 0.0.0.0:8000"
alias makemigrations="~/dev/tienda/.venv/bin/python manage.py makemigrations"
alias migrate="~/dev/tienda/.venv/bin/python manage.py migrate"
alias shell="~/dev/tienda/.venv/bin/python manage.py shell_plus"
alias generate="~/dev/tienda/.venv/bin/python manage.py generate_api_schemas | npm run openapi:generate"