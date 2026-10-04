param(
    <#
        Decides what types of assets need
        to be included in the final archive.

        Can be any combination of "mod", "config"
        or "resourcepack".

        At least one type of assets must
        be selected. By default includes all.
    #>
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String[]]$Type = ("mod","config","resourcepack"),

    <#
        Output directory
    #>
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$OutDir
)

function Test-AssetType([String]$type) {
    if ($type -eq "mod") { return $true }
    if ($type -eq "config") { return $true }
    if ($type -eq "resourcepack") { return $true }

    return $false
}

function Restore-FilePath([string]$path) {
    $last_separator = $path.LastIndexOf("/")
    $parent_dir_path = $path.Substring(0, $last_separator)

    if (Test-Path "$parent_dir_path") { return }

    New-Item -Type Directory -Force "$parent_dir_path" > $null
}

$duplicate_types = $Type | Group-Object | Where-Object { $_.count -gt 1 }

if ($duplicate_types) {
    throw "Found duplicate types: $($duplicate_types.name -join ', ')"
    exit
}

if (Test-Path -Path "$OutDir") {
    throw "Output directory '$OutDir' already exists"
    exit
}

$files = @()

New-Item -Type Directory -Force "$OutDir" > $null

foreach ($option in $Type) {
    if (-not (Test-AssetType $option)) {
        throw "Type '$option' is not a valid type of assets"
        exit
    }
    switch ($option) {
        "config" {
            $paths = git ls-files | Where-Object { $_ -match "config/" }

            New-Item -Type Directory "$OutDir/config" > $null

            foreach ($path in $paths) {
                Restore-FilePath "$OutDir/$path"
                Copy-Item -LiteralPath "$path" -Destination "$OutDir/$path"

                $files += "$OutDir/$path"
            }
        }
        default {
            $dir = "${option}s"
            $paths = Get-ChildItem "$dir" -File -Name | ForEach-Object { "$dir/$_" }

            New-Item -Type Directory "$OutDir/$dir" > $null

            foreach ($path in $paths) {
                if ($path -match ".gitkeep") { continue }

                Copy-Item -LiteralPath "$path" -Destination "$OutDir/$path"

                $files += "$OutDir/$path"
            }
        }
    }
}

return $files
