#!/bin/bash
mkdir -p ${HOME}/src/prodigal
cd ${HOME}/src/prodigal
curl -OL https://github.com/hyattpd/Prodigal/archive/v2.60.tar.gz
tar xzf v2.60.tar.gz
cd Prodigal-2.60/
make

mkdir -p ${HOME}/src/prokka
cd ${HOME}/src/prokka
curl -O http://www.vicbioinformatics.com/prokka-1.7.tar.gz
tar xzf prokka-1.7.tar.gz
