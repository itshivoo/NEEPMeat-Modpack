$archive_name = "NEEPMeat-Modpack"
$commit_hash = git rev-parse --short HEAD

# Append latest commit hash to archive name
if ($LASTEXITCODE -eq 0) {
    $archive_name += "_commit-${commit_hash}"
} else { $archive_name += "_dev" }

# Append minecraft version to archive name
$archive_name += "_mc-1.20.1"

return $archive_name
