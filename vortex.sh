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
            pass)
                pass="$OPTARG"
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
    echo "A primeira linha corresponde ao padrão 1 2 3: $first_line"
    # Pergunta se o usuario deseja converter o arquivo de "1 2 3" para "1/2/3" com "bash tsunami -i"
    # Se a resposta for s, S, y, Y ou nada, executa o comando
    echo "Deseja converter o arquivo de '1 2 3' para '1/2/3' com 'bash tsunami -i $input'? (S/n)"
    read resposta
    if [ -z "$resposta" ] || [ "$resposta" = "s" ] || [ "$resposta" = "S" ] || [ "$resposta" = "y" ] || [ "$resposta" = "Y" ]; then
        bash tsunami/tsunami -i "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_formatado.txt"
    fi

# Re-lê a primeira linha do arquivo
first_line=$(head -n 1 "$input")

elif [[ "$first_line" =~ $pattern2 ]]; then
    echo "A primeira linha corresponde ao padrão 1/2/3: $first_line"
    # Pergunta se o usuario deseja converter o arquivo de "1/2/3" para comandos telnet com "bash tsunami -t $input_formatado.txt'"
    # Se a resposta for s, S, y, Y ou nada, executa o comando
    echo "Deseja converter o arquivo de '1/2/3' para comandos telnet com 'bash tsunami -t '$input'_formatado.txt'? (S/n)"
    read resposta
    if [ -z "$resposta" ] || [ "$resposta" = "s" ] || [ "$resposta" = "S" ] || [ "$resposta" = "y" ] || [ "$resposta" = "Y" ]; then
        bash tsunami/tsunami -t $input
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_telnet.txt"
    fi
else
    echo "A primeira linha não corresponde a nenhum padrão: $first_line"
    # Pergunta se o usuario deseja executar o oxygen com $input com "expect oxygen/oxygen.expect $ip $user $pass $input | see $output"
    # Se a resposta for s, S, y, Y ou nada, executa o comando
    echo "Deseja executar o oxygen com $input com 'expect oxygen/oxygen.expect $ip $user $pass $input | see $output'? (S/n)"
    read resposta
    if [ -z "$resposta" ] || [ "$resposta" = "s" ] || [ "$resposta" = "S" ] || [ "$resposta" = "y" ] || [ "$resposta" = "Y" ]; then
        expect oxygen/oxygen.expect $ip $user $pass $input | see $output
    fi
fi