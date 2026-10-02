$archive_name = & "./gen-archive-name.ps1"
$templates_dir = "templates/tlauncher"
$templates = ("NEEPMeat Modpack.json", "TLauncherAdditional.json")

& "./copy-assets.ps1" -OutDir "tmp"

foreach ($name in $templates) {
    Copy-Item -LiteralPath "$templates_dir/$name" -Destination "tmp/$name"
}

7z a -tzip "${archive_name}_TL.zip" "./tmp/*"
