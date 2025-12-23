# test-sikuli.ps1
Write-Host "=== Testando Ambiente SikuliX ==="

# Testar Java
Write-Host "Java: " -NoNewline
java -version

# Testar Python
Write-Host "Python: " -NoNewline
python --version

# Testar Robot Framework
Write-Host "Robot Framework: " -NoNewline
python -c "import robot; print(robot.__version__)"

# Testar Sikuli Library
Write-Host "Sikuli Library: " -NoNewline
python -c "import robot.libraries.SikuliLibrary; print('OK')"

# Verificar se o JAR existe
if (Test-Path "C:\SikuliX\sikulixapi.jar") {
    Write-Host "SikuliX JAR: Encontrado" -ForegroundColor Green
} else {
    Write-Host "SikuliX JAR: Não encontrado" -ForegroundColor Red
}

Write-Host "=== Teste concluído ==="