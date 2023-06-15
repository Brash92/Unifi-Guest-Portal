$ContentType = "application/json"
$sites = ("<comma separated siteID's>")


function API-Login{
	# Perform login authentication, saving the cookies into the websession called "session"
	$LoginBody = "{""username"":""<username>"",""password"":""<password>""}"
	$ContentType = "application/json"
	$response = Invoke-WebRequest -Uri "https://<controller URL>:8443/api/login" -Method Post -ContentType $ContentType -Body $LoginBody -SessionVariable session
	
	# Validate login using response
	return $session
}


function API-Logout{
	# Logout of the API
	$response = Invoke-WebRequest -Uri "https://<controller URL>:8443/api/logout" -Method Post -ContentType $ContentType -SessionVariable session
    return $response
}

Function Get-Guests{


	$ListGuestsURLPart1 = "https://<controller URL>:8443/api/s/"
	$ListGuestsURLPart2 = "/stat/guest"

	# Get all guests
	$JSONresponse = Invoke-WebRequest -Uri "$ListGuestsURLPart1$siteID$ListGuestsURLPart2" -Method Get -ContentType $ContentType -WebSession $session

	If($JSONResponse)
	{ 
		# Manually extend and then disconnect each guest.
        # This removes the lockout period thereby allowing all users access at the start of the next day
		$data = ConvertFrom-Json $JSONResponse
		foreach ($i in $data.data)
		{
            Extend-Guest
            Disconnect-Guest
            Write-Host "Disconnected mac" $i.mac
		}
	}
}


Function Disconnect-Guest{

	
	$DisconnectGuestURLPart1 = "https://<controller URL>:8443/api/s/"
	$DisconnectGuestURLPart2 = "/cmd/stamgr"
	$JSONBody = "{""cmd"": ""unauthorize-guest"", ""mac"": """+$i.mac+"""}" 
    
	$Disconnectresponse = Invoke-WebRequest -Uri "$DisconnectGuestURLPart1$siteID$DisconnectGuestURLPart2" -Method Post -ContentType $ContentType -Body $JSONBody -WebSession $session
}

Function Extend-Guest{

	
	$ExtendGuestURLPart1 = "https://<controller URL>:8443/api/s/"
	$ExtendGuestURLPart2 = "/cmd/hotspot"
    $JSONBody = "{""cmd"": ""extend"", ""_id"": """+$i._id+"""}"
    
	$Extendresponse = Invoke-WebRequest -Uri "$ExtendGuestURLPart1$siteID$ExtendGuestURLPart2" -Method Post -ContentType $ContentType -Body $JSONBody -WebSession $session

    Write-Host $i.mac "extended"
}

$session = API-Login

foreach ($siteID in $sites)
{
	Get-Guests
}

$logoutResult = API-Logout
Write-Host $logoutResult