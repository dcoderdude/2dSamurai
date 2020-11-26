@echo off
love --version
if errorlevel 9009 (
 echo No love? Trying "C:\Program Files\LOVE\love.exe"
 "C:\Program Files\LOVE\love.exe" --console . 
) else (
 love --console .
)
