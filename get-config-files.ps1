$files = @()

foreach ($path in git ls-files -cmo --exclude-standard) {
    if (-not ($path -like "config/*")) { continue }

    $files += $path
}

return $files
