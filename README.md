# vpn_enforce
Linux shell file to implementing a killswitch when your VPN connection drops.
This works on ubuntu 25.04 and later, and probably any version of linus using nmcli and ufw.

Configure the NET_INTERFACE, VPN_INTERFACE, VPN_NAME on the top of the script and run the script.

## Principle

When connecting to a VPN through the NetworkManager, it can happen your VPN drops connection. If you don't implement a killswitch, your IP will be public for any new query. A killswitch allows blocking any connection to Internet if your VPN connection drops.

Your computer uses a specific `tun0` interface when connecting to a VPN. 

The principle behind the following scripts is simply to deny all connection except the one from `tun0` thanks to `ufw` (a firewall).

## Install

1. **Connect to your VPN** and check the interface used by your computer

    It _should_ be `tun0` but we want to make sure :

    ```bash
    ip a | grep tun0
    ```

    If this commands return nothing, enter the `ip a` command and check which network interface your VPN uses.

2. Installing firewall script

    ```bash
    git clone https://github.com/lafa/vpn_enforce && cd vpn_enforce

    sudo apt-get install ufw -y # Installing UFW

    # Copy script files
    cp vpn_enforce.sh ~/vpn_enforce.sh

    # Enable firewall for VPN-connections only
    # CONNECT TO YOUR VPN FIRST
    bash vpn_enforce.sh

    # Disable firewall to go back to regular connection
    sudo ufw disable
    ```
3. If you edit the file vpn_enforce.sh
   
   You can change the NET and VPN interface in the first lines of the script.  
   You can also allow inbound traffic by removing the comments from the file; the default is to allow only outbound traffic.
