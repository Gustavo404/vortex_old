#!/bin/bash

# Variaveis misselaneas
# SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_tsunami="../tsunami/tsunami.sh"
dir_oxygen="../oxygen/oxygen.expect"
dir_obsidian="../obsidian/obsidian.sh"

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

# Função para coletar dados de entrada do usuário
coletar_dados() {
    color_message "yellow" "[?] Digite o nome do arquivo de entrada: "
    read input
    color_message "yellow" "[?] Digite o IP do servidor Telnet: "
    read ip
    color_message "yellow" "[?] Digite o usuário do servidor Telnet: "
    read user
    color_message "yellow" "[?] Digite a senha do servidor Telnet: "
    read pass
}

# Função para processar as opções da linha de comando
processar_opcoes() {
    while getopts "i:u:p:s:" opt; do
        case $opt in
            s) ip="$OPTARG" ;;
            u) user="$OPTARG" ;;
            i) input="$OPTARG" ;;
            p) pass="$OPTARG" ;;
            \?)
                color_message "red" "[!] Opção inválida: -$OPTARG" >&2
                color_message "yellow" "[?] Uso: bash vision.sh -s SERVER_IP -u USER -i INPUT_FILE -p PASS"
                exit 1
                ;;
            :)
                color_message "red" "[!] A opção -$OPTARG requer um argumento." >&2
                color_message "yellow" "[?] Uso: bash vision.sh -s SERVER_IP -u USER -i INPUT_FILE -p PASS"
                exit 1
                ;;
        esac
    done
}

# Função para verificar se todas as variáveis foram preenchidas
verificar_variaveis() {
    if [[ -z "$input" || -z "$ip" || -z "$user" || -z "$pass" ]]; then
        color_message "yellow" "[?] Uso: bash vision.sh -s SERVER_IP -u USER -i INPUT_FILE -p PASS"
        exit 1
    fi
}

# Função para verificar se o arquivo de entrada existe
verificar_arquivo() {
    if [[ ! -f "$input" ]]; then
        color_message "red" "[!] O arquivo $input não existe"
        exit 1
    fi
}

# Função para criar uma pasta de saída usando o nome do input a fim de organizar arquivos em multi processamentos
criar_pasta_saida() {
    input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
    input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
    # Verifica se o diretório existe
    if [ -d "$input_sem_extensao" ]; then
        cp $input "$input_sem_extensao"/
        cd "$input_sem_extensao" || exit 1
    else
        mkdir "$input_sem_extensao"
        cp $input "$input_sem_extensao"/
        cd "$input_sem_extensao" || exit 1
    fi
}

# Função para verificar o padrão da primeira linha do arquivo
verificar_padrao() {
    # Lê a primeira linha do arquivo de entrada
    local first_line=$(head -n 1 "$input")

    # Verifica se a primeira linha corresponde a um dos padrões usando o comando grep
    if echo "$first_line" | grep -E '^[0-9]+\s+[0-9]+\s+[0-9]+$'; then
        echo
        color_message "blue" "[!] O arquivo $input está no padrão '1 2 3': $first_line"
        converter_arquivo
        local first_line=$(head -n 1 "$input")
    fi
    if echo "$first_line" | grep -E '^[0-9]+\/[0-9]+\/[0-9]+$'; then
        echo
        color_message "blue" "[!] O arquivo $input está no padrão '1/2/3': $first_line"
        converter_arquivo_telnet
        local first_line=$(head -n 1 "$input")
    fi
        color_message "yellow" "[?] Deseja executar o Oxygen para: $first_line? (S/n)"
        read resposta
        if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
            executar_oxygen
        fi
}

# Função para converter o arquivo de "1 2 3" para "1/2/3"
converter_arquivo() {
    color_message "yellow" "[?] Deseja converter $input de '1 2 3' para '1/2/3'? (S/n)"
    read resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        bash $dir_tsunami -i "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_formatado.txt"
        echo
    fi
}

# Função para converter o arquivo de "1/2/3" para comandos Telnet
converter_arquivo_telnet() {
    color_message "yellow" "[?] Deseja converter $input de '1/2/3' para comandos Telnet? (S/n)"
    read resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        bash $dir_tsunami -t "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_comandos.txt"
        echo
    fi
}

# Função para executar o Oxygen
executar_oxygen() {
    expect $dir_oxygen "$ip" "$user" "$pass" "$input" | tee "$input_sem_extensao"_telnet.txt
    grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' "$input_sem_extensao"_telnet.txt > "$input_sem_extensao"_recv.txt
    echo
    color_message "green" "Oxygen executado com sucesso"
    echo
}

# Função para filtrar os dados com Tsunami
filtrar_dados() {
    color_message "yellow" "[!] Iniciando formatação dos dados com Tsunami"
    bash $dir_tsunami -s "$input_sem_extensao"_recv.txt
    echo
}

# Função para filtrar os dados com Obsidian
filtrar_dados_obsidian() {
    color_message "yellow" "[?] Deseja filtrar os dados com Obsidian? (S/n)"
    read resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        clear
        echo
        color_message "yellow" "[!] Abra a planilha da OLT e apague as colunas 'PLACA PON e ONU (2,3 e 4)'"
        sleep 0.2
        color_message "yellow" "[!] Copie \e[0m"$input_sem_extensao"_formatado.txt\e[93m e cole na \e[91msegunda\e[93m coluna da planilha."
        sleep 0.2
        color_message "yellow" "[!] Copie \e[0m"$input_sem_extensao"_sinal.txt\e[93m e cole na \e[91mterceira\e[93m coluna da planilha."
        sleep 0.2
        echo
        color_message "red" "[!] ATENÇÃO: verifique se todas as colunas possuem o mesmo número de linhas!"
        sleep 0.4
        color_message "yellow" "[!] Cole as 3 colunas num arquivo em $current_dir"
        color_message "yellow" "    (você precisará informar o nome do arquivo!)"
        echo
        for i in {5..0}; do
            echo -ne "Você poderá prosseguir em $i segundos\r"
            sleep 1
        done
        echo && echo
        color_message "green" "[!] pressione enter para continuar"
        read
        bash $dir_obsidian
    fi
}

# Coleta de dados
if [[ $# -eq 0 ]]; then
    coletar_dados
else
    processar_opcoes "$@"
fi

# Banner
clear
cat .banner | lolcat
echo

current_dir=$(pwd)
color_message "green" "[!] Diretório atual: $current_dir" && echo

# Verificação de variáveis
verificar_variaveis
verificar_arquivo
criar_pasta_saida

# Conversão de quebra de linha de Dos para Unix
color_message "yellow" "[!] Convertendo quebra de linha para Unix..."
dos2unix "$input" 2> /dev/null
echo

# Verificação de padrão
verificar_padrao

# Filtragem de dados
filtrar_dados

# Função de limpar o diretório
color_message "yellow" "[?] Deseja apagar os arquivos 'recv' e 'comandos'? (S/n)"
read resposta
if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
    # rm "$input_sem_extensao"_telnet.txt
    rm "$input_sem_extensao"_recv.txt
    # rm "$input_sem_extensao"_formatado.txt
    rm "$input_sem_extensao"_comandos.txt
    # rm "$input_sem_extensao"_sinal.txt
fi

# Filtragem de dados com Obsidian
filtrar_dados_obsidian

# Finalização do script
echo
color_message "yellow" "[!] Finalizando..."
color_message "green" "[.]Script finalizado"

exit 0
