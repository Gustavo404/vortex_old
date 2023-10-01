#!/bin/bash

# Função para coletar dados de entrada do usuário
coletar_dados() {
    read -p "Digite o nome do arquivo de entrada: " input
    read -p "Digite o nome do arquivo de saída: " output
    read -p "Digite o IP do servidor Telnet: " ip
    read -p "Digite o usuário do servidor Telnet: " user
    read -p "Digite a senha do servidor Telnet: " pass
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
                echo "Opção inválida: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "A opção -$OPTARG requer um argumento." >&2
                exit 1
                ;;
        esac
    done
}

# Função para verificar se todas as variáveis foram preenchidas
verificar_variaveis() {
    if [[ -z "$input" || -z "$output" || -z "$ip" || -z "$user" || -z "$pass" ]]; then
        echo "Alguma variável não foi preenchida"
        exit 1
    fi
}

# Função para verificar o padrão da primeira linha do arquivo
verificar_padrao() {
    local first_line=$(head -n 1 "$input")

    if [[ "$first_line" =~ ^[0-9]+\t[0-9]+\t[0-9]+$ ]]; then
        echo "A primeira linha corresponde ao padrão 1 2 3: $first_line"
        converter_arquivo
    elif [[ "$first_line" =~ ^[0-9]+/[0-9]+/[0-9]+$ ]]; then
        echo "A primeira linha corresponde ao padrão 1/2/3: $first_line"
        converter_arquivo_telnet
    else
        echo "A primeira linha não corresponde a nenhum padrão: $first_line"
        executar_oxygen
    fi
}

# Função para converter o arquivo de "1 2 3" para "1/2/3"
converter_arquivo() {
    read -p "Deseja converter o arquivo de '1 2 3' para '1/2/3'? (S/n) " resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        bash tsunami/tsunami -i "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_formatado.txt"
    fi
}

# Função para converter o arquivo de "1/2/3" para comandos Telnet
converter_arquivo_telnet() {
    read -p "Deseja converter o arquivo de '1/2/3' para comandos Telnet? (S/n) " resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        bash tsunami/tsunami -t "$input"
        input_sem_extensao=$(basename "$input" | cut -f 1 -d '_')
        input_sem_extensao=$(basename "$input_sem_extensao" | cut -f 1 -d '.')
        input="${input_sem_extensao}_telnet.txt"
    fi
}

# Função para executar o Oxygen
executar_oxygen() {
    read -p "Deseja executar o Oxygen? (S/n) " resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        expect oxygen/oxygen.expect "$ip" "$user" "$pass" "$input" | see "$output"
    fi
}

# Função para filtrar os dados com Obsidian e Tsunami
filtrar_dados() {
    echo "Iniciando filtragem dos dados com Obsidian e Tsunami"
    bash tsunami/tsunami -s "$output"
}

# Função para filtrar os dados com Obsidian
filtrar_dados_obsidian() {
    read -p "Deseja filtrar os dados com Obsidian? (S/n) " resposta
    if [[ -z "$resposta" || "$resposta" =~ ^[SsYy]$ ]]; then
        echo "Copie as 3 colunas da planilha e cole num arquivo de texto (você precisará informar o nome do arquivo!)"
        for i in {5..1}; do
            echo -ne "Você poderá prosseguir em $i segundos\r"
            sleep 1
        done
        echo "pressione enter para continuar"
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

# Verificação de padrão
verificar_padrao

# Filtragem de dados
filtrar_dados

# Filtragem de dados com Obsidian
filtrar_dados_obsidian

# Finalização do script
echo "Script finalizado"