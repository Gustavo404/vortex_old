cd /d "%~dp0"
attrib +h .*
attrib +h LICENSE
attrib +h *.md
attrib +h *.py
attrib +h *.bat
del /ah *.jpg > nul 2>&1

exit
