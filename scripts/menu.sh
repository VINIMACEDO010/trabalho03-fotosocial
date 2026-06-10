#!/bin/bash
# Script: menu.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Instituicao: UNIDAVI
# Descricao: Menu interativo principal

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

exibir_cabecalho() {
    clear
    echo "============================================"
    echo "  Criado por: Vinicius Policarpo Macedo"
    echo "  Instituicao: UNIDAVI"
    echo "  Tema: 14 - Rede Social de Fotos"
    echo "============================================"
    echo "       MENU DEVOPS CLOUD - FOTOSOCIAL       "
    echo "============================================"
    echo "  1 - Atualizar sistema"
    echo "  2 - Instalar Apache + ImageMagick"
    echo "  3 - Criar estrutura do projeto"
    echo "  4 - Realizar backup"
    echo "  5 - Fazer deploy do site"
    echo "  6 - Ver processos"
    echo "  7 - Monitorar sistema"
    echo "  8 - Configurar usuarios e permissoes"
    echo "  9 - Gerar relatorio operacional"
    echo "  0 - Sair"
    echo "============================================"
}

executar_script() {
    local SCRIPT="$1"
    local CAMINHO="$SCRIPT_DIR/$SCRIPT"
    echo ""
    if [ -f "$CAMINHO" ]; then
        bash "$CAMINHO"
    else
        echo "[ERRO] Script nao encontrado: $CAMINHO"
    fi
    echo ""
    echo "Pressione Enter para voltar ao menu..."
    read -r
}

while true; do
    exibir_cabecalho
    echo -n "  Escolha uma opcao: "
    read -r OPCAO
    case "$OPCAO" in
        1) executar_script "01_update.sh" ;;
        2) executar_script "02_apache.sh" ;;
        3) executar_script "03_estrutura.sh" ;;
        4) executar_script "04_backup.sh" ;;
        5) executar_script "05_deploy.sh" ;;
        6)
            clear
            echo "============================================"
            echo "  [FOTOSOCIAL] Processos"
            echo "============================================"
            echo "Opcoes: listar | buscar <nome> | matar <PID>"
            echo -n "Informe a acao: "
            read -r ACAO ARG
            bash "$SCRIPT_DIR/06_processos.sh" $ACAO $ARG
            echo ""
            echo "Pressione Enter para voltar..."
            read -r
            ;;
        7) executar_script "07_monitoramento.sh" ;;
        8) executar_script "08_usuarios_permissoes.sh" ;;
        9) executar_script "09_relatorio.sh" ;;
        0)
            echo ""
            echo "[FOTOSOCIAL] Saindo. Ate logo!"
            exit 0
            ;;
        *)
            echo "[AVISO] Opcao invalida."
            sleep 1
            ;;
    esac
done