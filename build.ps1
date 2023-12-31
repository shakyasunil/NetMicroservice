$currentPath = Get-Location
$perent_folder_name="parent"
Write-Host "Our current Working Directory is $currentPath"
$build_path="$currentPath\output"
New-Item -Path "$currentPath" -Name "output" -ItemType Directory
$files = Get-ChildItem "$currentPath\$perent_folder_name\services"
foreach ($f in $files){
    $service_path = $f.FullName 
    $service_name = $f.Name 
    $app_version=Get-ChildItem $service_path -directory | Where{$_.name -match "(.*)$"}  | ForEach{[pscustomobject]@{'base'=$matches[1]}} | group base | ForEach{($_.Name)} | Select -Last 1
    $service_build_path="$build_path\services\$service_name\$app_version"
    Write-Host "service_path is $service_path"
    cd $service_path\$app_version
    dotnet restore
    New-Item -Path "$service_build_path" -ItemType Directory -Force
    Write-Host "service_build_path is $service_build_path"
    Get-ChildItem "$service_build_path"
    dotnet build --configuration Release --no-restore  --output $service_build_path
}
Copy-Item -Path (Get-Item -Path "$currentPath\$perent_folder_name\*" -Exclude ('services')).FullName -Destination $build_path -Recurse -Force

Compress-Archive $build_path\* $currentPath\build.zip