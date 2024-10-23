alias dotfiles="/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias venv="source .venv/bin/activate"
alias pm="python manage.py"
alias code=codium
alias torwal="~/dev/TorWAL/wal/.venv/bin/python ~/dev/TorWAL/wal/wal.py"
alias db="~/dev/deskbooker/.venv/bin/python ~/dev/deskbooker/deskbooker/deskbooker.py"
alias vær="finger 0475@graph.no | grep -v NRK"
# Run black, isort, flake8 on all changed files
alias pretty="git ls-files '*.py' -m | xargs -I % sh -c 'black %; isort %; flake8 %'"

# alias gl="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"

# Django
alias runserver='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py runserver 0.0.0.0:8000'
alias makemigrations='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py makemigrations'
alias showmigrations='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py showmigrations'
alias migrate='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py migrate'
alias shell='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ~/dev/tienda/.venv/bin/python manage.py shell_plus'
alias update-db='DJANGO_SETTINGS_MODULE="tienda.settings_local" POSTGRES_DB="tienda" TENANT="no" ./bin/update-db'

alias runserver:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ~/dev/tienda/.venv/bin/python manage.py runserver 0.0.0.0:8000'
alias makemigrations:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ~/dev/tienda/.venv/bin/python manage.py makemigrations'
alias showmigrations:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ~/dev/tienda/.venv/bin/python manage.py showmigrations'
alias migrate:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ~/dev/tienda/.venv/bin/python manage.py migrate'
alias shell:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ~/dev/tienda/.venv/bin/python manage.py shell_plus'
alias update-db:se='DJANGO_SETTINGS_MODULE="tienda.settings_local_se" POSTGRES_DB="tienda_se" TENANT="se" ./bin/update-db'


alias generate="~/dev/tienda/.venv/bin/python manage.py generate_api_schemas ; npm run openapi:generate"

# Tienda web
alias start:no='NEXT_PUBLIC_TENANT="no" TIENDA_INTERNAL_HOSTNAME="http://oda.localhost" TIENDA_DOMAIN="oda.localhost" TIENDA_HOSTNAME="http://oda.localhost" TIENDA_WEB_HOSTNAME="http://oda.localhost" X_CLIENT_TOKEN="OeD5WJnGuY3JxAF5rs61cjdjuvUfKplN7izeeU5MoH3HsNwol4" npm run start:no'
alias start:se='NEXT_PUBLIC_TENANT="se" TIENDA_INTERNAL_HOSTNAME="http://mathem.localhost" TIENDA_DOMAIN="mathem.localhost" TIENDA_HOSTNAME="http://mathem.localhost" TIENDA_WEB_HOSTNAME="http://mathem.localhost" X_CLIENT_TOKEN="IJxqnIXYOzxP7ZfAxnKUTLsSwEvn1W6iDYHRg2WBuAOW7zw7qI" npm run start:se'
# Remove zsh aliases
unalias ga
unalias gr
unalias gap
unalias gl

