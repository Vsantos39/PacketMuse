#!/bin/bash

# Cores para terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar dependências
if ! command -v tshark &> /dev/null; then
    echo -e "${RED}Erro: TShark não está instalado.${NC}"
    echo "Instale com: sudo apt install tshark"
    exit 1
fi

# Verificar argumentos
if [ -z "$1" ]; then
    echo -e "${RED}Uso: $0 <arquivo.pcapng> [saida]${NC}"
    exit 1
fi

INPUT="$1"
OUTPUT="${2:-credenciais}"
TS=$(date +"%Y-%m-%d_%H-%M-%S")

# Extrair HTTP
echo -e "${YELLOW}Analisando HTTP...${NC}"
tshark -r "$INPUT" -Y 'http.request.method == "POST"' -T fields \
  -e frame.time -e ip.src -e ip.dst -e http.host -e http.request.uri \
  > "${OUTPUT}_http_${TS}.tmp"

# Extrair FTP
echo -e "${YELLOW}Analisando FTP...${NC}"
tshark -r "$INPUT" -Y 'ftp.request.command == "USER" || ftp.request.command == "PASS"' -T fields \
  -e frame.time -e ip.src -e ip.dst -e ftp.request.command -e ftp.request.arg \
  > "${OUTPUT}_ftp_${TS}.tmp"

# Gerar saída formatada
echo -e "${GREEN}Gerando relatório...${NC}"
{
    echo "=== RELATÓRIO PACKETMUSE ==="
    echo "Data: $TS"
    echo "Arquivo analisado: $INPUT"
    echo ""
    
    echo "=== CREDENCIAIS HTTP ==="
    awk 'BEGIN {FS="\t"; OFS=" | "} {
        print "Hora:", $1, "\nOrigem:", $2, "\nDestino:", $3, "\nHost:", $4, "\nURI:", $5, "\n"
    }' "${OUTPUT}_http_${TS}.tmp"
    
    echo "=== CREDENCIAIS FTP ==="
    awk 'BEGIN {FS="\t"; OFS=" | "} {
        print "Hora:", $1, "\nOrigem:", $2, "\nDestino:", $3, "\nComando:", $4, "\nArgumento:", $5, "\n"
    }' "${OUTPUT}_ftp_${TS}.tmp"
} > "${OUTPUT}_${TS}.txt"

# Limpar temporários
rm "${OUTPUT}"_*".tmp"

echo -e "${GREEN}Relatório salvo em: ${OUTPUT}_${TS}.txt${NC}"
