# Base directory for Topics
$baseDir = "../../Demo_CE/Topics"

# Loop through each topic folder
Get-ChildItem -Path $baseDir -Directory | ForEach-Object {
    $topicDir = $_.FullName
    $prevRowFile = Join-Path -Path $topicDir -ChildPath "prev_row.txt"
    
    # Check if prev_row.txt exists and clear its contents
    if (Test-Path -Path $prevRowFile) {
        Clear-Content -Path $prevRowFile
        Write-Output "Cleared $prevRowFile"
    }
}