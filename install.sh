#!/bin/sh
# This script is used to install the application
apt install expect git -y

# descomentar para instalar o python3-pip (para possiveis atualizações)
# apt install python3-pip -y

# clona os repositorios do github que fazem parte do projeto (dependencias)
git clone https://github.com/Gustavo404/obsidian
git clone https://github.com/Gustavo404/oxygen
git clone https://github.com/Gustavo404/tsunami