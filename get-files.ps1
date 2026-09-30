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
        rni -literalpath $path -newname $valid_name -erroraction stop
    } catch {
        # Remove file with invalid name, since
        # the file with valid name is present
        ri -literalpath $path
    }
}

$configs = &"./get-config-files.ps1"
$mods = gci -path "mods" | % { "mods/$($_.Name)" }
$resoucepacks = gci -path "resourcepacks" | % { "resourcepacks/$($_.Name)" }

return $configs + $mods + $resoucepacks
