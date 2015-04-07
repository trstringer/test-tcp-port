function Test-Port {
    param (
        [Parameter(Mandatory = $false)]
        [string]$HostName,

        [Parameter(Mandatory = $false)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    if (!$HostName -and !$IpAddress) {
        Write-Warning "You need to specify either hostname or IP address!!!"
        return
    }

    $IpAddresses = @()

    if ($HostName) {
        $IpAddressesFromHostName = [System.Net.Dns]::GetHostAddresses($HostName)

        foreach ($IpAddressFromHostName in $IpAddressesFromHostName) {
            "IP address retrieved :: $($IpAddressFromHostName.ToString())"
            $IpAddresses += $IpAddressFromHostName
        }
    }
    else {
        $IpAddresses += [System.Net.IPAddress]::Parse($IpAddress)
    }

    $TcpClient = New-Object System.Net.Sockets.TcpClient

    foreach ($IpAddressToTest in $IpAddresses) {
        try {
            $TcpClient.Connect($IpAddressToTest, $Port)
            if ($TcpClient.Connected) {
                "Connection successful to $($IpAddressToTest.ToString()):$Port"
            }
            else {
                "Connection unsuccessful to $($IpAddressToTest.ToString()):$Port"
            }
        }
        catch {
            "Connection unsuccessful to $($IpAddressToTest.ToString()):$Port"
        }
        finally {
            if ($TcpClient.Connected) {
                $TcpClient.Close()
            }
        }
    }
}