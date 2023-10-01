#!/usr/bin/env bash

# Função para instalar as dependências do projeto
instalar_dependencias() {
  echo "Instalando dependências..."
  apt install expect git -y
  # apt install python3-pip -y
  # clona os repositórios do GitHub que fazem parte do projeto (dependências)
  git clone https://github.com/Gustavo404/obsidian
  git clone https://github.com/Gustavo404/oxygen
  git clone https://github.com/Gustavo404/tsunami
}

# Função para reinstalar as dependências do projeto
reinstalar_dependencias() {
  echo "Reinstalando dependências..."
  rm -rf obsidian oxygen tsunami
  instalar_dependencias
}

# Processamento das opções da linha de comando
while getopts "ir" opt; do
  case "$opt" in
    i)
      instalar_dependencias
      ;;
    r)
      reinstalar_dependencias
      ;;
    \?)
      echo "Uso: $0 [-i] [-r]" >&2
      exit 1
      ;;
  esac
done

# Verificação de argumentos inválidos
if [ "$#" -ne 0 ]; then
  echo "Argumentos inválidos."
  exit 1
fi

# Finalização do script
echo "Script finalizado"