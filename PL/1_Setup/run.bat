@echo off
cd /d "%~dp0"

echo ----------------------------------------------------------------------
echo Bridging Workspace to Engine: ..\..\..\SWAT-Workflow-R
echo ----------------------------------------------------------------------

:: 1. Define Engine and Workspace Paths
set "ENGINE_DIR=%~dp0..\..\..\SWAT-Workflow-R"
set "PORTABLE_RSTUDIO=%ENGINE_DIR%\RStudio-Portable\rstudio.exe"
set "PORTABLE_R_EXE=%ENGINE_DIR%\R-Portable\bin\x64\R.exe"
set "RENV_LIB_DIR=%ENGINE_DIR%\renv\library"

:: 2. Cleanup local folder (Safe)
if exist ".Rhistory"    del /f /q ".Rhistory"
if exist "*.Rdata"      del /f /q "*.Rdata"
if exist ".Rproj.user"  rmdir /s /q ".Rproj.user"

:: 3. VERIFY ENGINE PATHS & VERSION
if not exist "%PORTABLE_RSTUDIO%" (
    echo [ERROR] RStudio not found! Check ENGINE_DIR: %ENGINE_DIR%
    pause & exit /b
)

:: Verify RStudio Version
for /f "usebackq tokens=1" %%v in (`powershell -NoProfile -Command "(Get-Item '%PORTABLE_RSTUDIO%').VersionInfo.ProductVersion"`) do set "DETECTED_RSTUDIO=%%v"
if not "%DETECTED_RSTUDIO%"=="2026.05.0+218" (
    echo [WARNING] Mismatched RStudio version! Expected: 2026.05.0+218. Found: %DETECTED_RSTUDIO%
    pause & exit /b
)

:: Verify R Engine Version
"%PORTABLE_R_EXE%" --version > "%TEMP%\r_ver.txt" 2>&1
for /f "tokens=3" %%r in ('findstr /C:"R version" "%TEMP%\r_ver.txt"') do set "DETECTED_R=%%r"
del /f /q "%TEMP%\r_ver.txt"
if not "%DETECTED_R%"=="4.5.1" (
    echo [WARNING] Mismatched R Engine! Expected: 4.5.1. Found: %DETECTED_R%
    pause & exit /b
)

echo [SUCCESS] Engine and Environment Verified.

:: 4. SET ENVIRONMENT VARIABLES
set "R_HOME=%ENGINE_DIR%\R-Portable"
set "PATH=%R_HOME%\bin\x64;%PATH%"
set "RSTUDIO_WHICH_R=%PORTABLE_R_EXE%"
set "RENV_PATHS_LIBRARY=%RENV_LIB_DIR%"
set "R_LIBS_USER=%RENV_LIB_DIR%"
set "RENV_CONFIG_SANDBOX_ENABLED=false"

:: 5. FORCE SPATIAL LIBRARIES
set "PROJ_LIB=%RENV_LIB_DIR%\sf\proj"
set "GDAL_DATA=%RENV_LIB_DIR%\sf\gdal"

:: 6. Launch RStudio
echo Launching Workflow...
start "" "%PORTABLE_RSTUDIO%" setup_workflow.R