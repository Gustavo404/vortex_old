#!/bin/bash

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
    color_message "yellow" "[?] Digite o nome do arquivo de saída: "
    read output
    color_message "yellow" "[?] Digite o IP do servidor Telnet: "
    read ip
    color_message "yellow" "[?] Digite o usuário do servidor Telnet: "
    read user
    color_message "yellow" "[?] Digite a senha do servidor Telnet: "
    read pass
}

# Função para processar as opções da linha de comando
processar_opcoes() {
    while getopts "i:u:p:s:o:" opt; do
        case $opt in
            s) ip="$OPTARG" ;;
            u) user="$OPTARG" ;;
            i) input="$OPTARG" ;;
            o) output="$OPTARG" ;;
            p) pass="$OPTARG" ;;
            \?)
                color_message "red" "[!] Opção inválida: -$OPTARG" >&2
                exit 1
                ;;
            :)
                color_message "red" "[!] A opção -$OPTARG requer um argumento." >&2
                exit 1
                ;;
        esac
    done
}

# Função para verificar se todas as variáveis foram preenchidas
verificar_variaveis() {
    if [[ -z "$input" || -z "$output" || -z "$ip" || -z "$user" || -z "$pass" ]]; then
        color_message "red" "[!] Alguma variável não foi preenchida"
        exit 1
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
        bash tsunami/tsunami.sh -i "$input"
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
        bash tsunami/tsunami.sh -t "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_comandos.txt"
        echo
    fi
}

# Função para executar o Oxygen
executar_oxygen() {
    expect oxygen/oxygen.expect "$ip" "$user" "$pass" "$input" | tee "$input_sem_extensao"_telnet.txt
    grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' "$input_sem_extensao"_telnet.txt > "$input_sem_extensao"_recv.txt
    echo
    color_message "green" "Oxygen executado com sucesso"
    echo
}

# Função para filtrar os dados com Obsidian e Tsunami
filtrar_dados() {
    color_message "yellow" "[!] Iniciando formatação dos dados com Tsunami"
    bash tsunami/tsunami.sh -s "$input_sem_extensao"_recv.txt
    echo
}

# Função para filtrar os dados com Obsidian
filtrar_dados_obsidian() {
    color_message "yellow" "[?] Deseja filtrar os dados com Obsidian? (S/n)"
    read resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        clear
        echo
        output_sem_extensao=$(basename "$output" | cut -f 1 -d '_')
        output_sem_extensao=$(basename "$output_sem_extensao" | cut -f 1 -d '.')
        color_message "yellow" "[!] Abra a planilha da OLT e apague as colunas 'PLACA PON e ONU (2,3 e 4)'"
        sleep 0.2
        color_message "yellow" "[!] Copie \e[0m"$input_sem_extensao"_formatado.txt\e[93m e cole na \e[91msegunda\e[93m coluna da planilha."
        sleep 0.2
        color_message "yellow" "[!] Copie \e[0m"$output_sem_extensao"_sinal.txt\e[93m e cole na \e[91mterceira\e[93m coluna da planilha."
        sleep 0.2
        echo
        color_message "red" "[!] ATENÇÃO: verifique se todas as colunas possuem o mesmo número de linhas!"
        sleep 0.4
        color_message "yellow" "[!] Copie as 3 colunas da planilha e cole num arquivo de texto"
        color_message "yellow" "    (você precisará informar o nome do arquivo!)"
        echo
        for i in {5..0}; do
            echo -ne "Você poderá prosseguir em $i segundos\r"
            sleep 1
        done
        echo && echo
        color_message "green" "[!] pressione enter para continuar"
        read
        bash obsidian/obsidian.sh
    fi
}

# Coleta de dados
if [[ $# -eq 0 ]]; then
    coletar_dados
else
    processar_opcoes "$@"
fi

# Verificação de variáveis
verificar_variaveis

# Conversão de quebra de linha para Unix + debug
clear
color_message "yellow" "[!] Convertendo quebra de linha para Unix..."
dos2unix "$input"
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