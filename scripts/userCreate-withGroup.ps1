# initialize Active Directory
Import-Module Active Directory

# define users in an array of hash tables. It might be smarter to pull from a .csv in the future to improve automation.
# note that this will cause an error if the security groups haven't already been created.
$NewUsers = @(
    @{ SamAccountName = "jjeffries"; GivenName = "Jack"; Surname = "Jefferies"; Group = "SG_User_Read" },
    @{ SamAccountName = "tbeasley"; GivenName = "Ted"; Surname = "Beasley"; Group = "SG_User_Modify"},
    @{ SamAccountName = "ksutherland"; GivenName = "Kelly"; Surname = "Sutherland"; Group = "SG_User_Read" }
)

# Set default password. It would be interesting to implement random password generation (provided there's a way to fetch it later!).
$Password = ConvertTo-SecureString "SemperFidelis2026!" -AsPlainText -Force

# Loop through array and create each user. The user variable is defined within the loop.
foreach ($User in $NewUsers) {

    # Check if the user already exists
    New-ADUser -SamAccountName $User.SamAccountName `
               -UserPrinccipalName "$($User.SamAccountName)@ad.eliaslab" `
               -Name "$(User.GivenName) $($User.Surname)" `
               -GivenName $User.GivenName `
               -Surname $User.Surname `
               -AccountPassword $Password `
               -Enabled $true `
               -PasswordNeverExpires $true

    Write-Host "Successfully created user: $($User.GivenName) $($User.Surname)" -ForegroundColor Green

    # Add user to assigned RBAC group
    Add-ADGroupMember -Identity $User.Group -Members $User.SamAccountName
    Write-Host "Added $($User.SamAccountName) to group: $($User.Group)" -ForegroundColor Cyan
    Write-Host "------------------------------" -ForegroundColor DarkGrey

    } else {
        Write-Host "User $($User.SamAccountName) already exists, skipping." -ForegroundColor Yellow
    }
}
