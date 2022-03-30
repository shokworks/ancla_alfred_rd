# Python version
FROM python:3.7

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev python3-dev cargo postgresql postgresql-client gettext curl libmariadb-dev-compat libmariadb-dev

# Copy files to working directory
RUN mkdir /code /code/polaris /code/data
COPY ./anchor ./setup.py ./setup.cfg /code/
#COPY ./anchor ./setup.py ./setup.cfg ./README.rst ./MANIFEST.in /code/
COPY ./polaris /code/polaris/

# Set fake environment variables so manage.py commands can run.
# django-environ's env() function uses variables defined in the
# environment over matching variables in the .env file, so these
# variables will be overidden in production, and won't be defined
# if a .env file already exists.
#RUN if [ ! -f /code/.env ]; then echo '\
#SIGNING_SEED=SB4XM7E6ZP4NIQF3UNVMX5O5NH7RGHFHDLIS4Z5U4OMNQ7T4EDNKPVNU\n\
#HOST_URL=https://fake.com\n\
#SERVER_JWT_KEY=notsosecretkey\n\
#DJANGO_SECRET_KEY=notsosecretkey\n\
#ENABLE_SEP_0023=True\n\
#ACTIVE_SEPS=\
#' >> /code/.env; fi

RUN if [ ! -f /code/.env ]; then echo '\
# DJANGO_SETTINGS_MODULE="polaris.settings"\n\
DJANGO_DEBUG=True\n\
DJANGO_SECRET_KEY="django-insecure--ss1uc!vxx2cs964rp@*yr#+lp-e_t9l=40z-77e-#0xee2)u2"\n\
DJANGO_ALLOWED_HOSTS=localhost,0.0.0.0,127.0.0.1\n\
ACTIVE_SEPS=sep-1,sep-10,sep-12,sep-24,sep-31\n\
SIGNING_SEED="SB2OBWWKH2SOI5R6JCRVVWZRLXPBEKASDJBAHPPTT7ZOBW6RGS6X3KVX"\n\
SERVER_JWT_KEY="django-insecure--ss1uc!vxx2cs964rp@*yr#+lp-e_t9l=40z-77e-#0xee2)u2"\n\
STELLAR_NETWORK_PASSPHRASE="Test SDF Network ; September 2015"\n\
HORIZON_URI="https://horizon-testnet.stellar.org/"\n\
HOST_URL="http://localhost:8000"\n\
LOCAL_MODE=True\n\
SEP10_HOME_DOMAINS=localhost:8000\n\
ENABLE_SEP_0023=1\n\
SEP10_HOME_DOMAINS=testanchor.stellar.org,horizon-testnet.stellar.org,demo-wallet.stellar.org,localhost,localhost:8000,demo-wallet-server.stellar.org\n\
SEP10_CLIENT_ATTRIBUTION_REQUIRED=1\n\
SEP10_CLIENT_ATTRIBUTION_ALLOWLIST=testanchor.stellar.org,horizon-testnet.stellar.org,demo-wallet.stellar.org,localhost,localhost:8000,demo-wallet-server.stellar.org\n\
\
' >> /code/.env; fi


# Install dependencies
WORKDIR /code
RUN pip install mysqlclient pipenv; pipenv install --dev --system

# collect static assets
RUN python manage.py collectstatic --no-input --ignore=*.scss

# Overridden by heroku.yml's run phrase in deployment
CMD python manage.py migrate; python manage.py runserver --nostatic 0.0.0.0:8000
