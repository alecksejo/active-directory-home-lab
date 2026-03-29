Import-Module ActiveDirectory

$users = Import-Csv "C:\Setup\new_hires.csv"
$log = "C:\Setup\UserCreationLog.txt"
$password = ConvertTo-SecureString "Password@1234" -AsPlainText -Force

foreach ($u in $users) {
    $username = ($u.FirstName[0] + $u.LastName).ToLower()
    $displayName = "$($u.FirstName) $($u.LastName)"

    if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
        Add-Content -Path $log -Value "SKIPPED: $username already exists"
    } else {
        try {
            New-ADUser -SamAccountName $username `
                       -UserPrincipalName "$username@alecktech.local" `
                       -Name $displayName `
                       -GivenName $u.FirstName `
                       -Surname $u.LastName `
                       -Department $u.Department `
                       -Title $u.Title `
                       -Path "OU=_Standard_Users,DC=alecktech,DC=local" `
                       -AccountPassword $password `
                       -ChangePasswordAtLogon $true `
                       -Enabled $true

            $groupMap = @{
                "Finance" = "Finance_Access"
                "HR" = "HR_Access"
                "ITSupport" = "ITSupport"
            }

            Add-ADGroupMember -Identity $groupMap[$u.Department] -Members $username
            Add-Content -Path $log -Value "CREATED: $username ($($u.Department))"
        } catch {
            Add-Content -Path $log -Value "ERROR: $username - $_"
        }
    }
}

Write-Host "Done! Results in $log"