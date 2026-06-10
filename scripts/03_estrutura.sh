#!/bin/bash
# Script: 03_estrutura.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Cria estrutura de diretorios tematica

LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/estrutura_$(date +%Y-%m-%d).log"
BASE="/app/fotosocial"
mkdir -p "$LOG_DIR"

limpar_estrutura_antiga() {
    echo "[INFO] Removendo estrutura antiga..." | tee -a "$LOG_FILE"
    rm -rf "$BASE/fotos" "$BASE/albums" "$BASE/thumbnails" "$BASE/usuarios" "$BASE/publicacoes" "$BASE/temp"
    echo "[OK] Estrutura antiga removida." | tee -a "$LOG_FILE"
}

criar_estrutura() {
    echo "[INFO] Criando diretorios da Rede Social de Fotos..." | tee -a "$LOG_FILE"
    mkdir -p "$BASE/fotos/originais"
    mkdir -p "$BASE/fotos/processadas"
    mkdir -p "$BASE/fotos/pendentes_moderacao"
    mkdir -p "$BASE/albums/publicos"
    mkdir -p "$BASE/albums/privados"
    mkdir -p "$BASE/thumbnails/pequeno"
    mkdir -p "$BASE/thumbnails/medio"
    mkdir -p "$BASE/thumbnails/grande"
    mkdir -p "$BASE/usuarios/perfis"
    mkdir -p "$BASE/usuarios/avatares"
    mkdir -p "$BASE/publicacoes/feed"
    mkdir -p "$BASE/publicacoes/stories"
    mkdir -p "$BASE/publicacoes/arquivados"
    mkdir -p "$BASE/temp/uploads"
    mkdir -p "$BASE/logs"
    mkdir -p "$BASE/backups"
    echo "[OK] Diretorios criados." | tee -a "$LOG_FILE"
}

criar_arquivos_iniciais() {
    echo "[INFO] Criando arquivos iniciais..." | tee -a "$LOG_FILE"
    cat > "$BASE/config.txt" <<EOF
PROJETO=fotosocial
VERSAO=1.0.0
MAX_TAMANHO_FOTO_MB=10
FORMATOS_ACEITOS=jpg,jpeg,png,gif,webp
THUMBNAILS_ATIVADO=sim
DATA_CRIACAO=$(date '+%d/%m/%Y %H:%M:%S')
EOF
    touch "$BASE/fotos/originais/.gitkeep"
    touch "$BASE/thumbnails/pequeno/.gitkeep"
    echo "[OK] Arquivos iniciais criados." | tee -a "$LOG_FILE"
}

exibir_estrutura() {
    echo ""
    echo "[INFO] Estrutura criada:"
    find "$BASE" -type d | sort | tee -a "$LOG_FILE"
}

echo "============================================"
echo "  [FOTOSOCIAL] Estrutura de Diretorios"
echo "  $(date '+%d/%m/%Y %H:%M:%S')"
echo "============================================"
limpar_estrutura_antiga
criar_estrutura
criar_arquivos_iniciais
exibir_estrutura
echo ""
echo "[OK] Estrutura pronta!" | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"