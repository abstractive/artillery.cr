# Setting up `0MQ`

`Artillery` currently uses ZeroMQ for messaging between `Mountpoint` and `Launcher` instances,
firing shots on request. These instructions prepare the underlying ZeroMQ requirements.

---

## Instructions for Ubuntu / Mint / Debian

### Prerequisites:

```
sudo apt install libtool pkg-config build-essential autoconf automake libzmq3-dev
```

### libsodium

```
git clone git://github.com/jedisct1/libsodium.git
cd libsodium
./autogen.sh
./configure && make check
sudo make install
sudo ldconfig
```

### zeromq

```
wget http://download.zeromq.org/zeromq-4.3.1.tar.gz
tar -xvf zeromq-4.3.1.tar.gz
cd zeromq-4.3.1
./autogen.sh
./configure && make check
sudo make install
sudo ldconfig
```