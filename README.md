# Vortex

[![AWK 1.3.4](https://img.shields.io/badge/AWK-1.3.4-red)](https://packages.debian.org/stable/awk) 
[![ShellScript Bash](https://img.shields.io/badge/ShellScript-Bash-blue)](https://www.gnu.org/software/bash/)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-GPL%202.0-yellow)](https://github.com/gustavo404/obsidian/blob/main/LICENSE)
[![Youtube](https://img.shields.io/badge/Youtube-Gustavo404-red.svg)](https://youtube.com/gustavo404)

<img src=".vortex.jpg" alt="Vortex Logo" width="520">

## Depedecias
- expect
- outros scripts

## Subscripts 
Os subscripts do VORTEX são:

1. **Oxygen**: Um controlador de telnet em expect, que se conecta com a OLT e executa uma lista de comandos informados no telnet. Além disso, o Oxygen é responsável por elevar o privilégio ou mudar de shell, se necessário. Embora pareça simples, esse script possui a enorme responsabilidade de executar esses procedimentos sem sobrecarregar ou travar a OLT. O Oxygen também solicita os dados de login, garantindo a segurança dessas informações. 
2. **Tsunami**: Um conversor de dados de texto que coleta os dados do usuário e formata-os da maneira desejada. Por exemplo, ele pode transformar IDs de ONTs e ONUs em comandos do telnet, formatar a saída de dados das ONTs para melhor tratamento, entre outras funcionalidades.
3. **Obsidian**: Esse script é responsável por filtrar dados de sinais dos clientes e das ONTs em dBm. Ele seleciona uma faixa mínima e máxima personalizável para melhorar a identificação de sinais ruins. Além disso, o Obsidian extrai sinais bugados, pois o método antigo de coleta de dados tinha problemas ao coletar informações de ONTs e ONUs desligadas, considerando-as como sinais ruins. O Obsidian reconhece aparelhos desligados e outros problemas do mesmo escopo.
