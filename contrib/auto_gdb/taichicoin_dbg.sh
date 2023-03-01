#!/bin/bash
# use testnet settings,  if you need mainnet,  use ~/.taichicoincore/taichicoind.pid file instead
taichicoin_pid=$(<~/.taichicoincore/testnet3/taichicoind.pid)
sudo gdb -batch -ex "source debug.gdb" taichicoind ${taichicoin_pid}
