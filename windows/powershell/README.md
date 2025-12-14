# Windows Powershell Customization

## 1. Install pwsh.exe

```powershell
winget install Microsoft.PowerShell
```

## 2. Install oh-my-posh

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget
```

## 3. Customize config

```powershell
# Check if profile exists
$PROFILE

# This will likely show:
# C:\Users\YourUsername\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# (Note: "PowerShell" not "WindowsPowerShell")
```

if it doesn't exist:

```powershell
New-Item -Path $profile.CurrentUserAllHosts -Type File -Force
```

## 3. Copy [config](profile.ps1) contents to profile.ps1

```powershell
nvim $PROFILE
```
