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

If you are going to run this pipeline on a cloud machine, we recommend Amazon EC2 or RackSpace.
These notes will give specific instructions to both of those machine types.

EC2
--------------------------------------------
When starting an EC2 instance with the AWS console. Be sure to choose an
Ubuntu 14.04 instance. The c3.2xlarge instance size will work just fine, but
do not choose a smaller instance than this.

Make sure you edit your security groups to include port 22 (SSH) and port 
8080 ; you'll need the first one to log in, and the second one to 
connect to the ipython notebook.

If you need to create a new user, you can do so with::

  sudo useradd -m -d /home/user <your_user_name>

We will also want to link /mnt/bin directory to our home/bin directory::
  sudo ln -s /mnt/bin ${HOME}/bin


RackSpace
____________________________________________
Additionally, if you are on RackSpace, you will need to disable the firewall so that you can run the iPython notebook.::

  sudo service ufw stop

If you need to create a new user, you can do so with::

  sudo adduser <your_user_name>


Depending on the instance you chose, we may need to add extra space for data by formating and mounting a drive.
Formating/Mounting Drive::

  mkfs -t ext4 /dev/xvde1
  mount /dev/xvde1 /home/<your_user_name> -t ext4

Then we want to set the user directory to the home path, and grant permissions to the user::

  sudo chown -R <your_user_name> /home/<your_user_name>


Root Installs
--------------------------------------------
Next, we are going to set the instance up with many of the software 
packages we will need. You will need root permissions to install these::

 sudo apt-get update
 sudo apt-get --yes install screen git curl gcc make g++ python2.7-dev unzip \
            default-jre pkg-config libncurses5-dev r-base-core \
            r-cran-gplots python-matplotlib sysstat bowtie \
            texlive-latex-recommended mummer python-pip ipython \
            ipython-notebook bioperl ncbi-blast+ python-virtualenv hmmer \
            ncbi-tools-bin infernal aragorn parallel python-numpy prodigal



All Non-Root
--------------------------------------------
Once you have completed all of the previous commands that require root permissions,
go ahead and login as you normally would.
Now we can go ahead and add ``~/bin`` to our path::

 cd ${HOME}
 source venv/bin/activate


Now you'll need to install the version of 'khmer' that the
paper is currently using.::

 echo 'export PATH=${PATH}:${HOME}/bin' >> ${HOME}/.bashrc
 source ${HOME}/.bashrc
 cd ${HOME}
 mkdir -p bin
 virtualenv venv
 source venv/bin/activate
 easy_install -U setuptools
 pip install khmer==1.1

We also need to install screed::

 git clone git://github.com/ged-lab/screed.git
 python setup.py install


We need to install Velvet. (We need to do this the old fashioned way to enable large k-mer
sizes)::

 mkdir -p ${HOME}/src/velvet
 mkdir -p ${HOME}/bin
 cd ${HOME}/src/velvet
 curl -O http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
 tar xzf velvet_1.2.10.tgz
 cd velvet_1.2.10
 make MAXKMERLENGTH=51
 cp velvet? ${HOME}/bin

OK, now we have installed almost all of the software dependencies we need, hurrah!

Running the pipeline
--------------------

First, check out the source repository and grab the (...large) initial data
sets::

 cd ${HOME}

 git clone https://github.com/ged-lab/2012-paper-diginorm.git --branch non-root-install

Now go into the pipeline directory and install Prokka & run the pipeline.  This
will take 24-36 hours, so you might want to do it in 'screen' (see
http://ged.msu.edu/angus/tutorials-2011/unix_long_jobs.html). ::

 cd 2012-paper-diginorm/pipeline
 bash install-prokka.sh
 make 

Once it successfully completes, copy the data over to the ../data/ directory::

 make copydata

Run the ipython notebook server::

 cd ../notebook
 ipython notebook --pylab=inline --no-browser --ip=* --port=8080 &


Connect into the ipython notebook (it will be running at 'http://<your EC2 hostname>:8080'); if the above command succeeded but you can't connect in, you probably forgot to enable port 8080 on your EC2 firewall.

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
