if (test-path -path "tmp") { rmdir -recurse -force -path "tmp" }

$root_dir = "tmp/NEEPMeat Modpack"
$templates_dir = "templates/tlauncher"
$manifest_files = ("NEEPMeat Modpack.json", "TLauncherAdditional.json")

ni -type directory -path $root_dir -force

foreach ($file in $manifest_files) {
    copy -literalpath "$templates_dir/$file" -destination "$root_dir/$file"
}

$assets_dir = $root_dir
$assets = &"./get-files.ps1"

ni -type directory -path "$assets_dir/mods"
ni -type directory -path "$assets_dir/config"
ni -type directory -path "$assets_dir/resourcepacks"

foreach ($path in $assets) {
    copy -literalpath $path -destination "$assets_dir/$path"
}

$archive_name = &"./gen-archive-name.ps1"

7z a -tzip "${archive_name}_TL.zip" $(gci -path "tmp" | % { "$($_.FullName)" })
