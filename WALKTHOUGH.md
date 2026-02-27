# Introduction
I started this homelab in preparation for an IT intern position, focusing on a simple systems administration lab. After installing VMware Workstation and configuring the virtual network to NAT (sharing an IP address with my personal computer), I proceeded to initialize Windows Server 2022. After configuring desired services (DHCP, DNS, AD), I proceeded to initialize a few Windows 11 and RHEL clients to add to the domain. 

# Domain Controller Configuration Steps
* First, I configured a static IP address for server (192.168.144.10), leaving the netmask default, and set up the DNS server as (127.0.0.1) as it will also serve as the DNS server.
* Second, I used Server Manager to install AD DS, DHCP, and DNS. Immediately following this, I created a forest (ad.eliaslab) and promoted this server to Domain Controller.
* I then moved to configure a DHCP scope in the range of 192.168.144.50 to .100, setting the default gateway to 192.168.144.2, and the DNS server to 192.168.144.10.
* I then configured the DNS server to be authoritative for the domains ad.elias and zone.eliaslab.com. I set up 8.8.8.8 as the forwarder for DNS requests outside of the zone.
* Finally, I tested connectivity by pinging 8.8.8.8 and searching autozone.com in Microsoft Edge. All systems go!
