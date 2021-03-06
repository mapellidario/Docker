#!/usr/bin/env bash

# Run pylint and pep8 (pycodestyle) over the entire DBS code base

# Setup the environment
source ./env_unittest.sh
pushd dbs_test/DBS

timeout -s 9 5m git checkout master || timeout -s 9 5m git checkout master
timeout -s 9 5m git pull origin || timeout -s 9 5m git pull origin

# Run pylint on the whole code base
# Remove C0103 for now since all dbs modules start with dbs instead of Dbs. Maybe a new standards file later.
export PYTHONPATH=`pwd`/Server/Python/src:`pwd`/Client/src/python/dbs/api:${PYTHONPATH}
pylint --rcfile /home/dmwm/dbs_test/.pylintrc -d C0103 -f parseable Client/src/python/dbs
pylint --rcfile /home/dmwm/dbs_test/.pylintrc -d C0103 -f parseable Server/Python/src/dbs
pylint --rcfile /home/dmwm/dbs_test/.pylintrc -d C0103 -f parseable PycurlClient/src/python/RestClient

# Fix pep8 which has the wrong python executable
echo "#! /usr/bin/env python" > ../pep8
cat `which pep8` >> ../pep8
chmod +x ../pep8

# Run PEP-8 checker but not in pylint format
../pep8 --format=default --exclude=.svn,CVS,.bzr,.hg,.git,__pycache__,.tox. Client/src/python/dbs/ Server/Python/src/dbs/ PycurlClient/src/python/RestClient/
