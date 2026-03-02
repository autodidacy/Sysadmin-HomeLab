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
* I then moved to PowerShell ISE to create my scripts. I'm going to run them in PowerShell by typing ".\script.ps1". This reminds me of compiling C programs and running them from the shell. Pretty cool!
* After creating my first OU script, I moved to the path in PowerShell and ran the script! Time to verify the new OU's exist.
* It worked, found the corporate parent OU along with each sub OU. I'm now moving each created user from the generic Users folder to the Corporate subOU Users. I will move one using a PowerShell script.
* Now, I have 4 users, 1 assigned to Admins, and three to Users. I will add more users, workstations and servers at a later date. For now, I'll be moving on to GPO.

# Creating Group Policy Objects (GPO)
The first three GPOs I will implement are: to restrict control panel access to Corporate Users, map a shared drive, and set password complexity and lockout policy. Bundled into the last step, I'll be setting up an audit policy for successful and failed login attempts.
* I've navigated to the Group Policy Management snap-in, followed the forest down to the Users subOU in Corporate. I right-clicked the Users folder and selected 'Create a GPO in this domain, and Link it here'. From what I hear, it's common to create a GPO and forget to link it to an OU, so this is a more efficient choice than going to the Group Policy Objects folder, creating a new GPO, and then manually linking it. Done!
* Following the same steps above, I created a GPO to map a shared drive for the network. I've set permissions at this step to give 'Everyone' full control, which is a vulnerability I will address by tweaking NTFS permissions later.
* To finish off the current round of GPOs, I've changed the minimum password length, account lockout threshold, and account lockout duration in the Default Domain Policy. I've also added Audit policies for account logon success/fail and local logon success/fail for event monitoring.

# Joining Workstations
For now, I've only got two instances going due to time constraints. More will be added in the future for security labs etc. in due time.
One workstation will be Win11, the other RHEL. It seems a little more convoluted to join the RHEL instance to the domain, but that's the fun part.
* For the Win11 instance, joining the domain is fairly easy. A few simple PowerShell commands will do the trick, provided everything is networked properly (wasn't) and the box isn't checked that forces password changes on first login (was). After a little troubleshooting, I got it connected to the domain, and moved the workstation from the container 'computers' to the Corporate OU's 'Workstation' subOU. After this, all is well. I've noticed the password complexity policy doesn't require users to change their existing passwords, and I will note that for future tasks. The share drive is present, but the user cannot open the control panel, and 5 failed login attempts have locked the account. Great! I've also verified that Event ID 4740 appears in Event Viewer for this event on the Server.
* Now for the part that excites me. This was a little easier than I thought it would be. Had to install a couple of tools to handle the join process (realmd, sssd, adcli, etc) and support the Kerberos/Samba protocols. However, I got stuck a few times when joining the domain at first. It turns out I had to create the computer object in 'Workstations' OU, and assign the admin account kerckel permissions necessary to complete the join. The Red Hat doc link for this error was especially helpful in getting this set up. Will set up sudoers for the Admins OU at a later date.

# Setting Up NTFS permissions
