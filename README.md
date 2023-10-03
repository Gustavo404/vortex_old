# Vortex

[![AWK 1.3.4](https://img.shields.io/badge/AWK-1.3.4-red)](https://packages.debian.org/stable/awk) 
[![ShellScript Bash](https://img.shields.io/badge/ShellScript-Bash-blue)](https://www.gnu.org/software/bash/)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-GPL%202.0-yellow)](https://github.com/gustavo404/obsidian/blob/main/LICENSE)
[![Youtube](https://img.shields.io/badge/Youtube-Gustavo404-red.svg)](https://youtube.com/gustavo404)

<img src=".vortex.jpg" alt="Vortex Logo" width="520">

O **Projeto VORTEX** foi construído a partir de subscripts que foram criados antes mesmo da ideia do projeto existir. Esses subscripts eram responsáveis por automatizar processos de tratamento de dados. No entanto, quando o desenvolvedor precisou realizar uma coleta de dados, ele criou o script chamado Oxygen. O Oxygen é um controlador de telnet baseado em expect, que se conecta às OLTs via telnet e coleta informações, principalmente relacionadas a ONTs e ONUs.

Antes do VORTEX, já existiam vários outros subscripts criados pelo mesmo desenvolvedor para tratar os dados coletados. No entanto, com a criação do script de coleta de dados, foi possível criar um fluxo interno de dados, unindo todos os subscripts e utilizando um script principal para gerenciar esse fluxo. Foi assim que o VORTEX nasceu.

Os subscripts do VORTEX são:

1. **Oxygen**: Um controlador de telnet em expect, que se conecta com a OLT e executa uma lista de comandos informados no telnet. Além disso, o Oxygen é responsável por elevar o privilégio ou mudar de shell, se necessário. Embora pareça simples, esse script possui a enorme responsabilidade de executar esses procedimentos sem sobrecarregar ou travar a OLT. O Oxygen também solicita os dados de login, garantindo a segurança dessas informações. 
2. **Tsunami**: Um conversor de dados de texto que coleta os dados do usuário e formata-os da maneira desejada. Por exemplo, ele pode transformar IDs de ONTs e ONUs em comandos do telnet, formatar a saída de dados das ONTs para melhor tratamento, entre outras funcionalidades.
3. **Obsidian**: Esse script é responsável por filtrar dados de sinais dos clientes e das ONTs em dBm. Ele seleciona uma faixa mínima e máxima personalizável para melhorar a identificação de sinais ruins. Além disso, o Obsidian extrai sinais bugados, pois o método antigo de coleta de dados tinha problemas ao coletar informações de ONTs e ONUs desligadas, considerando-as como sinais ruins. O Obsidian reconhece aparelhos desligados e outros problemas do mesmo escopo.

Além dos subscripts mencionados, existem também os **pseudo-códigos** (assim são chamados), que realizam funções específicas, sem uma qualificação, filtro ou escopo definido. Esses pseudo-códigos podem ser encontrados no meio do código, fora dos outros scripts, e são pequenos demais para terem um nome ou arquivo próprio.

### **Documentação do Script `install.sh`**

**Descrição:**

O script **`install.sh`** é responsável por facilitar a instalação e reinstalação das dependências necessárias para o projeto Vortex. Além disso, ele clona os repositórios do GitHub relacionados aos scripts de coleta e formatação de dados. Este script é executado durante a configuração inicial do projeto.

**Funções Destacadas:**

1. **`instalar_dependencias`**
    - Instala as dependências essenciais, como Expect, Git e dos2unix.
    - Realiza o clone dos repositórios 'obsidian', 'oxygen', e 'tsunami' do GitHub.
    - Converte os arquivos para o formato Unix, se necessário.
2. **`reinstalar_dependencias`**
    - Remove os repositórios já existentes.
    - Executa a função **`instalar_dependencias`** para reinstalar todas as dependências.

**Uso do Script:**

Para executar o script **`install.sh`**, utilize o seguinte comando:

```bash
sudo bash install.sh [-i] ou [-r]
```

- **`i`**: Instala todas as dependências e realiza o clone dos repositórios.
- **`r`**: Reinstala todas as dependências, removendo os repositórios existentes.

### **Documentação do Script `vortex.sh`**

**Descrição:**

O script **`vortex.sh`** é o ponto central do projeto Vortex. Ele coleta dados do usuário, processa opções da linha de comando e executa outras funções relacionadas à coleta, formatação e análise de dados.

**Funções Destacadas:**

1. **`coletar_dados`**
    - Solicita ao usuário informações como nome do arquivo de entrada, nome do arquivo de saída, IP do servidor Telnet, usuário e senha.
2. **`processar_opcoes`**
    - Processa as opções da linha de comando, permitindo a configuração de variáveis importantes.
3. **`verificar_variaveis`**
    - Verifica se todas as variáveis necessárias foram preenchidas, evitando erros de execução.
4. **`verificar_padrao`**
    - Analisa o padrão da primeira linha do arquivo de entrada e oferece opções de conversão e execução do script Oxygen.
5. **`executar_oxygen`**
    - Utiliza o script Oxygen para se comunicar com o servidor Telnet, coletar dados e filtrar informações relevantes.
6. **`filtrar_dados`**
    - Formata os dados de saída da execução do Oxygen com o script Tsunami.
7. **`filtrar_dados_obsidian`**
    - Oferece a opção de utilizar o script Obsidian para filtrar ainda mais os dados, conforme necessário.

**Uso do Script:**

Para executar o script **`vortex.sh`**, utilize o seguinte comando:

```bash
bash vortex.sh [-i arquivo_entrada -u usuario -p senha -s ip_servidor -o arquivo_saida]
```

- **`i`**: Especifica o arquivo de entrada.
- **`u`**: Especifica o usuário do servidor Telnet.
- **`p`**: Especifica a senha do servidor Telnet.
- **`s`**: Especifica o IP do servidor Telnet.
- **`o`**: Especifica o arquivo de saída.

**Exemplo de Uso:**

```bash
bash vortex.sh -i dados.txt -u meuusuario -p minhasenha -s 10.10.100.0 -o resultados.txt
```

Este comando executará o script **`vortex.sh`** com as opções fornecidas para coletar, processar e filtrar dados. Certifique-se de que todas as variáveis essenciais foram preenchidas corretamente.

### **Dependências**

As seguintes dependências são necessárias para executar os scripts:

- **Expect:** É uma ferramenta que automatiza interações com programas de linha de comando, o que é essencial para a comunicação com o servidor Telnet.
- **Git:** É um sistema de controle de versão usado para clonar repositórios do GitHub.
- **dos2unix:** É uma ferramenta que converte quebras de linha de arquivos, garantindo a consistência dos formatos de arquivo.
