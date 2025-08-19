NET_INTERFACE=wlp0s20f3
VPN_INTERFACE=tun0
VPN_NAME=us.protonvpn.udp

sudo ufw disable
sudo ufw reset

# disable IPV6 traffic - IPV6 is not well supported for VPN
sudo echo 'net.ipv6.conf.all.disable_ipv6=1' | sudo tee /etc/sysctl.conf
sudo echo 'net.ipv6.conf.default.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
sudo echo 'net.ipv6.conf.lo.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
# sudo echo 'net.ipv6.conf.tun0.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# we should deny here, but ubuntu would be able to connect to wifi or vpn
sudo ufw default deny outgoing
sudo ufw default deny incoming

sudo ufw allow out on $VPN_INTERFACE from any to any
# sudo ufw allow in on $VPN_INTERFACE from any to any

# DNS [NOT recomended]
# sudo ufw allow 53/udp
# SSH [NOT recomended]
# sudo ufw allow ssh

# Turning VPN on [Optional] 
# nmcli connection up $VPN_NAME
# Extract all gateway adresses and ports from nmcli configuration
GATEWAYS=`nmcli --terse --fields vpn.data connection show $VPN_NAME| grep -oP 'remote =\K.*' | sed 's/\\,/,/g' | sed 's/, remote-cert-tls.*$//'|tr ',' '\n' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]+' | sort -u`

for ELEM in $GATEWAYS; do
    IP=$(echo $ELEM | cut -d':' -f1)
    PORT=$(echo $ELEM | cut -d':' -f2)
    echo "$VPN_NAME $NET_INTERFACE to/from $IP port $PORT proto udp"
    sudo ufw allow out on $NET_INTERFACE to $IP port $PORT proto udp
#    sudo ufw allow in on $NET_INTERFACE from $IP port $PORT proto udp
done

sudo ufw enable
sudo ufw status verbose
