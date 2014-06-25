==========================================
Running the diginorm paper script pipeline
==========================================

:Date: Jun 25, 2014

Here are some brief notes on how to run the pipeline for our paper on digital
normalization on an Amazon EC2 rental instance.

The instructions below will reproduce all of the figures in the paper,
and will then compile the paper from scratch using the new figures.

(Note that you can also start with ami-61885608, which has all the
below software installed.)

.. and the EC2 snapshot snap-09d7f173 has all
.. of the data on it.  If you mount that volume and then cp -r everything
.. into /mnt, you will have all the software and files below installed in
.. the right place to run the pipline 'make' near the bottom.)

.. put in sofwtare version .tgz download?
.. https://github.com/ctb/khmer/tarball/2012-paper-diginorm

Starting up a machine and installing software
---------------------------------------------

Make sure that port 22 (SSH) and port 80 (HTTP) are open; you'll need
the first one to log in, and the second one to connect to the ipython
notebook.

Just ssh in however you would normally do it. And then set a few things
up for ubuntu::

 sudo su

 apt-get update
 apt-get -y install screen git curl gcc make g++ python-dev unzip \
            default-jre pkg-config libncurses5-dev r-base-core \
                       r-cran-gplots python-matplotlib sysstat


We will need pip, ipython, and the ipython notebook.  Make sure we have 
the latest version of ipython notebook (you need 0.13dev, or later) ::

 apt-get install python-pip
 apt-get install ipython
 apt-get install ipython-notebook

Now, you'll need to install the version of 'khmer' that the
paper is currently using.::
 
 easy_install -U setuptools
 pip install khmer==1.1,

OK, now let's install a few other things: some software, ::

and bowtie::

 apt-get install bowtie

and Velvet. (We need to do this the old fashioned way to set our default
max kmer length)::

 cd /root
 curl -O http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
 tar xzf velvet_1.2.10.tgz
 cd velvet_1.2.10
 make MAXKMERLENGTH=51
 cp velvet? /usr/local/bin

Finally, upgrade the latex install with a few recommended packages, and
add mummer::

 apt-get install -y texlive-latex-recommended mummer

OK, now all your software is installed, hurrah!

Running the pipeline
--------------------

First, check out the source repository and grab the (...large) initial data
sets::

 cd /mnt
 git clone https://github.com/ged-lab/2012-paper-diginorm.git
 cd 2012-paper-diginorm

 curl -O https://s3.amazonaws.com/public.ged.msu.edu/2012-paper-diginorm/pipeline-data-new.tar.gz
 tar xzf pipeline-data-new.tar.gz

Now go into the pipeline directory and install Prokka & run the pipeline.  This
will take 24-36 hours, so you might want to do it in 'screen' (see
http://ged.msu.edu/angus/tutorials-2011/unix_long_jobs.html). ::

 cd pipeline
 bash install-prokka.sh
 make KHMER=/usr/local/share/khmer

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
