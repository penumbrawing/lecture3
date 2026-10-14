param([string]$Dart = 'dart')
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    New-Item -ItemType Directory -Path 'evidence' -Force | Out-Null
    function Invoke-DartCheck {
        param([string]$LogName, [string[]]$Arguments)
        $commandLine = 'dart ' + ($Arguments -join ' ')
        $commandLine | Set-Content -LiteralPath "evidence/$LogName.txt" -Encoding utf8
        & $Dart @Arguments 2>&1 | Tee-Object -FilePath "evidence/$LogName.txt" -Append
        $code = $LASTEXITCODE
        "exit_code=$code" | Add-Content -LiteralPath "evidence/$LogName.txt" -Encoding utf8
        if ($code -ne 0) { throw "$commandLine failed: exit_code=$code" }
    }
    Invoke-DartCheck -LogName 'environment' -Arguments @('--version')
    Invoke-DartCheck -LogName 'format' -Arguments @('format', 'lib', 'bin', 'test', 'examples')
    Invoke-DartCheck -LogName 'analyze' -Arguments @('analyze')
    Invoke-DartCheck -LogName 'run' -Arguments @('run')
    Invoke-DartCheck -LogName 'tests' -Arguments @('test', '--reporter', 'expanded')
    Invoke-DartCheck -LogName 'mixin-comparison' -Arguments @('run', 'examples/before_mixin.dart')
    Invoke-DartCheck -LogName 'json-diagnosis' -Arguments @('run', 'examples/diagnose_json.dart')
    'All checks completed. See evidence/*.txt.'
} finally {
    Pop-Location
}
