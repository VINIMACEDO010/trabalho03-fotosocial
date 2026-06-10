#!/bin/bash
# Script: 04_backup.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Backup automatizado dos dados da rede social

ORIGEM="/app/fotosocial"
DESTINO="/app/fotosocial/backups"
LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/backup_$(date +%Y-%m-%d).log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)
NOME_BACKUP="backup_fotosocial_${TIMESTAMP}.tar.gz"
CAMINHO_BACKUP="$DESTINO/$NOME_BACKUP"
mkdir -p "$DESTINO" "$LOG_DIR"

realizar_backup() {
    echo "[INFO] Iniciando backup da Rede Social de Fotos..." | tee -a "$LOG_FILE"
    echo "[INFO] Destino: $CAMINHO_BACKUP" | tee -a "$LOG_FILE"
    if tar -czf "$CAMINHO_BACKUP" \
        --exclude="fotosocial/backups" \
        -C "$(dirname "$ORIGEM")" \
        "$(basename "$ORIGEM")" 2>> "$LOG_FILE"; then
        echo "[OK] Backup criado: $NOME_BACKUP" | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Falha ao criar backup." | tee -a "$LOG_FILE"
        exit 1
    fi
}

validar_backup() {
    echo "[INFO] Validando backup..." | tee -a "$LOG_FILE"
    if [ -f "$CAMINHO_BACKUP" ]; then
        TAMANHO=$(du -sh "$CAMINHO_BACKUP" | cut -f1)
        echo "[OK] Backup validado! Tamanho: $TAMANHO" | tee -a "$LOG_FILE"
        echo "[INFO] Conteudo (primeiros 10 itens):" | tee -a "$LOG_FILE"
        tar -tzf "$CAMINHO_BACKUP" 2>/dev/null | head -10 | tee -a "$LOG_FILE"
    else
        echo "[ERRO] Arquivo de backup nao encontrado!" | tee -a "$LOG_FILE"
        exit 1
    fi
}

listar_backups() {
    echo ""
    echo "[INFO] Backups disponiveis:"
    ls -lh "$DESTINO"/*.tar.gz 2>/dev/null | tee -a "$LOG_FILE" \
        || echo "[INFO] Nenhum backup anterior encontrado." | tee -a "$LOG_FILE"
}

echo "============================================"
echo "  [FOTOSOCIAL] Backup Automatizado"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
realizar_backup
validar_backup
listar_backups
echo ""
echo "[OK] Backup concluido!" | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"