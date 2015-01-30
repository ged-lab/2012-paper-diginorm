==========================================
Running the diginorm paper script pipeline
==========================================

:Date: Aug 4th, 2014

Here are some brief notes on how to run the pipeline for our paper on digital
normalization on an Amazon EC2 rental instance.

The instructions below will reproduce all of the figures in the paper,
and will then compile the paper from scratch using the new figures.


Starting up a machine and installing software
---------------------------------------------

First, start up an EC2 instance with the AWS console. Be sure to choose an
Ubuntu 14.04 instance. The c3.2xlarge instance size will work just fine, but
do not choose a smaller instance than this.

Make sure you edit your security groups to include port 22 (SSH) and port 
80 (HTTP) ; you'll need the first one to log in, and the second one to 
connect to the ipython notebook.

We tested this script on a RackSpace instance with specifications::
  #TODO get rackspace specifications
If you are running on RackSpace, we may need to add extra space for data by formating and mounting a drive.
Formating/Mounting Drive::
  mkfs -t ext4 /dev/xvde1
  mkdir /mnt/data
  mount /dev/xvde1 /mnt/data/ -t ext4
  # To make a regular user 
  adduser non-root # TODO find quick setup instructions

Next, we are going to set the instance up with many of the software 
packages we will need. You will need root permissions to install these::

 sudo apt-get update
 sudo apt-get --yes install screen git curl gcc make g++ python2.7-dev unzip \
            default-jre pkg-config libncurses5-dev r-base-core \
            r-cran-gplots python-matplotlib sysstat bowtie \
            texlive-latex-recommended mummer python-pip ipython \
            ipython-notebook bioperl ncbi-blast+ python-virtualenv hmmer \
            ncbi-tools-bin prodigal infernal aragorn parallel

If running on EC2::
 sudo  mkdir /mnt/bin
 sudo chown ubuntu /mnt/bin
 ln -s /mnt/bin ${HOME}/bin
 chmod -R u+rw o+rw /mnt

Non-EC2::
  mkdir ~/bin/
  chmod -R o+rw /mnt/data


Now that we have our root privledge-installs out of the way, lets add 
``~/bin`` to our path::

 echo 'export PATH=${PATH}:${HOME}/bin' >> ${HOME}/.bashrc
 source ${HOME}/.bashrc

Now, you'll need to install the version of 'khmer' that the
paper is currently using.::
 
 virtualenv venv
 source venv/bin/activate
 easy_install -U setuptools
 pip install khmer==1.1

and Velvet. (We need to do this the old fashioned way to enable large k-mer
sizes)::

 cd ${HOME}/bin/
 curl -O http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
 tar xzf velvet_1.2.10.tgz
 cd velvet_1.2.10
 make MAXKMERLENGTH=51
 cp velvet? ${HOME}/bin

OK, now we have installed almost all of the software we need, hurrah!

Running the pipeline
--------------------

First, check out the source repository and grab the (...large) initial data
sets::


 cd /mnt

(If on RackSpace)::

 cd /mnt/data

 git clone https://github.com/ged-lab/2012-paper-diginorm.git --branch ubuntu14.04/v1.1
 cd 2012-paper-diginorm

 curl -O https://s3.amazonaws.com/public.ged.msu.edu/2012-paper-diginorm/pipeline-data-new.tar.gz 
 tar xzf pipeline-data-new.tar.gz

Now go into the pipeline directory and install Prokka & run the pipeline.  This
will take 24-36 hours, so you might want to do it in 'screen' (see
http://ged.msu.edu/angus/tutorials-2011/unix_long_jobs.html). ::

  
 mkdir ~/src
 mkdir ~/src/prodigal
 mkdir ~/src/prokka
 cd pipeline
 bash install-prokka.sh
 make 

Once it successfully completes, copy the data over to the ../data/ directory::

 make copydata

Run the ipython notebook server::

 cd ../notebook
 ipython notebook --pylab=inline --no-browser --ip=* --port=80 &

Connect into the ipython notebook (it will be running at 'http://<your EC2 hostname>'); if the above command succeeded but you can't connect in, you probably forgot to enable port 80 on your EC2 firewall.

Once you're connected in, select the 'diginorm' notebook (should be the
only one on the list) and open it.  Once open, go to the 'Cell...' menu
and select 'Run all'.

(Cool, huh?)

Now go back to the command line and execute::

 mv *.pdf ../
 cd ../
 make

and voila, 'diginorm.pdf' will contain the paper with the figures you just
created.
