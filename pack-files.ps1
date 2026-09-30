<#
Renames all resourcepacks that have an "invalid"
name (i.e. they have a section sign symbol
in their name)

Using 'git ls-files -z' down the line retains
proper names, but the strings are delimited with
null characters instead of newlines

This is annoying to deal with in PowerShell,
so it's easier to just rename the files
#>
foreach ($name in gci -path "resourcepacks" -filter "*§*" -name) {
    $path = "resourcepacks\$name"
    $valid_name = $name -replace "§[a-z0-9]{1}", ""

    try {
        rni -path $path -newname $valid_name -erroraction stop
    } catch {
        # Remove file with invalid name, since
        # the file with valid name is present
        ri -literalpath $path
    }
}

$mods = gci -path "mods" | % { "mods/$($_.Name)" }
$resoucepacks = gci -path "resourcepacks" | % { "resourcepacks/$($_.Name)" }

$files = $mods + $resoucepacks

# Files in git
foreach ($path in git ls-files -cmo --exclude-standard) {
    if ($path -eq ".gitignore") { continue }
    if ($path -eq ".gitattributes") { continue }
    if ($path -eq "pack-files.ps1") { continue }

    $files += $path
}

$archive_name = "NEEPMeat-Modpack"
$commit_hash = git rev-parse --short HEAD

# Append latest commit hash to archive name
if ($LASTEXITCODE -eq 0) {
    $archive_name += "_commit-${commit_hash}"
} else { $archive_name += "_dev" }

# Append minecraft version to archive name
$archive_name += "_mc-1.20.1"

# Remove old archive
if (test-path -path "$archive_name.zip") { ri -path "$archive_name.zip" }

7z.exe a -tzip "$archive_name.zip" $files
