#!/usr/bin/env bash

# Função para mostrar mensagens coloridas
function color_message() {
  local color=$1
  local message=$2
  case $color in
    "red")
      echo -e "\e[91m$message\e[0m"
      ;;
    "green")
      echo -e "\e[92m$message\e[0m"
      ;;
    "blue")
      echo -e "\e[94m$message\e[0m"
      ;;
    "yellow")
      echo -e "\e[93m$message\e[0m"
      ;;
    *)
      echo "$message"
      ;;
  esac
}

# Função para instalar as dependências do projeto
instalar_dependencias() {
  clear
  color_message "blue" "Iniciando instalação de dependências..."
  sleep 0.5
  color_message "blue" "Instalando pacotes necessários..."
  sleep 0.5
  apt install expect git dos2unix -y > /dev/null 2>&1
  color_message "green" "Pacotes instalados com sucesso!"
  sleep 0.5
  color_message "blue" "Clonando repositórios do GitHub..."
  git clone https://github.com/Gustavo404/obsidian > /dev/null 2>&1
  color_message "green" "Repositório 'obsidian' clonado com sucesso!"
  git clone https://github.com/Gustavo404/oxygen > /dev/null 2>&1
  color_message "green" "Repositório 'oxygen' clonado com sucesso!"
  git clone https://github.com/Gustavo404/tsunami > /dev/null 2>&1
  color_message "green" "Repositório 'tsunami' clonado com sucesso!"
  sleep 0.5
  color_message "blue" "Convertendo arquivos para formato Unix..."
  sleep 0.5
  # dos2unix * > /dev/null 2>&1
  color_message "green" "Arquivos convertidos com sucesso!"
  sleep 1
  color_message "green" "Instalação de dependências concluída com sucesso!"
}

# Função para reinstalar as dependências do projeto
reinstalar_dependencias() {
  clear
  color_message "blue" "Iniciando reinstalação de dependências..."
  sleep 0.5
  color_message "blue" "Removendo repositórios existentes..."
  sleep 0.5
  rm -rf obsidian oxygen tsunami > /dev/null 2>&1
  color_message "green" "Repositórios removidos com sucesso!"
  sleep 1
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
      color_message "red" "Uso: $0 [-i] [-r]" >&2
      exit 1
      ;;
  esac
done

# Finalização do script
clear
color_message "green" "Script finalizado com sucesso!"
sleep 1