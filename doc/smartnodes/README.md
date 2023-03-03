# Manual Setup

:::note

For the following part of the guide you need to be root. depending on your VPS provider they may have only provided you with a "sudo" user. You can change to root by doing:

```bash
sudo su
```

:::

## Guide

### 1. Update Server

```bash
apt update && apt upgrade -y
apt install unzip fail2ban -y
```

<sub>Unzip is required to unpack the bootstrap.</sub>

### 2. Add 4GB of SWAP

First check to make sure there is not already swap active:

```bash
free -h
```

:::note

If no swap it will return:

```bash
Swap:            0B          0B          0B
```

:::

Create SWAP and Activate:

```bash
dd if=/dev/zero of=/swapfile bs=1k count=4096k
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile       swap    swap    auto      0       0" | tee -a /etc/fstab
sysctl -w vm.swappiness=10
echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
```

<div class="alert alert--info" role="alert">
  <sub>
    Note: <code>swappiness = 10</code> tells system only to use it if absolutely
    needed.
  </sub>
</div>

### 3. Enable UFW & Open Ports

(Optional)

```bash
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 21003/tcp
ufw enable
```

### 4. Configure Fail2Ban

As I am not bothering with setting up SSH login with keys rather then password based login need to keep something from the bots and kiddies brute forcing our SSH service.

Setup jail for bad guys hitting SSH, and set it to ban after three failed logins to SSH:

```bash
nano /etc/fail2ban/jail.local
```

Copy and paste the following into the file:

```bash
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
```

Reboot the server:

```bash
reboot
```

Add a system user to run taichicoind:

```bash
adduser <username_here>
```

Get Taichicoin wallet / daemon and bootstrap:

```bash
mkdir -p latest
sudo chmod -R 755 latest
cd latest
# Replace the following <version> numbers with the latest
wget https://github.com/Altcoin-Master/Taichicoin/releases/download/v<version>/taichicoin-<version>.zip
unzip taichicoin-<version>.zip
mkdir ~/.taichicoincore && touch ~/.taichicoincore/taichicoin.conf
echo "daemon=1" >> ~/.taichicoincore/taichicoin.conf
~/latest/taichicoin-<version>/./taichicoind -daemon
echo all done!
```

:::tip Info

You should see Taichicoind server starting. You can confirm it is running <code>top -c</code> it will be using 100% CPU (1 core). This shows you it is working, we will return to it later.

:::

## Local Wallet Setup

:::note

This part of the guide is to get your local wallet or control wallet setup. If you already have Taichicoin core wallet running you can skip to next section.

:::

### 1. Install and Sync Local Wallet:

- Start wallet and let it finish syncing.
- Encrypt wallet (Settings > Encrypt Wallet)
- Create new receiving address
- Backup wallet.dat (File > Backup Wallet). Store in multiple locations.
- Dump private key for receiving address (this should be printed and stored offline in multiple locations):

```
walletpassphrase password time (in seconds)
dumpprivkey "address" (address is the receiving address you sent the 200k TCC to)
```

- Send 200,000 TCC to self (this is the minimum collateral amount)
- Wait for 2 confirmations
- Smartnodes rules:
```
        0 - 100000    200,000 TCC
   100001 - 200000    400,000 TCC
   200001 - 300000    600,000 TCC
   300001 - 400000    800,000 TCC
   400001 - forever   1,000,000 TCC
```

:::note

The private key only allows you to restore the matching receiving address. If you setup multiple nodes you should dump the private key for each collateral receiving address.

:::

### 2. Build protx command for control wallet {#build-protx}

Here is an example protx quick_setup command:

```bash
protx quick_setup "c4bbcde9771668fa640c263d4b964f688b0f039f7b684e715d92e4012369fea6" "1" "127.0.0.1:21003" "BFbWv94ZfueciwVVpHLMdqFayaXAS4sBxP"
```

The structure from left to right is:

- <code>Transaction ID</code>: In your wallet go to "Transactions" right click
  the one you sent yourself earlier and "Copy Transaction ID". Replace the
  Transaction ID in example.
- <code>Collateral index</code>: Tools > Debug console. Type smartnode outputs
  to check if 1 or 0. Adjust example command if needed.
- <code>Your smartnode server IP and port</code>. Replace example IP with your
  Smartnode server IP, leave port as is.
- <code>Fee address</code>: This is any address in your wallet which contains
  enough TCC to pay the fee (cannot be the address which you sent the 1 million
  TCC to). When you enter the protx quick_setup command it is a transaction and
  needs to be paid for. It is a very small amount 1/2 an TCC is more than
  enough. In Debug console do "listaddressbalances" to show all addresses with a
  balance, choose one and replace address in example command.

:::info

Enter the protx quick_setup command in Debug console. This will create a .conf file for that node in the same directory you ran the wallet from. Open it and copy the contents.

:::

## Final steps

Back to the smartnode server:

```bash
~./taichicoin-cli stop
nano ~/.taichicoincore/taichicoin.conf
```

Paste in what you copied from the .conf file made during the protx command, save and exit.

When done with this, run taichicoind from the terminal:

```bash
~/./taichicoind -daemon
```

When this is done, wait a couple minutes until running `~/./taichicoin-cli smartnode status` to check the status of your smartnode. This should return: `Ready Ready`

:::success Success!
Your Smartnode should now be running!
:::

## View node status in QT wallet
Settings - Options - Wallet - Show Smartnode Tab
