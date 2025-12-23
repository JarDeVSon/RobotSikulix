# setup-runner.ps1
param(
    [string]$GitHubRepo,
    [string]$GitHubToken
)

Write-Host "=== Configuração de Runner GitHub Actions para SikuliX ===" -ForegroundColor Cyan

# 1. Instalar Chocolatey
Write-Host "Instalando Chocolatey..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Instalar Java
Write-Host "Instalando Java..." -ForegroundColor Yellow
choco install adoptopenjdk11 -y --force

# 3. Instalar Python
Write-Host "Instalando Python..." -ForegroundColor Yellow
choco install python -y --force

# 4. Instalar Git (necessário para checkout)
choco install git -y --force

# 5. Configurar variáveis de ambiente
Write-Host "Configurando variáveis de ambiente..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\AdoptOpenJDK\jdk-11.0.11.9-hotspot", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Program Files\AdoptOpenJDK\jdk-11.0.11.9-hotspot\bin", "Machine")

# 6. Instalar dependências Python
Write-Host "Instalando dependências Python..." -ForegroundColor Yellow
python -m pip install --upgrade pip
pip install jpype1==1.6.0 --only-binary :all:
pip install robotframework robotframework-sikulixlibrary selenium requests

# 7. Instalar SikuliX
Write-Host "Instalando SikuliX..." -ForegroundColor Yellow
$sikuliDir = "C:\SikuliX"
New-Item -ItemType Directory -Force -Path $sikuliDir

$sikuliUrl = "https://launchpad.net/sikuli/sikulix/2.0.5/+download/sikulixapi-2.0.5.jar"
$sikuliJar = "$sikuliDir\sikulixapi.jar"

Invoke-WebRequest -Uri $sikuliUrl -OutFile $sikuliJar

# 8. Configurar GitHub Actions Runner
Write-Host "Configurando GitHub Actions Runner..." -ForegroundColor Yellow
if (-not $GitHubRepo -or -not $GitHubToken) {
    Write-Host "Aviso: Parâmetros de repo/token não fornecidos. Configure manualmente." -ForegroundColor Red
    Write-Host "Execute: .\config.cmd --url https://github.com/seu-usuario/repo --token SEU_TOKEN" -ForegroundColor Yellow
} else {
    # Download do runner
    $version = "2.315.0"
    $runnerDir = "C:\actions-runner"
    $runnerUrl = "https://github.com/actions/runner/releases/download/v$version/actions-runner-win-x64-$version.zip"
    
    New-Item -ItemType Directory -Force -Path $runnerDir
    Invoke-WebRequest -Uri $runnerUrl -OutFile "$env:TEMP\runner.zip"
    Expand-Archive -Path "$env:TEMP\runner.zip" -DestinationPath $runnerDir -Force
    
    cd $runnerDir
    .\config.cmd --url $GitHubRepo --token $GitHubToken --name "Windows-Sikuli-Runner" --labels "windows,sikuli,self-hosted" --unattended
}

# 9. Criar scripts auxiliares
Write-Host "Criando scripts auxiliares..." -ForegroundColor Yellow
$scriptsDir = "C:\Scripts"
New-Item -ItemType Directory -Force -Path $scriptsDir

# Script para iniciar SikuliX Server
$sikuliStartScript = @'
@echo off
echo Iniciando SikuliX Server...
"C:\Program Files\AdoptOpenJDK\jdk-11.0.11.9-hotspot\bin\java.exe" -jar "C:\SikuliX\sikulixapi.jar" -r -s
pause
'@

$sikuliStartScript | Out-File -FilePath "$scriptsDir\start-sikuli-server.bat" -Encoding ASCII

# Script para parar SikuliX Server
$sikuliStopScript = @'
@echo off
echo Parando SikuliX Server...
taskkill /F /IM java.exe /FI "WINDOWTITLE eq SikuliX*" 2>nul
echo Servidor parado.
pause
'@

$sikuliStopScript | Out-File -FilePath "$scriptsDir\stop-sikuli-server.bat" -Encoding ASCII

Write-Host "=== Configuração concluída! ===" -ForegroundColor Green
Write-Host "Runner configurado em: C:\actions-runner" -ForegroundColor Cyan
Write-Host "SikuliX instalado em: C:\SikuliX" -ForegroundColor Cyan
Write-Host "Scripts auxiliares em: C:\Scripts" -ForegroundColor Cyan