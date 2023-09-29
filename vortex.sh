#!/bin/bash

cat banner.txt
echo # pula uma linha por conta do banner
echo "Bem vindo ao Vortex"
echo # pula uma linha para ficar mais bonito

# Verifica se foram fornecidos argumentos de linha de comando
if [ $# -eq 0 ]; then
    # coleta de dados input output ip user e pass
    echo "Digite o nome do arquivo de entrada: "
    read input

    echo "Digite o nome do arquivo de saida: "
    read output

    echo "Digite o ip do servidor telnet: "
    read ip

    echo "Digite o usuario do servidor telnet: "
    read user

    echo "Digite a senha do servidor telnet: "
    read pass
else
    # Processa as opções da linha de comando
    while getopts "ip:user:pass:input:output:" opt; do
        case $opt in
            ip)
                ip="$OPTARG"
                ;;
            user)
                user="$OPTARG"
                ;;
            input)
                input="$OPTARG"
                ;;
            output)
                output="$OPTARG"
                ;;
            output)
                output="$OPTARG"
                ;;
            \?)
                echo "Opção inválida: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "A opção -$OPTARG requer um argumento." >&2
                exit 1
                ;;
        esac
    done
fi
# verifica se todas as variaveis foram preenchidas
if [ -z "$input" ] || [ -z "$output" ] || [ -z "$ip" ] || [ -z "$user" ] || [ -z "$pass" ]
then
    echo "Alguma variavel nao foi preenchida"
    exit 1
fi

# Verifica se o arquivo de entrada existe
if [ ! -f "$input" ]; then
    echo "O arquivo de entrada não existe"
    exit 1
fi

# Lê a primeira linha do arquivo
first_line=$(head -n 1 "$input")

# Expressão regular para verificar o padrão "Números Tab Números Tab Números"
pattern1="^[0-9]+\t[0-9]+\t[0-9]+$"

# Expressão regular para verificar o padrão "Números/Números/Números"
pattern2="^[0-9]+/[0-9]+/[0-9]+$"

if [[ "$first_line" =~ $pattern1 ]]; then
  echo "A primeira linha corresponde ao padrão 1: $first_line"
  # Ação 1: Coloque aqui o código para a ação 1
elif [[ "$first_line" =~ $pattern2 ]]; then
  echo "A primeira linha corresponde ao padrão 2: $first_line"
  # Ação 2: Coloque aqui o código para a ação 2
else
  echo "A primeira linha não corresponde a nenhum padrão: $first_line"
  # Ação 3: Coloque aqui o código para a ação 3
fi