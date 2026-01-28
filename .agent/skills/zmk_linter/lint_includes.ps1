# ZMK Include Linter Script

$configDir = Join-Path (Get-Location) "config"
if (!(Test-Path $configDir)) {
    Write-Warning "Config directory not found at $configDir"
    return
}

$files = @(Get-ChildItem -Path $configDir -Filter *.keymap -Recurse)
$files += Get-ChildItem -Path $configDir -Filter *.dtsi -Recurse

if ($files.Count -eq 0) {
    Write-Host "No ZMK configuration files found."
    return
}

$hadError = $false

foreach ($file in $files) {
    Write-Host "Checking $($file.FullName)..." -ForegroundColor Cyan
    $content = Get-Content $file.FullName
    $lineNum = 0
    foreach ($line in $content) {
        $lineNum++
        if ($line -match '#include\s+["<]([^">]+)[">]') {
            $includePath = $Matches[1]
            $isLocal = $line -match '"'
            
            if ($isLocal) {
                $checkPath = Join-Path $file.Directory.FullName $includePath
                if (!(Test-Path $checkPath)) {
                    Write-Error "[$($file.Name):$lineNum] Local include not found: $includePath"
                    $hadError = $true
                }
            }
            else {
                # For system includes, we just check if it's a known ZMK header pattern
                if ($includePath -notmatch '^dt-bindings/|^behaviors\.dtsi$|^zmk/|^dt-bindings/zmk/') {
                    Write-Warning "[$($file.Name):$lineNum] Unusual system include: <$includePath>"
                }
            }
        }
        
        # Heuristic: Check for mouse bindings without mouse.h
        if ($line -match '&mkp\s+') {
            $fullContent = $content -join "`n"
            if ($fullContent -notmatch 'dt-bindings/zmk/mouse\.h') {
                Write-Error "[$($file.Name):$lineNum] Mouse binding used but <dt-bindings/zmk/mouse.h> is not included."
                $hadError = $true
            }
        }
    }
}

if ($hadError) {
    Write-Host "Linter finished with errors." -ForegroundColor Red
    exit 1
}
else {
    Write-Host "Linter finished successfully." -ForegroundColor Green
    exit 0
}
