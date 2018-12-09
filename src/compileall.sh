FOLDERNAME=cybercashfinally
CODENAME=cybercash
USERNAME=root
function prepare_system() {
echo -e "Installing Dependencies,please be patient"
apt-get update 
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade 
apt install -y software-properties-common 
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin 
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update 
sudo apt-get install qtdeclarative5-dev qml-module-qtquick-controls  
sudo apt-get install qt5-default 
sudo apt-get install qt5-default qttools5-dev-tools  
sudo apt install python3 python 

sudo apt-get install g++-mingw-w64-i686 mingw-w64-i686-dev g++-mingw-w64-x86-64 mingw-w64-x86-64-dev 
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip libzmq5 

if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

# function create_swap() {
#  echo -e "Checking if swap space is needed."
#  PHYMEM=$(free -g|awk '/^Mem:/{print $2}')
#  SWAP=$(free -g|awk '/^Swap:/{print $2}')
#  if [ "$PHYMEM" -lt "2" ] && [ -n "$SWAP" ]
#   then
#     echo -e "${GREEN}Server is running with less than 2G of RAM without SWAP, creating 2G swap file.${NC}"
#     SWAPFILE=$(mktemp)
#     dd if=/dev/zero of=$SWAPFILE bs=1024 count=2M
#     chmod 600 $SWAPFILE
#     mkswap $SWAPFILE
#     swapon -a $SWAPFILE
#  else
#   echo -e "${GREEN}Server running with at least 2G of RAM, no swap needed.${NC}"
#  fi
#  clear
# }


function makedepends() {
     #make depends first for all platforms we need
cd depends
# wget https://raw.githubusercontent.com/Bitcoin-Monster/BTCMonster/master/depends/Makefile
# cd patches/qt/
# wget https://raw.githubusercontent.com/bulwark-crypto/Bulwark/master/depends/patches/qt/aarch64-qmake.conf
# cd ..
# cd ..
chmod -R 775 *

echo '----Linux depends starting 64 bit -----'
python3 /$USERNAME/$FOLDERNAME/message.py '----Linux depends starting 64 bit -----'
# make HOST=x86_64-pc-linux-gnu
# echo '----Linux ARM depends starting 64 bit -----'
# python3 /$USERNAME/$FOLDERNAME/message.py  '----Linux ARM depends starting 64 bit -----'
# make HOST=arm-linux-gnueabihf
# echo '----Linux aarch64 starting 64 bit -----'
# python3 /$USERNAME/$FOLDERNAME/message.py  '----Linux aarch64 starting 64 bit -----'
# make HOST=aarch64-linux-gnu
 echo '----Windows depends starting 64 bit -----'
 python3 /$USERNAME/$FOLDERNAME/message.py '----Windows depends starting 64 bit -----'
 make HOST=x86_64-w64-mingw32
echo '----Windows depends starting 32 bit -----'
python3 /$USERNAME/$FOLDERNAME/message.py '----Windows depends starting 32 bit -----'
make HOST=i686-w64-mingw32
cd ..
}
function makelinux() {
        
        chmod -R 775 *
        # x86_64-pc-linux-gnu
./autogen.sh;
./configure --enable-tests=no 
python3 /$USERNAME/$FOLDERNAME/message.py 'Linux wallets stared compiling'
make
mkdir -p build/v2.0.0.0/x86_64-pc-linux-gnu
cp /$USERNAME/$FOLDERNAME/src/$CODENAMEd build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAMEd
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-tx build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-tx
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-cli build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-cli
cp /$USERNAME/$FOLDERNAME/src/qt/$CODENAME-qt build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-qt
strip build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAMEd
strip build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-tx
strip build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-cli
strip build/v2.0.0.0/x86_64-pc-linux-gnu/$CODENAME-qt
mkdir $CODENAME
cp /$USERNAME/$FOLDERNAME/src/$CODENAMEd  $CODENAME/
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-tx $CODENAME/
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-cli $CODENAME/
zip -r $CODENAME.zip $CODENAME
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 
NEWLINUXLINK=$(transfer $CODENAME.zip)
# python3 /$USERNAME/$FOLDERNAME/message.py 'Linux Binaries \/'
python3 /$USERNAME/$FOLDERNAME/message.py $NEWLINUXLINK
# sed -i -- 's/PUTLINKHERE/$NEWLINUXLINK/g' updatemn.sh   
# UPDATESCRIPTLINK=$(transfer updatemn.sh)

# python3 /$USERNAME/$FOLDERNAME/message.py 'Linux updatenode script \/'
# python3 /$USERNAME/$FOLDERNAME/message.py $UPDATESCRIPTLINK
# python3 /$USERNAME/$FOLDERNAME/message.py 'Ask MN holders to run'
# python3 /$USERNAME/$FOLDERNAME/message.py '```wget $UPDATESCRIPTLINK && bash updatemn.sh```'

#wget https://raw.githubusercontent.com/$CODENAME/$CODENAME/master/setupmn.sh

 python3 /$USERNAME/$FOLDERNAME/message.py 'Linux wallets finished'
# cd build/v2.0.0.0/x86_64-pc-linux-gnu
cd /$USERNAME/$FOLDERNAME

make clean

}
function makewindows64() {
        # x86_64-w64-mingw32
                python3 /$USERNAME/$FOLDERNAME/message.py 'Windows 64 bit wallets started compiling'
./autogen.sh;
./configure --prefix=/$USERNAME/$FOLDERNAME/depends/x86_64-w64-mingw32 --enable-tests=no --with-gui=qt5
# make HOST=x86_64-w64-mingw32 -j4 -k;
make
mkdir -p build/v2.0.0.0/x86_64-w64-mingw32
cp /$USERNAME/$FOLDERNAME/src/$CODENAMEd.exe build/v2.0.0.0/x86_64-w64-mingw32/$CODENAMEd.exe
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-tx.exe build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-tx.exe
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-cli.exe build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-cli.exe
cp /$USERNAME/$FOLDERNAME/src/qt/$CODENAME-qt.exe build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-qt.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAMEd.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-tx.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-cli.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-qt.exe
# ## created detached signatures
# cd build/v2.0.0.0/x86_64-w64-mingw32;


# ##/C=   Country         GB
# ##/ST=  State   London
# ##/L=   Location        London
# ##/O=   Organization    Global Security
# ##/OU=  Organizational Unit     IT Department
# ##/CN=  Common Name     example.com

# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-qt-selfsigned.key -out ./$CODENAME-qt-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAMEd-selfsigned.key -out ./$CODENAMEd-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-tx-selfsigned.key -out ./$CODENAME-tx-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-cli-selfsigned.key -out ./$CODENAME-cli-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";

# osslsigncode sign -certs $CODENAME-qt-selfsigned.crt -key $CODENAME-qt-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-qt.exe -out $CODENAME-qt-signed.exe

# osslsigncode sign -certs $CODENAMEd-selfsigned.crt -key $CODENAMEd-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAMEd.exe -out $CODENAMEd-signed.exe

# osslsigncode sign -certs $CODENAME-tx-selfsigned.crt -key $CODENAME-tx-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-tx.exe -out $CODENAME-tx-signed.exe

# osslsigncode sign -certs $CODENAME-cli-selfsigned.crt -key $CODENAME-cli-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-cli.exe -out $CODENAME-cli-signed.exe

# mv $CODENAME-qt-signed.exe $CODENAME-qt.exe;
# mv $CODENAMEd-signed.exe $CODENAMEd.exe;
# mv $CODENAME-tx-signed.exe $CODENAME-tx.exe;
# mv $CODENAME-cli-signed.exe $CODENAME-cli.exe;

cd /$USERNAME/$FOLDERNAME;
make clean
     python3 /$USERNAME/$FOLDERNAME/message.py 'Windows 64 bit wallets finished compiling'
}
function makewindows32() {
    chmod -R 775 *
        # x86_64-w64-mingw32
./autogen.sh;
./configure --prefix=/$USERNAME/$FOLDERNAME/depends/i686-w64-mingw32 --enable-tests=no --with-gui=qt5
# make HOST=x86_64-w64-mingw32 -j4 -k;
python3 /$USERNAME/$FOLDERNAME/message.py 'Windows 32 bit wallets started compiling'
make
mkdir -p build/v2.0.0.0/i686-w64-mingw32
cp /$USERNAME/$FOLDERNAME/src/$CODENAMEd.exe build/v2.0.0.0/xi686-w64-mingw32/$CODENAMEd.exe
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-tx.exe build/v2.0.0.0/i686-w64-mingw32/$CODENAME-tx.exe
cp /$USERNAME/$FOLDERNAME/src/$CODENAME-cli.exe build/v2.0.0.0/i686-w64-mingw32/$CODENAME-cli.exe
cp /$USERNAME/$FOLDERNAME/src/qt/$CODENAME-qt.exe build/v2.0.0.0/i686-w64-mingw32/$CODENAME-qt.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAMEd.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-tx.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-cli.exe
# strip build/v2.0.0.0/x86_64-w64-mingw32/$CODENAME-qt.exe
# ## created detached signatures
# cd build/v2.0.0.0/x86_64-w64-mingw32;


# ##/C=   Country         GB
# ##/ST=  State   London
# ##/L=   Location        London
# ##/O=   Organization    Global Security
# ##/OU=  Organizational Unit     IT Department
# ##/CN=  Common Name     example.com

# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-qt-selfsigned.key -out ./$CODENAME-qt-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAMEd-selfsigned.key -out ./$CODENAMEd-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-tx-selfsigned.key -out ./$CODENAME-tx-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./$CODENAME-cli-selfsigned.key -out ./$CODENAME-cli-selfsigned.crt -subj "/C=AT/ST=AK/L=AK/O=Development/OU=Core Development/CN=crypto-dex.net";

# osslsigncode sign -certs $CODENAME-qt-selfsigned.crt -key $CODENAME-qt-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-qt.exe -out $CODENAME-qt-signed.exe

# osslsigncode sign -certs $CODENAMEd-selfsigned.crt -key $CODENAMEd-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAMEd.exe -out $CODENAMEd-signed.exe

# osslsigncode sign -certs $CODENAME-tx-selfsigned.crt -key $CODENAME-tx-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-tx.exe -out $CODENAME-tx-signed.exe

# osslsigncode sign -certs $CODENAME-cli-selfsigned.crt -key $CODENAME-cli-selfsigned.key \
#         -n "$FOLDERNAME Ltd" -i http://www.crypto-dex.net/ \
#         -t http://timestamp.verisign.com/scripts/timstamp.dll \
#         -in $CODENAME-cli.exe -out $CODENAME-cli-signed.exe

# mv $CODENAME-qt-signed.exe $CODENAME-qt.exe;
# mv $CODENAMEd-signed.exe $CODENAMEd.exe;
# mv $CODENAME-tx-signed.exe $CODENAME-tx.exe;
# mv $CODENAME-cli-signed.exe $CODENAME-cli.exe;

cd /$USERNAME/$FOLDERNAME
python3 /$USERNAME/$FOLDERNAME/message.py 'Windows 32 bit wallets finished compiling'
make clean

}
function ziprelease() {
python3 /$USERNAME/$FOLDERNAME/message.py 'All wallets finished compiling,zipping them now and uploading'
cd /$USERNAME/$FOLDERNAME
zip -r wallets.zip build
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 
WALLETSLINK=$(transfer wallets.zip)
python3 /$USERNAME/$FOLDERNAME/message.py 'Wallet has been uploaded,here is the link'
python3 /$USERNAME/$FOLDERNAME/message.py $WALLETSLINK
}


#prepare_system
makedepends
makelinux
makewindows32
makewindows64
ziprelease