$archive_name = & "./gen-archive-name.ps1"
$templates_dir = "templates/mrpack"
$templates = ("modrinth.index.json")

& "./copy-assets.ps1" -Type "config" -OutDir "tmp/overrides"

foreach ($name in $templates) {
    Copy-Item -LiteralPath "$templates_dir/$name" -Destination "tmp/$name"
}

7z a -tzip "dist/$archive_name.mrpack" "./tmp/*"

Remove-Item -Recurse -Force "tmp"
