function Get-AzureLicenses {
    try{$AzureADCheck = (Get-AzureADTenantDetail).DirSyncEnabled}
    catch{}
    If ($AzureADCheck) {
    Write-Debug "Connection to Azure established"
    $connect = $true}
    else{
    return "No Azure Connect - Please connect to your Azure Tenant"
    $connect = $false
    }
    
    if ($connect){
    $Sku = @{
        "AAD_BASIC"							     = "Azure Active Directory Basic"
        "RMS_S_ENTERPRISE"					     = "Azure Active Directory Rights Management"
        "AAD_PREMIUM"						     = "Azure Active Directory Premium P1"
        "AAD_PREMIUM_P2"						 = "Azure Active Directory Premium P2"
        "MFA_PREMIUM"						     = "Azure Multi-Factor Authentication"
        "RIGHTSMANAGEMENT"					     = "Azure Information Protcetion Plan 1"
        "O365_BUSINESS_ESSENTIALS"			     = "Office 365 Business Essentials"
        "O365_BUSINESS_PREMIUM"				     = "Microsoft 365 Business Standard"
        "ADALLOM_O365"                           = "Office 365 Cloud App Security"
        "ADALLOM_S_DISCOVERY"					 = "Unknown"
        "EXCHANGESTANDARD"					     = "Exchange Online (Plan 1)"
        "STANDARDPACK"						     = "Enterprise Plan E1"
        "STANDARDWOFFPACK"					     = "Office 365 (Plan E2)"
        "ENTERPRISEPACK"						 = "Office 365 E3"
        "ENTERPRISEPACKLRG"					     = "Enterprise Plan E3"
        "ENTERPRISEWITHSCAL"					 = "Enterprise Plan E4"
        "DESKLESSPACK"						     = "Office 365 (Plan K1)"
        "DESKLESSWOFFPACK"					     = "Office 365 (Plan K2)"
        "LITEPACK"							     = "Office 365 (Plan P1)"
        "STANDARDPACK_STUDENT"				     = "Office 365 (Plan A1) for Students"
        "STANDARDWOFFPACKPACK_STUDENT"		     = "Office 365 (Plan A2) for Students"
        "ENTERPRISEPACK_STUDENT"				 = "Office 365 (Plan A3) for Students"
        "ENTERPRISEWITHSCAL_STUDENT"			 = "Office 365 (Plan A4) for Students"
        "STANDARDPACK_FACULTY"				     = "Office 365 (Plan A1) for Faculty"
        "STANDARDWOFFPACKPACK_FACULTY"		     = "Office 365 (Plan A2) for Faculty"
        "ENTERPRISEPACK_FACULTY"				 = "Office 365 (Plan A3) for Faculty"
        "ENTERPRISEWITHSCAL_FACULTY"			 = "Office 365 (Plan A4) for Faculty"
        "ENTERPRISEPACK_B_PILOT"				 = "Office 365 (Enterprise Preview)"
        "STANDARD_B_PILOT"					     = "Office 365 (Small Business Preview)"
        "VISIOCLIENT"						     = "Visio Plan 2"
        "POWER_BI_ADDON"						 = "Office 365 Power BI Addon"
        "POWER_BI_INDIVIDUAL_USE"			     = "Power BI Individual User"
        "POWER_BI_STANDALONE"				     = "Power BI Stand Alone"
        "POWER_BI_STANDARD"					     = "Power BI (free)"
        "PROJECTESSENTIALS"					     = "Project Lite"
        "PROJECTCLIENT"						     = "Project Professional"
        "PROJECTONLINE_PLAN_1"				     = "Project Online"
        "PROJECTONLINE_PLAN_2"				     = "Project Online and PRO"
        "ProjectPremium"						 = "Project Online Premium"
        "ECAL_SERVICES"						     = "ECAL"
        "EMS"								     = "Enterprise Mobility Suite"
        "RIGHTSMANAGEMENT_ADHOC"				 = "Windows Azure Rights Management"
        "MCOMEETADV"							 = "Microsoft 365 Audio Conferencing"
        "SHAREPOINTSTORAGE"					     = "SharePoint storage"
        "PLANNERSTANDALONE"					     = "Planner Standalone"
        "CRMIUR"								 = "CMRIUR"
        "BI_AZURE_P1"						     = "Power BI Reporting and Analytics"
        "INTUNE_A"							     = "Intune"
        "PROJECTWORKMANAGEMENT"				     = "Office 365 Planner Preview"
        "ATP_ENTERPRISE"						 = "Exchange Online Advanced Threat Protection"
        "EQUIVIO_ANALYTICS"					     = "Office 365 Advanced eDiscovery"
        "STANDARDPACK_GOV"					     = "Microsoft Office 365 (Plan G1) for Government"
        "STANDARDWOFFPACK_GOV"				     = "Microsoft Office 365 (Plan G2) for Government"
        "ENTERPRISEPACK_GOV"					 = "Microsoft Office 365 (Plan G3) for Government"
        "ENTERPRISEWITHSCAL_GOV"				 = "Microsoft Office 365 (Plan G4) for Government"
        "DESKLESSPACK_GOV"					     = "Microsoft Office 365 (Plan K1) for Government"
        "ESKLESSWOFFPACK_GOV"				     = "Microsoft Office 365 (Plan K2) for Government"
        "EXCHANGESTANDARD_GOV"				     = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
        "EXCHANGEENTERPRISE_GOV"				 = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
        "SHAREPOINTDESKLESS_GOV"				 = "SharePoint Online Kiosk"
        "EXCHANGE_S_DESKLESS_GOV"			     = "Exchange Kiosk"
        "RMS_S_ENTERPRISE_GOV"				     = "Windows Azure Active Directory Rights Management"
        "OFFICESUBSCRIPTION_GOV"				 = "Office ProPlus"
        "MCOSTANDARD_GOV"					     = "Lync Plan 2G"
        "SHAREPOINTWAC_GOV"					     = "Office Online for Government"
        "SHAREPOINTENTERPRISE_GOV"			     = "SharePoint Plan 2G"
        "EXCHANGE_S_ENTERPRISE_GOV"			     = "Exchange Plan 2G"
        "EXCHANGE_S_ARCHIVE_ADDON_GOV"		     = "Exchange Online Archiving"
        "EXCHANGE_S_DESKLESS"				     = "Exchange Online Kiosk"
        "SHAREPOINTDESKLESS"					 = "SharePoint Online Kiosk"
        "SHAREPOINTWAC"						     = "Office Online"
        "YAMMER_ENTERPRISE"					     = "Yammer for the Starship Enterprise"
        "EXCHANGE_L_STANDARD"				     = "Exchange Online (Plan 1)"
        "MCOLITE"							     = "Lync Online (Plan 1)"
        "SHAREPOINTLITE"						 = "SharePoint Online (Plan 1)"
        "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ"	 = "Office ProPlus"
        "EXCHANGE_S_STANDARD_MIDMARKET"		     = "Exchange Online (Plan 1)"
        "MCOSTANDARD_MIDMARKET"				     = "Lync Online (Plan 1)"
        "SHAREPOINTENTERPRISE_MIDMARKET"		 = "SharePoint Online (Plan 1)"
        "OFFICESUBSCRIPTION"					 = "Office ProPlus"
        "YAMMER_MIDSIZE"						 = "Yammer"
        "DYN365_ENTERPRISE_PLAN1"			     = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
        "ENTERPRISEPREMIUM_NOPSTNCONF"		     = "Enterprise E5 (without Audio Conferencing)"
        "ENTERPRISEPREMIUM"					     = "Enterprise E5 (with Audio Conferencing)"
        "MCOSTANDARD"						     = "Skype for Business Online Standalone Plan 2"
        "PROJECT_MADEIRA_PREVIEW_IW_SKU"		 = "Dynamics 365 for Financials for IWs"
        "STANDARDWOFFPACK_IW_STUDENT"		     = "Office 365 Education for Students"
        "STANDARDWOFFPACK_IW_FACULTY"		     = "Office 365 Education for Faculty"
        "EOP_ENTERPRISE_FACULTY"				 = "Exchange Online Protection for Faculty"
        "EXCHANGESTANDARD_STUDENT"			     = "Exchange Online (Plan 1) for Students"
        "OFFICESUBSCRIPTION_STUDENT"			 = "Office ProPlus Student Benefit"
        "STANDARDWOFFPACK_FACULTY"			     = "Office 365 Education E1 for Faculty"
        "STANDARDWOFFPACK_STUDENT"			     = "Microsoft Office 365 (Plan A2) for Students"
        "DYN365_FINANCIALS_BUSINESS_SKU"		 = "Dynamics 365 for Financials Business Edition"
        "DYN365_FINANCIALS_TEAM_MEMBERS_SKU"	 = "Dynamics 365 for Team Members Business Edition"
        "FLOW_FREE"							     = "Microsoft Flow Free"
        "POWER_BI_PRO"						     = "Power BI Pro"
        "O365_BUSINESS"						     = "Office 365 Business"
        "DYN365_ENTERPRISE_SALES"			     = "Dynamics Office 365 Enterprise Sales"
        "PROJECTPROFESSIONAL"				     = "Project Plan 3"
        "VISIOONLINE_PLAN1"					     = "Visio Plan 1"
        "EXCHANGEENTERPRISE"					 = "Exchange Online (Plan 2)"
        "DYN365_ENTERPRISE_P1_IW"			     = "Dynamics 365 P1 Trial for Information Workers"
        "DYN365_ENTERPRISE_TEAM_MEMBERS"		 = "Dynamics 365 For Team Members Enterprise Edition"
        "CRMSTANDARD"						     = "Microsoft Dynamics CRM Online Professional"
        "EXCHANGEARCHIVE_ADDON"				     = "Exchange Online Archiving For Exchange Online"
        "EXCHANGEDESKLESS"					     = "Exchange Online Kiosk"
        "SPZA_IW"							     = "App Connect"
        "SPB"                                    = "Microsoft 365 Business Premium"
        "AAD_SMB"								 = ""
        "BPOS_S_TODO_1"							 = "Microsoft To Do"
        "DESKLESS"								 = ""
        "EXCHANGE_S_ARCHIVE_ADDON"				 = ""
        "EXCHANGE_S_STANDARD"					 = ""
        "INTUNE_SMBIZ"							 = ""
        "WINBIZ"								 = "Windows 10 Business"
        "SPE_F1"								 = "Microsoft 365 F1"
        "SPE_E3"								 = "Microsoft 365 E3"
        "SPE_E5"								 = "Microsoft 365 E5"
        "TEAMS1"                                 = "Microsoft Teams"
        "MCOPSTN1"								 = "Domestic Calling Plan"
        "MCOPSTNC"								 = "Communication Credits"
        "MCOPSTN2"								 = "Domestic and International Calling Plan"
        "MCOEV"								     = "Microsoft 365 Phone System"
        "PHONESYSTEM_VIRTUALUSER"	    	     = "Microsoft 365 Phone System - Virtual User"
        "MCOMEETACPEA"							 = "Audio Conferencing Pay-Per-Minute"
        "POWERAPPS_VIRAL"						 = "Microsoft PowerApps Plan 2 Trial"
        "SMB_APPS"           					 = "Business Apps (free)"
        "UNIVERSAL_PRINT_M365" 					 = "Universal Print"
        "Forms_Pro_USL" 					     = "Dynamics 365 Customer Voice USL"
        "MICROSOFT_BUSINESS_CENTER"              = "Microsoft Business Center"
        "WINDOWS_STORE" 				     	 = "Microsoft Store"
        "POWERAUTOMATE_ATTENDED_RPA" 	     	 = "Power Automate per user with attended RPA plan"
        "FLOW_PER_USER" 	                 	 = "Power Automate per user plan"
        "MEETING_ROOM" 	                 	     = "Microsoft Teams Rooms Standard"
        "Forms_Pro_AddOn" 	                     = "Forms Pro"
    
    
    }
    
    $LicenceStatus = Get-AzureADSubscribedSku | Select SkuPartNumber, ConsumedUnits -ExpandProperty PrepaidUnits
        foreach ( $Licence in $LicenceStatus) {
            Foreach ($Key in ($Sku.GetEnumerator() | Where-Object {$_.Name -eq $Licence.SkuPartNumber}))
            {$Value =  $Key.Value}
            If (!($Value)) {
            $Value = $Licence.SkuPartNumber}
            $Licence | Add-Member -NotePropertyName "Name" -NotePropertyValue $Value
            $Licence | Add-Member -NotePropertyName "Free" -NotePropertyValue $($Licence.Enabled - $Licence.ConsumedUnits) 
            try {Remove-Variable Value} catch{}
            }
    return $LicenceStatus # | select Name, @{N="Zugewiesen";E={$_.ConsumedUnits}},  @{N="Frei";E={$($_.Free)}},  @{N="Gesamt";E={$_.Enabled}} | Sort-Object Name | Format-Table
    }
}
    