############################################################################################
#Nome: CGNAT-Apache.sh                                                                     #
#Autor: Guilherme Said                                                                     #
#Descrição : Script atualiza a geração de logs adicionando ao final um IP e Porta          #
#Data Criação: 26/11/2024                                                                  #
#                                                                                          #
############################################################################################

#!/bin/sh

# Variáveis
TEMPLATE_DIR="/usr/local/psa/admin/conf/templates/custom/"
TEMPLATE_FILE="server.php"
TEMPLATE_URL="https://raw.githubusercontent.com/guilhermesaid/plesk_cs/refs/heads/main/server.php"
PLESK_PHP_PATH="/opt/plesk/php/8.2/bin/php"

# 2. Criar pasta de template customizado
echo "Criando pasta de template customizado..."
mkdir -p "$TEMPLATE_DIR"
if [[ $? -ne 0 ]]; then
    echo "Erro ao criar a pasta $TEMPLATE_DIR."
    exit 1
fi

# 3. Baixar o arquivo modificado
echo "Baixando o arquivo template modificado..."
curl -o "${TEMPLATE_DIR}${TEMPLATE_FILE}" "$TEMPLATE_URL"
if [[ $? -ne 0 ]]; then
    echo "Erro ao baixar o arquivo de $TEMPLATE_URL."
    exit 1
fi

# 7. Testar a sintaxe do arquivo
echo "Testando a sintaxe do arquivo PHP..."
if php -l "${TEMPLATE_DIR}${TEMPLATE_FILE}" &>/dev/null; then
    echo "Nenhum erro de sintaxe detectado."
else
    echo "Erro de sintaxe detectado, tentando verificar com o PHP da Plesk..."
    if "$PLESK_PHP_PATH" -l "${TEMPLATE_DIR}${TEMPLATE_FILE}" &>/dev/null; then
        echo "Nenhum erro de sintaxe detectado com o PHP da Plesk."
    else
        echo "Erro de sintaxe detectado no arquivo template. Verifique manualmente."
        exit 1
    fi
fi

# 8. Regenerar toda a configuração a nível de servidor
echo "Regenerando a configuração do servidor..."
plesk sbin httpdmng --reconfigure-server
if [[ $? -ne 0 ]]; then
    echo "Erro ao regenerar a configuração do servidor."
    exit 1
fi

echo "Script concluído com sucesso!"
