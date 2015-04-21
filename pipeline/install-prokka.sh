#!/bin/bash -ex

mkdir -p ${HOME}/src/prokka
cd ${HOME}/src/prokka
curl -OL https://github.com/Victorian-Bioinformatics-Consortium/prokka/archive/v1.11.tar.gz
tar xzf v*.tar.gz
ln -s prokka-* prokka
echo "export PATH=${PATH}:${HOME}/src/prokka/prokka/bin" >> ~/.bashrc
export PATH=${PATH}:${HOME}/src/prokka/prokka/bin
prokka --setupdb
