$CurrentDirectory = Get-Location

Get-ChildItem $CurrentDirectory -directory | Where{$_.name -match "(.*)$"}  | ForEach{[pscustomobject]@{'base'=$matches[1]}} | group base | ForEach{($_.Name)} | Select -Last 1



$version=Get-ChildItem $CurrentDirectory -directory | Where{$_.name -match "(.*)$"} | ForEach{[pscustomobject]@{'base'=$matches[1];'version'=$matches[2]}} | group base | ForEach{($_.Name)+($_.group|select -last 1 -ExpandProperty version)} | Select -Last 1
echo $version
