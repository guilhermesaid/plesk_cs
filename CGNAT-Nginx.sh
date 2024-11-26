#!/bin/bash
############################################################################################
#Nome: CGNAT-Nginx.sh                                                                     #
#Autor: Guilherme Said                                                                     #
#Descrição : Script atualiza a geração de logs adicionando ao final um IP e Porta          #
#Data Criação: 26/11/2024                                                                  #
#                                                                                          #
###########################################################################################
# Passo 1: Baixar o modelo e criar o arquivo de configuração de logs do Nginx
LOG_CONF_URL="https://raw.githubusercontent.com/guilhermesaid/plesk_cs/refs/heads/main/custom_logs_with_ip_and_port.conf"
LOG_CONF_PATH="/etc/nginx/conf.d/custom_logs_with_ip_and_port.conf"

echo "Baixando o modelo de configuração de logs..."
curl -o "$LOG_CONF_PATH" "$LOG_CONF_URL"
if [ $? -eq 0 ]; then
    echo "Arquivo de configuração de logs baixado com sucesso: $LOG_CONF_PATH"
else
    echo "Erro ao baixar o arquivo de configuração de logs. Verifique a URL ou a conectividade." >&2
    exit 1
fi

# Passo 2: Criar a pasta de templates personalizados (se não existir)
TEMPLATE_DIR="/usr/local/psa/admin/conf/templates/custom/domain/"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Criando a pasta de templates personalizados..."
    mkdir -p "$TEMPLATE_DIR"
    if [ $? -eq 0 ]; then
        echo "Pasta criada com sucesso: $TEMPLATE_DIR"
    else
        echo "Erro ao criar a pasta. Verifique permissões." >&2
        exit 1
    fi
else
    echo "A pasta de templates personalizados já existe: $TEMPLATE_DIR"
fi

# Passo 3: Baixar o gabarito já modificado padrão para a pasta
TEMPLATE_URL="https://raw.githubusercontent.com/guilhermesaid/plesk_cs/refs/heads/main/nginxDomainVirtualHost.php"
TEMPLATE_PATH="${TEMPLATE_DIR}nginxDomainVirtualHost.php"

echo "Baixando o gabarito de template modificado..."
curl -o "$TEMPLATE_PATH" "$TEMPLATE_URL"
if [ $? -eq 0 ]; then
    echo "Gabarito de template baixado com sucesso: $TEMPLATE_PATH"
else
    echo "Erro ao baixar o gabarito de template. Verifique a URL ou a conectividade." >&2
    exit 1
fi

# Passo 4: Gerar novamente toda a configuração a nível de servidor
echo "Regenerando a configuração a nível de servidor..."
plesk sbin httpdmng --reconfigure-server
if [ $? -eq 0 ]; then
    echo "Configuração do servidor regenerada com sucesso."
else
    echo "Erro ao regenerar a configuração do servidor. Verifique o Plesk." >&2
    exit 1
fi

echo "Script concluído com sucesso!"
