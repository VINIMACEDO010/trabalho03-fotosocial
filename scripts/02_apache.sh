#!/bin/bash
# Script: 02_apache.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Instalacao e validacao do Apache + ImageMagick
# ImageMagick processa e redimensiona fotos dos usuarios

LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/apache_$(date +%Y-%m-%d).log"
mkdir -p "$LOG_DIR"

instalar_apache() {
    echo "[INFO] Instalando Apache2..." | tee -a "$LOG_FILE"
    if apt install -y apache2 >> "$LOG_FILE" 2>&1; then
        echo "[OK] Apache instalado." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao instalar Apache." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[INFO] Instalando ImageMagick (processamento de fotos)..." | tee -a "$LOG_FILE"
    if apt install -y imagemagick >> "$LOG_FILE" 2>&1; then
        echo "[OK] ImageMagick instalado." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao instalar ImageMagick." | tee -a "$LOG_FILE"
        exit 1
    fi
    service apache2 start >> "$LOG_FILE" 2>&1 || apache2ctl start >> "$LOG_FILE" 2>&1
    echo "[INFO] Apache iniciado." | tee -a "$LOG_FILE"
}

verificar_apache() {
    echo "[INFO] Verificando Apache..." | tee -a "$LOG_FILE"
    if command -v apache2 &>/dev/null; then
        echo "[OK] Apache esta instalado." | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Apache nao encontrado." | tee -a "$LOG_FILE"
        return 1
    fi
    if pgrep apache2 &>/dev/null; then
        echo "[OK] Apache em execucao." | tee -a "$LOG_FILE"
    else
        echo "[AVISO] Apache nao esta rodando como processo separado (normal em Docker)." | tee -a "$LOG_FILE"
    fi
}

versao_apache() {
    echo "[INFO] Versao do Apache:" | tee -a "$LOG_FILE"
    apache2 -v 2>&1 | tee -a "$LOG_FILE"
    echo "[INFO] Versao do ImageMagick:" | tee -a "$LOG_FILE"
    convert --version 2>&1 | head -3 | tee -a "$LOG_FILE"
}

echo "============================================"
echo "  [FOTOSOCIAL] Apache + ImageMagick"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
instalar_apache
verificar_apache
versao_apache
echo "[OK] Ambiente web configurado!" | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"