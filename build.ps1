<#
        File: build.ps1
        Author: Matthias Deeg, SySS GmbH - 2021
        Version: 0.1
        Description: Build script for Invoke-LSAParse PowerShell tool
        License: BSD 3-Clause
        Required Dependencies: None
        Optional Dependencies: None
#>

$TemplateFile = "Invoke-LSAParse.ps_"
$TargetFile = "Invoke-LSAParse.ps1"
$CDBFile = "cdb.exe"
 
Write-Host "Build Invoke-LSAParse`r`n---"

# Convert cdb.exe to Base64 string
$CurrentDir = Get-Location
$CDBFileName = Join-Path -Path $CurrentDir -ChildPath $CDBFile

if (-not(Test-Path -Path $CDBFileName -PathType Leaf)) {
		Write-Host "[-] Error: Could not find the file $CDBFileName`r`n    Please download the Microsoft Console Debugger and copy the executable 'cdb.exe' to this directory"
} else {
	# Base64-encode the file content
	$CDBFileContentBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($CDBFileName))

	# build Invoke-LSAParse script with included Microsoft Console Debugger as Base64 string
	$Content = Get-Content $TemplateFile
	$Content.replace('<CDB>', $CDBFileContentBase64) | Set-Content $TargetFile
	
	Write-Host "[*] Successfully created the PowerShell script $TargetFile"
}
