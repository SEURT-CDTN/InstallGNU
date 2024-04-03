# setupModbusLinks

O objetivo deste script é criar os links simbolicos em `/dev/modbus` com nomes correspondentes a cada respectivo dispositivo conectado, baseado em posições das portas USB:

- 1-5 (Porta USB trazeira superior direita): Spu ChA
- 1-6 (Porta USB trazeira superior esquerda): Spu ChB

## Instalação

Copie o arquivo `setup_modbus_links.sh` para `/usr/local/bin/`:

```Bash
sudo cp setup_modbus_links.sh /usr/local/bin/
```

Copie o arquivo `setup_modbus_links.service` para `/etc/systemd/system/`:

```Bash
sudo cp setup_modbus_links.service /etc/systemd/system/
```

Ative o serviço pelo systemd:

```Bash
sudo systemctl enable setup_modbus_links --now
```

## Uso

O script é executado automaticamente quando o computador inicia. Caso haja alteração no hardware (como conectar novas portas) é necessário executar o script novamente com:

```Bash
sudo systemctl restart setup_modbus_links
```
