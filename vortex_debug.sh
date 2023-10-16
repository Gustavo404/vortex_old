#!/bin/bash

# Load the vortex.sh script
. vortex.sh

# Test the color_message function
test_color_message() {
  local message=$(color_message "red" "This is a test message")
  assertEquals "\e[91mThis is a test message\e[0m" "$message"
}

# Test the coletar_dados function
test_coletar_dados() {
  # Simulate user input
  echo "input.txt" | test_coletar_dados_input
  echo "192.168.0.1" | test_coletar_dados_input
  echo "user" | test_coletar_dados_input
  echo "password" | test_coletar_dados_input

  # Call the function
  coletar_dados

  # Check the variables
  assertEquals "input.txt" "$input"
  assertEquals "192.168.0.1" "$ip"
  assertEquals "user" "$user"
  assertEquals "password" "$pass"
}

# Helper function for test_coletar_dados
test_coletar_dados_input() {
  cat
}

# Test the processar_opcoes function
test_processar_opcoes() {
  # Call the function with options
  processar_opcoes -i input.txt -s 192.168.0.1 -u user -p password

  # Check the variables
  assertEquals "input.txt" "$input"
  assertEquals "192.168.0.1" "$ip"
  assertEquals "user" "$user"
  assertEquals "password" "$pass"
}

# Test the verificar_variaveis function
test_verificar_variaveis() {
  # Set some variables
  input="input.txt"
  ip="192.168.0.1"
  user="user"
  pass="password"

  # Call the function with all variables set
  verificar_variaveis

  # Check that the function does not exit
  assertEquals 0 $?

  # Unset some variables
  unset input
  unset ip

  # Call the function with unset variables
  verificar_variaveis

  # Check that the function exits with an error
  assertEquals 1 $?
}

# Test the verificar_arquivo function
test_verificar_arquivo() {
  # Call the function with an existing file
  verificar_arquivo input.txt

  # Check that the function does not exit
  assertEquals 0 $?

  # Call the function with a non-existing file
  verificar_arquivo non_existing_file.txt

  # Check that the function exits with an error
  assertEquals 1 $?
}

# Test the criar_pasta_saida function
test_criar_pasta_saida() {
  # Call the function with a non-existing directory
  criar_pasta_saida

  # Check that the directory was created
  assertTrue "[ -d input ]"

  # Call the function with an existing directory
  criar_pasta_saida

  # Check that the directory was not created again
  assertTrue "[ -d input ]"
}

# Test the verificar_padrao function
test_verificar_padrao() {
  # Call the function with a file in the "1 2 3" format
  input="input_1_2_3.txt"
  verificar_padrao

  # Check that the file was converted and executed
  assertTrue "[ -f input_formatado.txt ]"
  assertTrue "[ -f input_telnet.txt ]"
  assertTrue "[ -f input_recv.txt ]"

  # Call the function with a file in the "1/2/3" format
  input="input_1_2_3_slash.txt"
  verificar_padrao

  # Check that the file was converted and executed
  assertTrue "[ -f input_comandos.txt ]"
  assertTrue "[ -f input_recv.txt ]"

  # Call the function with a file in an unknown format
  input="input_unknown.txt"
  verificar_padrao

  # Check that the function does not exit
  assertEquals 0 $?
}

# Test the converter_arquivo function
test_converter_arquivo() {
  # Call the function with user input
  echo "n" | test_converter_arquivo_input
  converter_arquivo

  # Check that the file was not converted
  assertFalse "[ -f input_formatado.txt ]"

  # Call the function with user input
  echo "y" | test_converter_arquivo_input
  converter_arquivo

  # Check that the file was converted
  assertTrue "[ -f input_formatado.txt ]"
}

# Helper function for test_converter_arquivo
test_converter_arquivo_input() {
  cat
}

# Test the converter_arquivo_telnet function
test_converter_arquivo_telnet() {
  # Call the function with user input
  echo "n" | test_converter_arquivo_telnet_input
  converter_arquivo_telnet

  # Check that the file was not converted
  assertFalse "[ -f input_comandos.txt ]"

  # Call the function with user input
  echo "y" | test_converter_arquivo_telnet_input
  converter_arquivo_telnet

  # Check that the file was converted
  assertTrue "[ -f input_comandos.txt ]"
}

# Helper function for test_converter_arquivo_telnet
test_converter_arquivo_telnet_input() {
  cat
}

# Test the executar_oxygen function
test_executar_oxygen() {
  # Call the function with user input
  echo "n" | test_executar_oxygen_input
  executar_oxygen

  # Check that the function does not exit
  assertEquals 0 $?

  # Call the function with user input
  echo "y" | test_executar_oxygen_input
  executar_oxygen

  # Check that the function does not exit
  assertEquals 0 $?
}

# Helper function for test_executar_oxygen
test_executar_oxygen_input() {
  cat
}

# Test the filtrar_dados function
test_filtrar_dados() {
  # Call the function
  filtrar_dados

  # Check that the files were filtered
  assertTrue "[ -f input_recv.txt ]"
  assertTrue "[ -f input_sinal.txt ]"
}

# Test the filtrar_dados_obsidian function
test_filtrar_dados_obsidian() {
  # Call the function with user input
  echo "n" | test_filtrar_dados_obsidian_input
  filtrar_dados_obsidian

  # Check that the function does not exit
  assertEquals 0 $?

  # Call the function with user input
  echo "y" | test_filtrar_dados_obsidian_input
  filtrar_dados_obsidian

  # Check that the function does not exit
  assertEquals 0 $?
}

# Helper function for test_filtrar_dados_obsidian
test_filtrar_dados_obsidian_input() {
  cat
}

# Test the script
test_script() {
  # Call the script with no arguments
  echo "input.txt" | test_coletar_dados_input
  echo "192.168.0.1" | test_coletar_dados_input
  echo "user" | test_coletar_dados_input
  echo "password" | test_coletar_dados_input
  bash vortex.sh

  # Check that the script exits with success
  assertEquals 0 $?

  # Call the script with options
  bash vortex.sh -i input.txt -s 192.168.0.1 -u user -p password

  # Check that the script exits with success
  assertEquals 0 $?
}

# Load the shunit2 library
. shunit2
