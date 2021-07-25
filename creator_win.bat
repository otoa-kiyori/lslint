@echo off

rem :: Check for Visual Studio
reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.14.0" >> nul 2>&1
if not errorlevel 1 (  
    rem :: VS2015
    call "C:\Program Files (x86)\Microsoft Visual studio 14.0\VC\vcvarsall.bat" x86
) else (
    reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.15.0" >> nul 2>&1
    if not errorlevel 1 ( 
        rem :: VS2017
        rem :: NOTE: The instructions contained in the NMakefile are no longer necessary with this method.
        pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\"
        call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
        popd
    ) else (
        echo You do not appear to have Visual Studio 2015 or 2017 installed.
        exit /b 1
    )
) 

if not exist C:\flexandbison\ ( echo "You need to have the Flex and Bison Packages, please see documentation." && exit /b 1 )

set PATH=%PATH%;C:\flexandbison
nmake /F NMakefile
mkdir binary\windows32\
move lslint.exe binary\windows32\
nmake /F NMakefile clean
