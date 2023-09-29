#!/bin/bash

install() {
    echo "Instalando..."
    apt install expect git -y
    # apt install python3-pip -y
    # clona os repositorios do github que fazem parte do projeto (dependencias)
    git clone https://github.com/Gustavo404/obsidian
    git clone https://github.com/Gustavo404/oxygen
    git clone https://github.com/Gustavo404/tsunami
}

reistall() {
    echo "Re-instalando..."
    rm -rf obsidian oxygen tsunami
    install()
}

while getopts "ir" opt; do
  case "$opt" in
    i)
      install
      ;;
    r)
      reistall
      ;;
    \?)
      echo "Uso: $0 [-i] [-r]" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ "$#" -ne 0 ]; then
  echo "Argumentos inválidos."
  exit 1
fi