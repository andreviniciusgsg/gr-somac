#!/bin/bash

ARG_ID=$1
MODE=$2

# IDs of TunTap script
IDS_CONFIG=(1 2 3 4 5 6 7 8 9 GATEWAY)

# Setup {{{
PROT=$MODE; # 0: CSMA, 1: TDMA, 2: SOMAC
DATE=`date +%d%m%Y_%H%M`;
DIR=$HOME/$PROT"_"$DATE;

mkdir $DIR;
# }}}

# Run {{{

cd ~
sudo ./gr-somac/apps/container/config_interface_tuntap_"${IDS_CONFIG[$ARG_ID]}".sh;

sudo pkill python; sudo pkill ping;

RUN_TIME=5400
if [[ $ARG_ID -eq 9 ]]; then
	echo "COORDINATOR"
	echo $MODE > "/tmp/prot.txt"
	sudo rm -rf "/tmp/backlog_file.npy"
	sudo rm -rf "/tmp/out.log"
	((sleep $RUN_TIME; sudo pkill python) & sudo ./gr-somac/examples/wifi_transceiver_FlexDataLink_"${IDS_CONFIG[$ARG_ID]}".py);
else
	echo "NORMAL NODE"
	((sleep $RUN_TIME; sudo pkill python; sudo pkill ping) & sudo ./gr-somac/examples/wifi_transceiver_FlexDataLink_"${IDS_CONFIG[$ARG_ID]}".py >/dev/null 2>&1 & sudo python $HOME/gr-somac/apps/container/rand_ping.py "${IDS_CONFIG[$ARG_ID]}");
fi
# }}}

# Copy logs {{{
cp /tmp/*npy $DIR;
cp /tmp/*log $DIR;
# }}}


