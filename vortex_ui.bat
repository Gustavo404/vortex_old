cd /d "%~dp0"
attrib +h .*
attrib +h LICENSE
attrib +h *.md
attrib +h *.py
del /ah *.jpg > nul 2>&1
python ui.py
exit
