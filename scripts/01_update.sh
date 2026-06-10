#!/bin/bash
# Script: 01_update.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Atualizacao do sistema operacional Ubuntu

LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/update_$(date +%Y-%m-%d).log"
mkdir -p "$LOG_DIR"

atualizar_sistema() {
    echo "============================================"
    echo "  [FOTOSOCIAL] Atualizacao do Sistema"
    echo "  $(date '+%d/%m/%Y %H:%M:%S')"
    echo "============================================"
    echo "[INFO] Executando apt update..." | tee -a "$LOG_FILE"
    if apt update -y >> "$LOG_FILE" 2>&1; then
        echo "[OK] Lista de pacotes atualizada." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao atualizar lista de pacotes." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[INFO] Executando apt upgrade..." | tee -a "$LOG_FILE"
    if apt upgrade -y >> "$LOG_FILE" 2>&1; then
        echo "[OK] Pacotes atualizados com sucesso." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao atualizar pacotes." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[OK] Sistema atualizado!" | tee -a "$LOG_FILE"
    echo "[INFO] Log salvo em: $LOG_FILE"
    echo "============================================"
}

atualizar_sistema