# Sysadmin-HomeLab
Documentation for my first home lab, simulating an enterprise environment with AD and Linux services. I'm extremely excited to use GitHub for the first time. This will be a wonderful learning opportunity for me. Additionally, this will help me get familiar with Markdown formatting.

# Technologies Used:
* VMware Workstation
* Windows Server 2022
* RHEL
* Windows 11

# Challenges/Roadblocks:
* When installing Windows Server 2022 on VMware Workstation, a generic error, "Windows cannot find the Microsoft Software License Terms. Make sure the installation sources are valid and restart the installation.", would appear, crashing the install. Funny enough, the solution I found was to disable the floppy drive in the VM's virtualized hardware.
* When networking Windows Server 2022 using NAT in Virtual Network Editor, the network icon displays 'No Internet Access'. However, upon troubleshooting, the VM can ping internet hosts and resolve autozone.com. Not sure what's causing this, but it doesn't appear to be detrimental at this point.
* When attempting to run script moveUser.ps1, error resulted:
    "Move-ADObject : The operation could not be performed because the object's parent is either uninstantiated or deleted."
  I see the issue now. Simple typo in the definition of $targetOU. I typed elias.lab instead of eliaslab! All clear!
   
 
      
