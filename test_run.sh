#!/bin/bash
MCSIM_HOME=`pwd`
PIN_HOME=${MCSIM_HOME}/pin/
# 3. Compile McSimA+ by
cd ${MCSIM_HOME}/McSim
make clean
make INCS=-I${PIN_HOME}/extras/xed2-intel64/include -j 8
# - McSimA+ needs snappy compression library from Google.
#  = http://code.google.com/p/snappy/
#  = please install and setup proper environmental variables such as
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:
#4. Compile Pthread
cd ${MCSIM_HOME}/Pthread
make clean
make TOOLS_DIR=${PIN_HOME}/source/tools -j 8
#5. Compile a test program 'stream'
cd ${MCSIM_HOME}/McSim/stream
make clean
make


#How to run
#----------

#*. Turn off ASLR.  ASLR makes memory allocators return different
#   virtual address per program run.
# - how to turn it off depends on Linux distribution.
#  = In RHEL/Ubuntu, "sudo echo 0 > /proc/sys/kernel/randomize_va_space"
sudo echo 0 > /proc/sys/kernel/randomize_va_space
#  = See below if do not have sudo privilege to execute the command to turn off ASLR
#1. Test run
export PIN=${PIN_HOME}/intel64/bin/pinbin
export PINTOOL=${MCSIM_HOME}/Pthread/mypthreadtool
cd ${MCSIM_HOME}/McSim
./mcsim -mdfile ../Apps/md/md-o3-closed.py -runfile ../Apps/list/run-test.py
#2. Test stream
export PATH=$PATH:${MCSIM_HOME}/McSim/stream/:
cd ${MCSIM_HOME}/McSim
./mcsim -mdfile ../Apps/md/md-o3-closed.py -runfile ../Apps/list/run-stream.py
#3. When do not have sudo privilege to turn off ASLR for the system
# - Turn off ASLR when launching McSimA+ simulation
#  = setarch `uname -m` -R ./mcsim -mdfile ../Apps/md/md-o3-closed.py -runfile ../Apps/list/run-test.py
