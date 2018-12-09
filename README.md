Cybercash (fork of PIVX Core) integration/staging repository
======================================




***

Quick installation of the Cybercash daemon under linux. See detailed instructions there [build-unix.md](build-unix.md)

Installation of libraries (using root user):

    add-apt-repository ppa:bitcoin/bitcoin -y
    apt-get update
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
    apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
    apt-get install -y libdb4.8-dev libdb4.8++-dev

Cloning the repository and compiling (use any user with the sudo group):

    cd
    git clone https://github.com/Supranadro/cybercash
    cd Cybercash
    ./autogen.sh
    ./configure
    sudo make install
    cd src
    sudo strip cybercashd
    sudo strip cybercash-cli
    sudo strip cybercash-tx
    cd ..

Running the daemon:

    cybercashd 

Stopping the daemon:

    cybercash-cli stop

Demon status:

    cybercash-cli getinfo
    cybercash-cli mnsync status

All binaries for different operating systems, you can download in the releases repository:



P2P port: 5519, RPC port: 5518
-
Distributed under the MIT software license, see the accompanying file COPYING or http://www.opensource.org/licenses/mit-license.php.

Credits:
Dash
Bitcoin
PIVX
Peercoin
Blocknode
ALQO
LPC
# Cybercashcore
