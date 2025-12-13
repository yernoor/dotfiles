# Windows Powershell Customization

## 1. Install oh-my-posh

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget
```

## 2. Customize config

```powershell
New-Item -Path $profile.CurrentUserAllHosts -Type File -Force
```

## 3. Copy [config](profile.ps1) contents to profile.ps1
