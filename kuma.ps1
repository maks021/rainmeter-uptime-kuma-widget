$BaseUrl = "http://192.168.50.52:3001"
$Slug    = "maks021"
$OutFile = Join-Path $PSScriptRoot "kuma.txt"

try {
    $page = Invoke-RestMethod -Uri "$BaseUrl/api/status-page/$Slug" -TimeoutSec 10
    $hb   = Invoke-RestMethod -Uri "$BaseUrl/api/status-page/heartbeat/$Slug" -TimeoutSec 10

    $lines = New-Object System.Collections.Generic.List[string]

    foreach ($group in $page.publicGroupList) {
        foreach ($mon in $group.monitorList) {
            $id = [string]$mon.id
            $entries = $hb.heartbeatList.$id

            $last = $null
            if ($entries -and $entries.Count -gt 0) {
                $last = $entries[-1]
            }

            $statusText = "UNKNOWN"
            if ($null -ne $last) {
                switch ([int]$last.status) {
                    1 { $statusText = "OK" }
                    0 { $statusText = "DOWN" }
                    2 { $statusText = "WAIT" }
                    default { $statusText = "   OTHER" }
                }
            }

          $name = [string]$mon.name
if ($name.Length -gt 24) {
    $name = $name.Substring(0,24)
}

$line = "{0,-19} {1}" -f $name, $statusText
$lines.Add($line)
        }
    }

    if ($lines.Count -eq 0) {
        $lines.Add("Nema monitora.")
    }

    [System.IO.File]::WriteAllLines($OutFile, $lines, [System.Text.Encoding]::ASCII)
}
catch {
    [System.IO.File]::WriteAllText($OutFile, ("Greska: " + $_.Exception.Message), [System.Text.Encoding]::ASCII)
}