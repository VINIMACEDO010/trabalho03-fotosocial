#!/bin/bash
# Script: 05_deploy.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Deploy do site estatico para o Apache

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/deploy_$(date +%Y-%m-%d).log"
mkdir -p "$LOG_DIR"

limpar_destino() {
    echo "[INFO] Limpando diretorio de destino: $DESTINO" | tee -a "$LOG_FILE"
    rm -rf "${DESTINO:?}"/*
    echo "[OK] Diretorio limpo." | tee -a "$LOG_FILE"
}

realizar_deploy() {
    echo "[INFO] Copiando arquivos de $ORIGEM para $DESTINO..." | tee -a "$LOG_FILE"
    if [ ! -d "$ORIGEM" ]; then
        echo "[ERRO] Diretorio de origem nao encontrado: $ORIGEM" | tee -a "$LOG_FILE"
        exit 1
    fi
    if cp -r "$ORIGEM"/. "$DESTINO/"; then
        echo "[OK] Arquivos publicados com sucesso." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao copiar arquivos." | tee -a "$LOG_FILE"
        exit 1
    fi
}

validar_deploy() {
    echo "[INFO] Validando deploy..." | tee -a "$LOG_FILE"
    if [ -f "$DESTINO/index.html" ]; then
        echo "[OK] index.html encontrado em $DESTINO" | tee -a "$LOG_FILE"
    else
        echo "[ERRO] index.html NAO encontrado apos deploy!" | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[INFO] Arquivos publicados:" | tee -a "$LOG_FILE"
    ls -lh "$DESTINO" | tee -a "$LOG_FILE"
}

echo "============================================"
echo "  [FOTOSOCIAL] Deploy do Site"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
limpar_destino
realizar_deploy
validar_deploy
echo ""
echo "[OK] Site publicado! Acesse: http://localhost:8080" | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"