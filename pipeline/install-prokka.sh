cd ${HOME}/src/prodigal
curl -O http://prodigal.googlecode.com/files/prodigal.v2_60.tar.gz
tar xzf prodigal.v2_60.tar.gz
cd prodigal.v2_60/
make

cd ${HOME}/src/prokka
curl -O http://www.vicbioinformatics.com/prokka-1.7.tar.gz
tar xzf prokka-1.7.tar.gz
./configure --prefix=${HOME} && make && make install
