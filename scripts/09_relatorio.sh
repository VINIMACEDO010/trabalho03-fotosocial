#!/bin/bash
# Script: 09_relatorio.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Gera relatorio operacional completo

LOG_DIR="/app/fotosocial/logs"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"
BASE="/app/fotosocial"
mkdir -p "$LOG_DIR"

iniciar_relatorio() {
    cat > "$RELATORIO" <<EOF
============================================================
  RELATORIO OPERACIONAL - REDE SOCIAL DE FOTOS
============================================================
  Aluno:      Vinicius Policarpo Macedo
  Tema:       14 - Infraestrutura para Rede Social de Fotos
  Curso:      Sistemas de Informacao - UNIDAVI
  Disciplina: Cloud Computing
  Data/Hora:  $(date '+%d/%m/%Y %H:%M:%S')
============================================================

EOF
}

relatorio_disco() {
    echo "--- USO DE DISCO ---" >> "$RELATORIO"
    df -h >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

relatorio_diretorios() {
    echo "--- DIRETORIOS DO PROJETO ---" >> "$RELATORIO"
    du -sh "$BASE"/* 2>/dev/null >> "$RELATORIO" || echo "(vazio)" >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

relatorio_apache() {
    echo "--- STATUS DO APACHE ---" >> "$RELATORIO"
    if pgrep apache2 &>/dev/null; then
        echo "Apache: EM EXECUCAO" >> "$RELATORIO"
        apache2 -v 2>/dev/null >> "$RELATORIO"
    else
        echo "Apache: gerenciado pelo Docker CMD" >> "$RELATORIO"
    fi
    echo "" >> "$RELATORIO"
}

relatorio_backups() {
    echo "--- BACKUPS DISPONIVEIS ---" >> "$RELATORIO"
    ls -lh "$BASE/backups"/*.tar.gz 2>/dev/null >> "$RELATORIO" || echo "Nenhum backup encontrado." >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

relatorio_logs() {
    echo "--- LOGS GERADOS ---" >> "$RELATORIO"
    ls -lh "$LOG_DIR"/*.log 2>/dev/null >> "$RELATORIO" || echo "Nenhum log encontrado." >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

relatorio_publicados() {
    echo "--- ARQUIVOS NO APACHE ---" >> "$RELATORIO"
    ls -lh /var/www/html/ 2>/dev/null >> "$RELATORIO" || echo "Nao acessivel." >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

relatorio_usuarios() {
    echo "--- USUARIOS E GRUPOS ---" >> "$RELATORIO"
    getent group foto_ops foto_moderacao 2>/dev/null >> "$RELATORIO" || echo "Grupos nao encontrados." >> "$RELATORIO"
    id thumb_worker 2>/dev/null >> "$RELATORIO" || echo "thumb_worker: nao encontrado" >> "$RELATORIO"
    id foto_moderador 2>/dev/null >> "$RELATORIO" || echo "foto_moderador: nao encontrado" >> "$RELATORIO"
    echo "" >> "$RELATORIO"
}

finalizar_relatorio() {
    cat >> "$RELATORIO" <<EOF
============================================================
  FIM DO RELATORIO
  Gerado por: 09_relatorio.sh
============================================================
EOF
}

echo "============================================"
echo "  [FOTOSOCIAL] Gerando Relatorio Operacional"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
iniciar_relatorio
relatorio_disco
relatorio_diretorios
relatorio_apache
relatorio_backups
relatorio_logs
relatorio_publicados
relatorio_usuarios
finalizar_relatorio
echo "[OK] Relatorio gerado!"
echo "[INFO] Salvo em: $RELATORIO"
echo ""
cat "$RELATORIO"
echo "============================================"