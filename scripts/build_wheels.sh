#! /usr/bin/env bash

DIST_DIR=$1
shift

# ==============================================================================

echo 'Setting up default repository'
cat << EOF > ~/.pypirc
[distutils]
index-servers=
    pypi

[pypi]
repository: $TWINE_REPOSITORY_URL
username: $TWINE_USERNAME
password: $TWINE_PASSWORD
EOF

echo 'Building source distribution'
python3 setup.py sdist

echo 'Building binary distributions'
python3 -m cibuildwheel --output-dir dist/

# ==============================================================================
