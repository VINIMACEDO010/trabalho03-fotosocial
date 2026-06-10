#!/bin/bash
# Script: 08_usuarios_permissoes.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Criacao de usuarios, grupos e permissoes

LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/usuarios_$(date +%Y-%m-%d).log"
BASE="/app/fotosocial"
mkdir -p "$LOG_DIR"

criar_grupos() {
    echo "[INFO] Criando grupos..." | tee -a "$LOG_FILE"
    if ! getent group foto_ops &>/dev/null; then
        groupadd foto_ops
        echo "[OK] Grupo 'foto_ops' criado (operadores de fotos)." | tee -a "$LOG_FILE"
    else
        echo "[INFO] Grupo 'foto_ops' ja existe." | tee -a "$LOG_FILE"
    fi
    if ! getent group foto_moderacao &>/dev/null; then
        groupadd foto_moderacao
        echo "[OK] Grupo 'foto_moderacao' criado (moderadores)." | tee -a "$LOG_FILE"
    else
        echo "[INFO] Grupo 'foto_moderacao' ja existe." | tee -a "$LOG_FILE"
    fi
}

criar_usuarios() {
    echo "[INFO] Criando usuarios..." | tee -a "$LOG_FILE"
    if ! id "thumb_worker" &>/dev/null; then
        useradd -r -s /bin/false -g foto_ops -c "Worker de Thumbnails" thumb_worker
        echo "[OK] Usuario 'thumb_worker' criado." | tee -a "$LOG_FILE"
    else
        echo "[INFO] Usuario 'thumb_worker' ja existe." | tee -a "$LOG_FILE"
    fi
    if ! id "foto_moderador" &>/dev/null; then
        useradd -r -s /bin/false -g foto_moderacao -c "Moderador de Fotos" foto_moderador
        echo "[OK] Usuario 'foto_moderador' criado." | tee -a "$LOG_FILE"
    else
        echo "[INFO] Usuario 'foto_moderador' ja existe." | tee -a "$LOG_FILE"
    fi
}

configurar_permissoes() {
    echo "[INFO] Configurando permissoes..." | tee -a "$LOG_FILE"
    mkdir -p "$BASE"/{fotos/originais,fotos/pendentes_moderacao,thumbnails,logs,backups}
    chown -R root:foto_ops "$BASE/fotos/originais"
    chmod -R 750 "$BASE/fotos/originais"
    echo "[OK] $BASE/fotos/originais -> root:foto_ops (chmod 750)" | tee -a "$LOG_FILE"
    chown -R root:foto_moderacao "$BASE/fotos/pendentes_moderacao"
    chmod -R 770 "$BASE/fotos/pendentes_moderacao"
    echo "[OK] $BASE/fotos/pendentes_moderacao -> root:foto_moderacao (chmod 770)" | tee -a "$LOG_FILE"
    chown -R root:foto_ops "$BASE/thumbnails"
    chmod -R 755 "$BASE/thumbnails"
    echo "[OK] $BASE/thumbnails -> root:foto_ops (chmod 755)" | tee -a "$LOG_FILE"
    chown -R root:root "$BASE/backups"
    chmod -R 700 "$BASE/backups"
    echo "[OK] $BASE/backups -> root:root (chmod 700)" | tee -a "$LOG_FILE"
}

exibir_resumo() {
    echo ""
    echo "[INFO] Grupos criados:"
    getent group foto_ops foto_moderacao 2>/dev/null | tee -a "$LOG_FILE"
    echo ""
    echo "[INFO] Usuarios criados:"
    id thumb_worker 2>/dev/null | tee -a "$LOG_FILE"
    id foto_moderador 2>/dev/null | tee -a "$LOG_FILE"
    echo ""
    echo "[INFO] Permissoes do diretorio base:"
    ls -la "$BASE" 2>/dev/null | tee -a "$LOG_FILE"
}

echo "============================================"
echo "  [FOTOSOCIAL] Usuarios e Permissoes"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
criar_grupos
criar_usuarios
configurar_permissoes
exibir_resumo
echo ""
echo "[OK] Usuarios e permissoes configurados!" | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"