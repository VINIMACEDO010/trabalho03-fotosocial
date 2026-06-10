#!/bin/bash
# Script: 07_monitoramento.sh
# Projeto: Infraestrutura para Rede Social de Fotos
# Aluno: Vinicius Policarpo Macedo
# Descricao: Monitoramento de CPU, RAM, disco e Apache

LOG_DIR="/app/fotosocial/logs"
LOG_FILE="$LOG_DIR/monitoramento_$(date +%Y-%m-%d).log"
LIMITE_CPU=80
LIMITE_MEM=80
LIMITE_DISCO=85
mkdir -p "$LOG_DIR"

verificar_cpu() {
    CPU_USO=$(awk '/^cpu / {idle=$5; total=$2+$3+$4+$5+$6+$7+$8; printf "%.0f", (1 - idle/total)*100}' /proc/stat)
    echo "[CPU] Uso atual: ${CPU_USO}%" | tee -a "$LOG_FILE"
    if [ "$CPU_USO" -ge "$LIMITE_CPU" ] 2>/dev/null; then
        echo "[ALERTA] Uso de CPU acima de ${LIMITE_CPU}%!" | tee -a "$LOG_FILE"
    else
        echo "[OK] CPU dentro do limite." | tee -a "$LOG_FILE"
    fi
}

verificar_memoria() {
    MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    MEM_USADA=$(free -m | awk '/^Mem:/{print $3}')
    MEM_LIVRE=$(free -m | awk '/^Mem:/{print $4}')
    MEM_PORCENTO=$(awk "BEGIN {printf \"%.0f\", ($MEM_USADA/$MEM_TOTAL)*100}")
    echo "[RAM] Total: ${MEM_TOTAL}MB | Usada: ${MEM_USADA}MB | Livre: ${MEM_LIVRE}MB (${MEM_PORCENTO}%)" | tee -a "$LOG_FILE"
    if [ "$MEM_PORCENTO" -ge "$LIMITE_MEM" ] 2>/dev/null; then
        echo "[ALERTA] Uso de memoria acima de ${LIMITE_MEM}%!" | tee -a "$LOG_FILE"
    else
        echo "[OK] Memoria dentro do limite." | tee -a "$LOG_FILE"
    fi
}

verificar_disco() {
    DISCO_USO=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    DISCO_INFO=$(df -h / | awk 'NR==2{print "Total:"$2" | Usado:"$3" | Livre:"$4}')
    echo "[DISCO] $DISCO_INFO (${DISCO_USO}% usado)" | tee -a "$LOG_FILE"
    if [ "$DISCO_USO" -ge "$LIMITE_DISCO" ] 2>/dev/null; then
        echo "[ALERTA] Disco acima de ${LIMITE_DISCO}%! Risco para armazenamento de fotos!" | tee -a "$LOG_FILE"
    else
        echo "[OK] Espaco em disco suficiente." | tee -a "$LOG_FILE"
    fi
}

verificar_apache() {
    if pgrep apache2 &>/dev/null; then
        echo "[OK] Apache em execucao - site disponivel." | tee -a "$LOG_FILE"
    else
        echo "[ALERTA] Apache NAO esta em execucao!" | tee -a "$LOG_FILE"
    fi
}

echo "============================================" | tee -a "$LOG_FILE"
echo "  [FOTOSOCIAL] Monitoramento do Sistema" | tee -a "$LOG_FILE"
echo "  $(date '+%d/%m/%Y %H:%M:%S')" | tee -a "$LOG_FILE"
echo "============================================" | tee -a "$LOG_FILE"
echo ""
verificar_cpu
echo ""
verificar_memoria
echo ""
verificar_disco
echo ""
verificar_apache
echo ""
echo "[INFO] Monitoramento concluido." | tee -a "$LOG_FILE"
echo "[INFO] Log salvo em: $LOG_FILE"
echo "============================================"