cd ${HOME}/src/prodigal
curl -OL https://github.com/hyattpd/Prodigal/archive/v2.60.tar.gz
tar xzf v2.60.tar.gz
cd Prodigal-2.60/
make

cd ${HOME}/src/prokka
curl -O http://www.vicbioinformatics.com/prokka-1.7.tar.gz
tar xzf prokka-1.7.tar.gz
