#!/bin/bash

cat banner.txt
echo # pula uma linha por conta do banner
echo "Bem vindo ao Vortex"
echo # pula uma linha para ficar mais bonito

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

# Verifica se o arquivo de entrada possui apenas números e tabs (X Y Z)
if [[ "$input" =~ ^[0-9\t]+$ ]]; then
    echo "O arquivo de entrada está no padrão Z Y X"
    echo "Executando o tsunami.sh -i"	
    bash tsunami.sh -i $input
# Verifica se o arquivo de entrada possui /
elif [[ "$input" == *"/"* ]]; then
    echo "O arquivo de entrada possui está no padrão X/Y/Z"
    echo "Executando o tsunami.sh -t"
    bash tsunami.sh -t $input
else
    # Se não for nenhum dos casos anteriores, assume que são comandos do telnet
    echo "O arquivo de entrada possui comandos do telnet"
    echo "Executando o oxygen.expect"
    bash oxygen/oxygen.expect $ip $user $pass $input $output | see $output
