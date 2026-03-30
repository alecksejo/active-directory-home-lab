# IT Runbook: User Account Management

This covers how to add a new employee to the domain and how to remove access when someone leaves.

You will need Domain Admin access on DC01 to do either of these.

/  /  /  /  /

## Adding a New Employee

1. Add the employee to the `new_hires.csv` file with their first name, last name, department, and title.
2. Open PowerShell ISE on DC01 and run the `CreateUsers.ps1` script.
3. Open `UserCreationLog.txt` in `C:\Setup` and confirm the account shows as CREATED.
4. Open Active Directory Users and Computers and verify the account is sitting in `_Standard_Users`.
5. Confirm they are in the correct security group based on their department.

/  /  /  /  /

## Removing a Terminated Employee

1. Open Active Directory Users and Computers on DC01.
2. Find the employee's account in `_Standard_Users`.
3. Right click the account and select **Disable Account**.
4. Right click again, go to **Properties**, click **Member Of**, and remove all groups except Domain Users.
5. Right click the account and select **Move** and move it to `_Terminated_Users`.
