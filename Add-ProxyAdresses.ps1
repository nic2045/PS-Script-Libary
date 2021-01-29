Import-Module ExchangeOnlineManagement

#Verschlüsselte Credential XML Datei für PowerShell erstellen
#https://blog.andreas-schreiner.de/2018/01/16/verschluesselte-credential-xml-datei-fuer-powershell-erstellen/
$CredXML = "$env:USERPROFILE\.Azure\Credentials.xml"

#Connect & Login to ExchangeOnline (MFA)
$getsessions = Get-PSSession | Select-Object -Property State, Name
$isconnected = (@($getsessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0
If ($isconnected -ne "True") {
if (Test-Path $CredXML) {
$ConnectionCred = Import-Clixml $CredXML  -ErrorAction SilentlyContinue
} else {
$ConnectionCred = Get-Credential
}
Connect-ExchangeOnline -Credential $ConnectionCred
}



$NewProxyAdress = "goldsgymtrading.com"
#$Qi2Mailboxes = Get-Mailbox -ResultSize unlimited | where {$_.emailAddresses -like "*@qi-2.com" }

#Testing
#$Qi2Mailboxes = Get-Mailbox -ResultSize unlimited | where {$_.emailAddresses -like "*eidlich@qi-2.com" }

foreach ($Qi2Mailbox in $Qi2Mailboxes ) {
[string]$GGAdress = (($Qi2Mailbox.PrimarySmtpAddress).Split("@")[0] + "@" + $NewProxyAdress)
Set-RemoteMailbox $Qi2Mailbox.Alias -EmailAddresses @{add="smtp:$GGAdress"}
}