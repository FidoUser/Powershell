
function Get-VM-Statistic ( ){
    Param(
            $HyperV_Server = [System.Net.Dns]::GetHostByName((hostname)).HostName,
            [string] $ReportFileSet = (get-item Env:TEMP).Value + "\vm.txt",
            [int] $keepReportsCount = 30,
            [bool] $verbose = $true
    )

    $ReportFile = $ReportFileSet -replace ".txt",( "-$HyperV_Server-" + (Get-Date -UFormat "%d.%m.%Y_%H.%M.%S") +  ".txt")
    Write-Host "Write informaton to file" $ReportFile
    Get-VM -ComputerName $HyperV_Server| Out-File $ReportFile
        "==========" | Out-File $ReportFile -Append
    Get-VMReplication -ComputerName $HyperV_Server| Out-File $ReportFile -Append
    if ($verbose){
            "==========" | Out-File $ReportFile -Append
        Get-VM  -ComputerName $HyperV_Server| select -Property * |Out-File $ReportFile -Append
    }


    $Files = Get-Item -Path (($ReportFileSet -replace ".txt",  "-$HyperV_Server") + "*") |Sort-Object 

    #remove old files
    $i=0  
    foreach ($file in $Files){
        $i += 1
        if (($Files.Count - $keepReportsCount) -lt $i ){break}
        Write-Host $file
        
    }


}


#example use
Get-VM-Statistic -HyperV_Server hv01
