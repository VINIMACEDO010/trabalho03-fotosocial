#!/bin/bash
# Script: 06_processos.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Uso: ./06_processos.sh listar | buscar <nome> | matar <PID>

listar_processos() {
    echo "============================================"
    echo "  [FOTOSOCIAL] Processos em Execucao"
    echo "  $(date '+%d/%m/%Y %H:%M:%S')"
    echo "============================================"
    ps aux --sort=-%cpu | head -20
    echo ""
    echo "[INFO] Top 20 processos por uso de CPU."
}

buscar_processo() {
    local NOME_PROCESSO="$1"
    if [ -z "$NOME_PROCESSO" ]; then
        echo "[ERRO] Informe o nome do processo."
        echo "Uso: $0 buscar <nome>"
        exit 1
    fi
    echo "============================================"
    echo "  [FOTOSOCIAL] Busca: $NOME_PROCESSO"
    echo "============================================"
    RESULTADO=$(pgrep -af "$NOME_PROCESSO" 2>/dev/null)
    if [ -n "$RESULTADO" ]; then
        echo "[OK] Processo(s) encontrado(s):"
        echo "$RESULTADO"
    else
        echo "[INFO] Nenhum processo '$NOME_PROCESSO' encontrado."
    fi
}

matar_processo() {
    local PID="$1"
    if [ -z "$PID" ]; then
        echo "[SEGURANCA] BLOQUEADO: Nenhum PID informado."
        echo "Uso: $0 matar <PID>"
        exit 1
    fi
    if ! [[ "$PID" =~ ^[0-9]+$ ]]; then
        echo "[ERRO] PID invalido: '$PID'. Use apenas numeros."
        exit 1
    fi
    if ! kill -0 "$PID" 2>/dev/null; then
        echo "[AVISO] Processo $PID nao encontrado ou ja encerrado."
        exit 1
    fi
    echo "============================================"
    echo "  [FOTOSOCIAL] Encerrando PID: $PID"
    echo "============================================"
    ps -p "$PID" -o pid,user,comm,args 2>/dev/null
    echo ""
    if kill "$PID" 2>/dev/null; then
        echo "[OK] Sinal enviado para o processo $PID."
    else
        echo "[ERRO] Falha ao encerrar o processo $PID."
        exit 1
    fi
}

ACAO="$1"
ARGUMENTO="$2"

case "$ACAO" in
    listar) listar_processos ;;
    buscar) buscar_processo "$ARGUMENTO" ;;
    matar)  matar_processo "$ARGUMENTO" ;;
    *)
        echo "Uso:"
        echo "  $0 listar"
        echo "  $0 buscar <nome>"
        echo "  $0 matar  <PID>"
        exit 1
        ;;
esac