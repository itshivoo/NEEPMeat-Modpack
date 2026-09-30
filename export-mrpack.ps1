if (test-path -path "tmp") { rmdir -recurse -force -path "tmp" }

$root_dir = "tmp"
$templates_dir = "templates/mrpack"
$manifest_files = ("modrinth.index.json")

ni -type directory -path $root_dir -force

foreach ($file in $manifest_files) {
    copy -literalpath "$templates_dir/$file" -destination "$root_dir/$file"
}

$assets_dir = "$root_dir/overrides"
$assets = &"./get-config-files.ps1"

ni -type directory -path "$assets_dir"
ni -type directory -path "$assets_dir/config"

foreach ($path in $assets) {
    copy -literalpath $path -destination "$assets_dir/$path"
}

$archive_name = &"./gen-archive-name.ps1"

7z a -tzip "$archive_name.mrpack" $(gci -path "tmp" | % { "$($_.FullName)" })
