# load_env.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*#') { return }      # skip comment lines
    if ($_ -match '^\s*$') { return }      # skip empty lines
    if ($_ -match '^([^=]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim().Trim('"')
        $value = $value -replace '\s+#.*$', ''   # strip inline comments
        $value = $value.Trim()
        [System.Environment]::SetEnvironmentVariable($key, $value, 'Process')
        Write-Host "OK: $key = $value"     # show value so you can verify
    }
}
Write-Host ""
Write-Host "All environment variables loaded"
Write-Host "Next: dbt debug --target dev"