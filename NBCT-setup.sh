#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 14.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your NeckBeardCryptoTips  masternodes.  *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update

  sudo apt-get upgrade

  sudo apt-get install automake libdb++-dev build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libminiupnpc-dev git software-properties-common python-software-properties g++ bsdmainutils libevent-dev -y

  sudo add-apt-repository -y ppa:bitcoin/bitcoin

  sudo apt-get update

  sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

  sudo apt-get install libgmp3-dev -y


  git clone https://github.com/GilbertGrape/NeckBeardCryptoTips

cd NeckBeardCryptoTips/

sudo dd if=/dev/zero of=/swapfile bs=1M count=2000
sudo mkswap /swapfile
sudo chown root:root /swapfile
sudo chmod 0600 /swapfile
sudo swapon /swapfile

#make swap permanent
sudo echo "/swapfile none swap sw 0 0" >> /etc/fstab

cd src

make -f makefile.unix

mv NeckBeardCryptoTipsd /usr/local/bin/

cd


  # dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
  # mkswap /var/swap.img
  # swapon /var/swap.img

  # sudo mv  NeckBeardCryptoTips/bin/* /usr/bitcoin

  cd

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

MNCOUNT=""
re='^[0-9]+$'
while ! [[ $MNCOUNT =~ $re ]] ; do
   echo ""
   echo "How many nodes do you want to create on this server?, followed by [ENTER]:"
   read MNCOUNT
done

for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS

  echo ""
  echo "Enter port for node $ALIAS(i.E. 7748)"
  read PORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  echo ""
  echo "Enter RPC Port (Any valid free port: i.E. 27261)"
  read RPCPORT

  ALIAS=${ALIAS,,}
  CONF_DIR=~/.EarnzCoin_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/NeckBeardCryptoTipsd_$ALIAS.sh
  echo "NeckBeardCryptoTipsd -daemon -conf=$CONF_DIR/NeckBeardCryptoTips.conf -datadir=$CONF_DIR "'$*' >> ~/bin/NeckBeardCryptoTipsd_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/NeckBeardCryptoTips-cli_$ALIAS.sh
  echo "NeckBeardCryptoTips-cli -conf=$CONF_DIR/NeckBeardCryptoTips.conf -datadir=$CONF_DIR "'$*' >> ~/bin/NeckBeardCryptoTips-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/NeckBeardCryptoTips-tx_$ALIAS.sh
  echo "NeckBeardCryptoTips-tx -conf=$CONF_DIR/NeckBeardCryptoTips.conf -datadir=$CONF_DIR "'$*' >> ~/bin/NeckBeardCryptoTips-tx_$ALIAS.sh
  chmod 755 ~/bin/NeckBeardCryptoTips*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> NeckBeardCryptoTips.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> NeckBeardCryptoTips.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> NeckBeardCryptoTips.conf_TEMP
  echo "rpcport=$RPCPORT" >> NeckBeardCryptoTips.conf_TEMP
  echo "listen=1" >> NeckBeardCryptoTips.conf_TEMP
  echo "server=1" >> NeckBeardCryptoTips.conf_TEMP
  echo "daemon=1" >> NeckBeardCryptoTips.conf_TEMP
  echo "logtimestamps=1" >> NeckBeardCryptoTips.conf_TEMP
  echo "maxconnections=256" >> NeckBeardCryptoTips.conf_TEMP
  echo "masternode=1" >> NeckBeardCryptoTips.conf_TEMP
  echo "" >> NeckBeardCryptoTips.conf_TEMP

  #echo "addnode=addnode=91.121.71.172" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=109.124.213.194" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=202.182.110.55" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=217.115.98.185" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=54.37.16.231" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=88.99.201.58" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=98.226.11.139" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=35.197.125.133" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=149.28.53.192" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=151.224.28.188" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=91.121.71.172" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=95.211.224.212" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=104.54.217.117" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=159.65.53.106" >> NeckBeardCryptoTips.conf_TEMP
  #echo "addnode=addnode=173.249.33.136" >> NeckBeardCryptoTips.conf_TEMP

  echo "" >> NeckBeardCryptoTips.conf_TEMP
  echo "port=$PORT" >> NeckBeardCryptoTips.conf_TEMP
  echo "masternodeaddress=$IP:$PORT" >> NeckBeardCryptoTips.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> NeckBeardCryptoTips.conf_TEMP
  sudo ufw allow $PORT/tcp

  mv NeckBeardCryptoTips.conf_TEMP $CONF_DIR/NeckBeardCryptoTips.conf

  sh ~/bin/NeckBeardCryptoTipsd_$ALIAS.sh
done
