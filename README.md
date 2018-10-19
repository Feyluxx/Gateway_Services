My Ubuntu server has compiled a great deal of basic gateway services, all functioning (finally) as they should be. 
This includes DNS, DHCP, UFW(Uncomplicated Firewall) and a Squid transparent Proxy. These can all be simply installed using the 
sudo apt-get command. These services are all running on an internal network interface card on a private 10.0.0.0/24 network (ens224) 
while i also have a external nic routing traffic from the 172 network. I used a combination of UFW and iptables in order to use NAT 
and IP Masquerading to allow my client machines on the 10 network internet access on the 172 network.
Installation of the following can be done as follows:
DNS; sudo apt-install bind9
Open /etc/bind/named.conf.options in nano and edit the forwarders; add known dns servers that you want your dns server to pull from 
such as 8.8.8.8. Always end these lines with a semi-colon.
Forwarders {
	8.8.8.8;
	1.1.1.1;

The closing bracket is later on in the file.
Create a zone within /etc/bind/named.conf.local
zone “sysninja.” {
		type master;
		file “/etc/bind/forward.sysninja.com”;
};
Edit that zone file (you can copy the configuration for it from /etc/bind.)
Basically, insert your domain suffix wherever it says localhost.
Delete any existing rules other than the nameserver rule, and add to A rules
@	IN	A	*ip address of server*
*	IN	A	*ip address of server*
Test your configuration by using a computer on the network to run an nslookup on your domain using your servers ip as their 
configured dns server.
DHCP; sudo apt-get install isc-dhcp-server
To configure dhcp, use nano to edit the configuration file; /etc/dhcp/dhcpd.conf
Change all required information for the configuration file (what you want your dhcp server to give out to clients)

UFW; sudo apt-get ufw(if not already installed)
Add desired rules using the ufw allow command (sudo ufw allow bind 9/port number {67})
To configure ip masquerading using ufw, configure multiple configuration files and add 1 iptables rule.
In /etc/default/ufw change the DEFAULT_FORWARD_POLICY to “ACCEPT”:
Then edit /etc/ufw/sysctl.conf and uncomment:
Use the iptables command “iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE”
Where the ip and interface match your topology.
SQUID PROXY; sudo apt-get 
Add the following lines to the /etc/squid/squid.conf file.
http_port 3129
http_port 3128 intercept
acl lan src 192.168.0.0/24
http_access allow lan 
Save the file and then run the 
sudo iptables -t nat -A PREROUTING -i enx0050b617c34f -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.0.1:3128

Replace the interface and ip address the that of your internal network and you’re good to go! (Should be)





