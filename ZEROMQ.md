# Setting up `0MQ`

`Artillery` currently uses ZeroMQ for messaging between `Mountpoint` and `Launcher` instances,
firing shots on request. These instructions prepare the underlying ZeroMQ requirements.

---

## Instructions for Ubuntu / Mint / Debian

### Prerequisites:

```
sudo apt install libtool pkg-config build-essential autoconf automake libzmq3-dev
```
