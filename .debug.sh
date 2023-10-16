#!/bin/bash
# este script faz parte do debug e depende do vortex (github) e shunit2 (apt) para funcionar
# Carrega o script vortex.sh
. vortex.sh

# Testa a função color_message
test_color_message() {
  local message=$(color_message "red" "This is a test message")
  assertEquals "\e[91mThis is a test message\e[0m" "$message"
}

# Testa a função coletar_dados
test_coletar_dados() {
  # Simula a entrada do usuário
  echo "input.txt" | test_coletar_dados_input
  echo "192.168.0.1" | test_coletar_dados_input
  echo "user" | test_coletar_dados_input
  echo "password" | test_coletar_dados_input

  # Chama a função
  coletar_dados

  # Verifica as variáveis
  assertEquals "input.txt" "$input"
  assertEquals "192.168.0.1" "$ip"
  assertEquals "user" "$user"
  assertEquals "password" "$pass"
}

# Função auxiliar para test_coletar_dados
test_coletar_dados_input() {
  cat
}

# Testa a função processar_opcoes
test_processar_opcoes() {
  # Chama a função com opções
  processar_opcoes -i input.txt -s 192.168.0.1 -u user -p password

  # Verifica as variáveis
  assertEquals "input.txt" "$input"
  assertEquals "192.168.0.1" "$ip"
  assertEquals "user" "$user"
  assertEquals "password" "$pass"
}

# Testa a função verificar_variaveis
test_verificar_variaveis() {
  # Define algumas variáveis
  input="input.txt"
  ip="192.168.0.1"
  user="user"
  pass="password"

  # Chama a função com todas as variáveis definidas
  verificar_variaveis

  # Verifica que a função não sai
  assertEquals 0 $?

  # Desdefine algumas variáveis
  unset input
  unset ip

  # Chama a função com variáveis não definidas
  verificar_variaveis

  # Verifica que a função sai com erro
  assertEquals 1 $?
}

# Testa a função verificar_arquivo
test_verificar_arquivo() {
  # Chama a função com um arquivo existente
  verificar_arquivo input.txt

  # Verifica que a função não sai
  assertEquals 0 $?

  # Chama a função com um arquivo inexistente
  verificar_arquivo non_existing_file.txt

  # Verifica que a função sai com erro
  assertEquals 1 $?
}

# Testa a função criar_pasta_saida
test_criar_pasta_saida() {
  # Chama a função com um diretório inexistente
  criar_pasta_saida

  # Verifica que o diretório foi criado
  assertTrue "[ -d input ]"

  # Chama a função com um diretório existente
  criar_pasta_saida

  # Verifica que o diretório não foi criado novamente
  assertTrue "[ -d input ]"
}

# Testa a função verificar_padrao
test_verificar_padrao() {
  # Chama a função com um arquivo no formato "1 2 3"
  input="input_1_2_3.txt"
  verificar_padrao

  # Verifica que o arquivo foi convertido e executado
  assertTrue "[ -f input_formatado.txt ]"
  assertTrue "[ -f input_telnet.txt ]"
  assertTrue "[ -f input_recv.txt ]"

  # Chama a função com um arquivo no formato "1/2/3"
  input="input_1_2_3_slash.txt"
  verificar_padrao

  # Verifica que o arquivo foi convertido e executado
  assertTrue "[ -f input_comandos.txt ]"
  assertTrue "[ -f input_recv.txt ]"

  # Chama a função com um arquivo em formato desconhecido
  input="input_unknown.txt"
  verificar_padrao

  # Verifica que a função não sai
  assertEquals 0 $?
}

# Testa a função converter_arquivo
test_converter_arquivo() {
  # Chama a função com entrada do usuário
  echo "n" | test_converter_arquivo_input
  converter_arquivo

  # Verifica que o arquivo não foi convertido
  assertFalse "[ -f input_formatado.txt ]"

  # Chama a função com entrada do usuário
  echo "y" | test_converter_arquivo_input
  converter_arquivo

  # Verifica que o arquivo foi convertido
  assertTrue "[ -f input_formatado.txt ]"
}

# Função auxiliar para test_converter_arquivo
test_converter_arquivo_input() {
  cat
}

# Testa a função converter_arquivo_telnet
test_converter_arquivo_telnet() {
  # Chama a função com entrada do usuário
  echo "n" | test_converter_arquivo_telnet_input
  converter_arquivo_telnet

  # Verifica que o arquivo não foi convertido
  assertFalse "[ -f input_comandos.txt ]"

  # Chama a função com entrada do usuário
  echo "y" | test_converter_arquivo_telnet_input
  converter_arquivo_telnet

  # Verifica que o arquivo foi convertido
  assertTrue "[ -f input_comandos.txt ]"
}

# Função auxiliar para test_converter_arquivo_telnet
test_converter_arquivo_telnet_input() {
  cat
}

# Testa a função executar_oxygen
test_executar_oxygen() {
  # Chama a função com entrada do usuário
  echo "n" | test_executar_oxygen_input
  executar_oxygen

  # Verifica que a função não sai
  assertEquals 0 $?

  # Chama a função com entrada do usuário
  echo "y" | test_executar_oxygen_input
  executar_oxygen

  # Verifica que a função não sai
  assertEquals 0 $?
}

# Função auxiliar para test_executar_oxygen
test_executar_oxygen_input() {
  cat
}

# Testa a função filtrar_dados
test_filtrar_dados() {
  # Chama a função
  filtrar_dados

  # Verifica que os arquivos foram filtrados
  assertTrue "[ -f input_recv.txt ]"
  assertTrue "[ -f input_sinal.txt ]"
}

# Testa a função filtrar_dados_obsidian
test_filtrar_dados_obsidian() {
  # Chama a função com entrada do usuário
  echo "n" | test_filtrar_dados_obsidian_input
  filtrar_dados_obsidian

  # Verifica que a função não sai
  assertEquals 0 $?

  # Chama a função com entrada do usuário
  echo "y" | test_filtrar_dados_obsidian_input
  filtrar_dados_obsidian

  # Verifica que a função não sai
  assertEquals 0 $?
}

# Função auxiliar para test_filtrar_dados_obsidian
test_filtrar_dados_obsidian_input() {
  cat
}

# Testa o script
test_script() {
  # Chama o script sem argumentos
  echo "input.txt" | test_coletar_dados_input
  echo "192.168.0.1" | test_coletar_dados_input
  echo "user" | test_coletar_dados_input
  echo "password" | test_coletar_dados_input
  bash vortex.sh

  # Verifica que o script sai com sucesso
  assertEquals 0 $?

  # Chama o script com opções
  bash vortex.sh -i input.txt -s 192.168.0.1 -u user -p password

  # Verifica que o script sai com sucesso
  assertEquals 0 $?
}

# Carrega a biblioteca shunit2
. shunit2