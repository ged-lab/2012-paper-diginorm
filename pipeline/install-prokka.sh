apt-get update
apt-get -y install bioperl ncbi-blast+

cd /mnt
curl -O http://www.vicbioinformatics.com/prokka-1.7.tar.gz
tar xzf prokka-1.7.tar.gz

cd /mnt
curl -O ftp://selab.janelia.org/pub/software/hmmer3/3.1b1/hmmer-3.1b1.tar.gz
tar xzf hmmer-3.1b1.tar.gz
cd hmmer-3.1b1/
./configure --prefix=/usr && make && make install

cd /mnt
curl -O http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.36.tgz
tar -xvzf aragorn1.2.36.tgz
cd aragorn1.2.36/
gcc -O3 -ffast-math -finline-functions -o aragorn aragorn1.2.36.c
cp aragorn /usr/local/bin

cd /mnt
curl -O http://prodigal.googlecode.com/files/prodigal.v2_60.tar.gz
tar xzf prodigal.v2_60.tar.gz
cd prodigal.v2_60/
make
cp prodigal /usr/local/bin

cd /mnt
curl -O ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz
gunzip linux64.tbl2asn.gz
mv linux64.tbl2asn tbl2asn
chmod +x tbl2asn
cp tbl2asn /usr/local/bin

cd /mnt
curl -O http://ftp.gnu.org/gnu/parallel/parallel-20130822.tar.bz2
tar xjvf parallel-20130822.tar.bz2
cd parallel-20130822/
ls
./configure && make && make install

cd /mnt
curl -O http://selab.janelia.org/software/infernal/infernal-1.1rc4.tar.gz
tar xzf infernal-1.1rc4.tar.gz
cd infernal-1.1rc4/
ls
./configure && make && make install


