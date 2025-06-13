# PacketMuse 🔍

Ferramenta para extração de credenciais HTTP/FTP de arquivos `.pcapng`.

## 🚀 Como Usar
```bash
./PacketMuse-Harvester.sh arquivo_captura.pcapng
```
Saída: `credenciais_<data>.txt`

## 📦 Requisitos
- Kali Linux (ou distro com `tshark`)
- Wireshark/TShark instalado:
  ```bash
  sudo apt install tshark
  ```

## ✨ Features
- Extrai:
  - HTTP (POST): URLs, parâmetros, timestamps
  - FTP: Comandos USER/PASS
- Saída formatada em texto claro

## 📌 Exemplo de Saída
```
=== CREDENCIAIS HTTP ===
Hora: Jun 16, 2025 10:30:00 
Origem: 192.168.1.100 | Destino: 10.0.0.1 
Host: example.com 
URI: /login.php?user=admin&pass=123
```

## 📄 Licença
GPLv3 - Veja [LICENSE](LICENSE).
