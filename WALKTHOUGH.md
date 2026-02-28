# Introduction
I started this homelab in preparation for an IT intern position, focusing on a simple systems administration lab. After installing VMware Workstation and configuring the virtual network to NAT (sharing an IP address with my personal computer), I proceeded to initialize Windows Server 2022. After configuring desired services (DHCP, DNS, AD), I proceeded to initialize a few Windows 11 and RHEL clients to add to the domain. 

# Domain Controller Configuration Steps
* First, I configured a static IP address for server (192.168.144.10), leaving the netmask default, and set up the DNS server as (127.0.0.1) as it will also serve as the DNS server.
* Second, I used Server Manager to install AD DS, DHCP, and DNS. Immediately following this, I created a forest (ad.eliaslab) and promoted this server to Domain Controller.
* I then moved to configure a DHCP scope in the range of 192.168.144.50 to .100, setting the default gateway to 192.168.144.2, and the DNS server to 192.168.144.10.
* I then configured the DNS server to be authoritative for the domains ad.eliaslab and zone.eliaslab.com. I set up 8.8.8.8 as the forwarder for DNS requests outside of the zone.
* Finally, I tested connectivity by pinging 8.8.8.8 and searching autozone.com in Microsoft Edge. All systems go!

# Creating Users and Organizational Units (OU)
* I've added four users in the Active Directory Users and Computers snap-in. I will create more users via PowerShell tomorrow and assign OU's and GPO's to each user.
* Today I've decided to create OU's before using scripting for user creation to ease automation. I first used the command "(Get-ADDomain).DistinguishedName" to fetch the LDAP format of my domain path, to avoid mistakes.
* I then moved to PowerShell ISE to create my scripts. I'm going to run them in PowerShell by typing ".\script.ps1". This reminds me of compiling C programs and running them from the CLI in a Linux environment. Pretty cool!
* After creating my first OU script, I moved to the path in PowerShell and ran the script! Time to verify the new OU's exist.
* It worked, found the corporate parent OU along with each sub OU. I'm now moving each created user from the generic Users folder to the Corporate subOU Users. I will move one using a PowerShell script.
* Now, I have 4 users, 1 assigned to Admins, and three to Users. I will add more users, workstations and servers at a later date. For now, I'll be moving on to GPO.

# Creating Group Policy Objects (GPO)
The first three GPOs I will implement are: to restrict control panel access to Corporate Users, map a shared drive, and set password complexity and lockout policy.
* I've navigated to the Group Policy Management snap-in, followed the forest down to the Users subOU in Corporate. I right-clicked the Users folder and selected 'Create a GPO in this domain, and Link it here'. From what I hear, it's common to create a GPO and forget to link it to an OU, so this is a more efficient choice than going to the Group Policy Objects folder, creating a new GPO, and then manually linking it.
  
