#!/bin/bash

# Interface e duração padrão
INTERFACE="eth0"
DURACAO=60

# Cria a pasta de capturas se não existir
mkdir -p capturas

menu() {
  clear
  echo "======================================="
  echo "        🎧 PACKETMUSE - MENU           "
  echo "======================================="
  echo "Interface atual: $INTERFACE"
  echo "Duração: $DURACAO segundos"
  echo ""
  echo "1) Captura HTTP"
  echo "2) Captura DNS"
  echo "3) Captura FTP"
  echo "4) Captura Completa"
  echo "5) Definir Interface"
  echo "6) Definir Duração"
  echo "0) Sair"
  echo "---------------------------------------"
  read -p "Escolha uma opção: " opcao

  case $opcao in
    1) capturar "http" ;;
    2) capturar "dns" ;;
    3) capturar "ftp" ;;
    4) capturar "" ;;
    5) definir_interface ;;
    6) definir_duracao ;;
    0) exit 0 ;;
    *) echo "Opção inválida!"; sleep 2 ;;
  esac
  menu
}

capturar() {
  local TIPO="$1"
  local ARQUIVO="capturas/${TIPO:-full}_$(date +%F_%H-%M-%S).pcapng"
  local FILTRO=""

  # Define filtros de captura compatíveis com -f
  if [[ "$TIPO" == "http" ]]; then FILTRO="tcp port 80"; fi
  if [[ "$TIPO" == "dns" ]]; then FILTRO="port 53"; fi
  if [[ "$TIPO" == "ftp" ]]; then FILTRO="port 21"; fi

  echo "[+] Iniciando captura em $INTERFACE por $DURACAO segundos..."
  sleep 1

  if [[ -z "$FILTRO" ]]; then
    tshark -i "$INTERFACE" -a duration:$DURACAO -w "$ARQUIVO"
  else
    tshark -i "$INTERFACE" -f "$FILTRO" -a duration:$DURACAO -w "$ARQUIVO"
  fi

  echo "[+] Captura salva em $ARQUIVO"
  read -p "Pressione Enter para voltar ao menu..."
}

definir_interface() {
  echo "Interfaces disponíveis:"
  tshark -D
  read -p "Digite o número da interface (ex: 1): " num
  INTERFACE=$(tshark -D | sed -n "${num}p" | cut -d ' ' -f 2)
  echo "[+] Interface definida como $INTERFACE"
  sleep 2
}

definir_duracao() {
  read -p "Digite a duração da captura em segundos: " DURACAO
  echo "[+] Duração definida como $DURACAO segundos"
  sleep 2
}

menu
