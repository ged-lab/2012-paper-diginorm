#!/bin/bash -ex
mkdir -p ${HOME}/src/prodigal
cd ${HOME}/src/prodigal
curl -OL https://github.com/hyattpd/Prodigal/archive/v2.60.tar.gz
tar xzf v2.60.tar.gz
cd Prodigal-2.60/
make

mkdir -p ${HOME}/src/prokka
cd ${HOME}/src/prokka
curl -OL https://github.com/Victorian-Bioinformatics-Consortium/prokka/archive/v1.11.tar.gz
tar xzf v*.tar.gz
ln -s prokka-* prokka
echo 'export PATH=${PATH}:${HOME}/src/prokka/prokka/bin' >> ~/.bashrc
export PATH=${PATH}:${HOME}/src/prokka/prokka/bin
prokka --setupdb
