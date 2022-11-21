 $CMK_VERSION = "2.2.0i1"
## filename for timestamp
if ($env:MK_CONFDIR ) {
$MK_CONFDIR = $env:MK_CONFDIR
} else {
$MK_CONFDIR = "C:\Users\Nico.Dubiellak\Documents\WindowsPowerShell\Scripts\IntuneApple\Config"
}


$CONFIG_FILE="${MK_CONFDIR}\AppleCheck.config.ps1"
if (test-path -path "${CONFIG_FILE}" ) {
     . "${CONFIG_FILE}"
} else {
    exit
    echo "No Config File"
}


function Connect-MSGraphV2 { 

$connectionDetails = @{
    'TenantId'     = $TenantID
    'ClientId'     = $ClientID
    'ClientSecret' =  $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
}

$MSToken = (Get-MsalToken @connectionDetails -ErrorAction:SilentlyContinue).AccessToken 

Connect-MgGraph -AccessToken $MSToken
return $MSToken
}

Function Get-ApplePushNotificationCertificate(){

<#
.SYNOPSIS
This function is used to get applecPushcNotificationcCertificate from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets a configured apple Push Notification Certificate
.EXAMPLE
Get-ApplePushNotificationCertificate
Returns apple Push Notification Certificate configured in Intune
.NOTES
NAME: Get-ApplePushNotificationCertificate
#>

[cmdletbinding()]


$graphApiVersion = "v1.0"
$Resource = "devicemanagement/applePushNotificationCertificate"

    try {

    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get)

    }

    catch {

    $ex = $_.Exception

        if(($ex.message).contains("404")){
        
        Write-Host "Resource Not Configured" -ForegroundColor Red
        
        }

        else {

        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd();
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
        write-host

        }

    }

}

Function Get-VPPToken{

<#
.SYNOPSIS
Gets all Apple VPP Tokens
.DESCRIPTION
Gets all Apple VPP Tokens configured in the Service.
.EXAMPLE
Get-VPPToken
.NOTES
NAME: Get-VPPToken
#>

[cmdletbinding()]

Param(
[parameter(Mandatory=$false)]
[string]$tokenid
)

$graphApiVersion = "beta"
$Resource = "deviceAppManagement/vppTokens"
    
    try {
                
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        (Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get).value
            
    }
    
    catch {

    $ex = $_.Exception
    $errorResponse = $ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break

    }

} 
Function Get-DEPOnboardingSettings {

<#
.SYNOPSIS
This function retrieves the DEP onboarding settings for your tenant. DEP Onboarding settings contain information such as Token ID, which is used to sync DEP and VPP
.DESCRIPTION
The function connects to the Graph API Interface and gets a retrieves the DEP onboarding settings.
.EXAMPLE
Get-DEPOnboardingSettings
Gets all DEP Onboarding Settings for each DEP token present in the tenant
.NOTES
NAME: Get-DEPOnboardingSettings
#>
    
[cmdletbinding()]
    
Param(
[parameter(Mandatory=$false)]
[string]$tokenid
)
    
    $graphApiVersion = "beta"
    
        try {
    
                if ($tokenid){
                
                $Resource = "deviceManagement/depOnboardingSettings/$tokenid/"
                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
                (Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get)
                     
                }
    
                else {
                
                $Resource = "deviceManagement/depOnboardingSettings/"
                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
                (Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get).value
                
                }
                   
            }
        
        catch {
    
        $ex = $_.Exception
        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd();
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
        write-host
        break
    
        }
    
    } 
####################################################

#if (!(Get-Module -ListAvailable -Name MSAL.PS)) {
#Install-Module -Name MSAL.PS -Force
#}

if (!(Get-Module -ListAvailable -Name AzureAD)) {
Install-Module -Name AzureAD -Force
}

if (!(Get-Module -ListAvailable -Name PSIntuneAuth)) {
Install-Module -Name PSIntuneAuth 
}




########################

$global:authToken = Get-MSIntuneAuthToken -TenantName $TenantID -ClientID $ClientID -ClientSecret $ClientSecret 



####################################################

$APNS = Get-ApplePushNotificationCertificate
$APNS


$DateTime = ([datetimeoffset]::Parse($APNS.expirationDateTime)).DateTime.DateTime
Write-Host "Expiration Date Time:" $DateTime

$DEP = Get-DEPOnboardingSettings
$DEP

$DateTime = ([datetimeoffset]::Parse($DEP.tokenExpirationDateTime)).DateTime.DateTime
Write-Host "Expiration Date Time:" $DateTime

$VPP = Get-VPPToken
$VPP 

$DateTime = ([datetimeoffset]::Parse($VPP.expirationDateTime)).DateTime.DateTime
Write-Host "Expiration Date Time:" $DateTime
 
