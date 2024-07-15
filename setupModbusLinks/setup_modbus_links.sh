!/bin/bash

create_symbolic_link() {
    local device_info=$(udevadm info "$1" | awk -F'/' '/usb1/{if (!found) {for(i=1;i<=NF;i++) if($i ~ /^usb1$/) {print $(i+1); found=1;break}}}')
    if [ "$device_info" = "1-1" ]; then #Porta USB TIPO-C superior
        ln -sf "$1" /dev/modbus/spuChA
    elif [ "$device_info" = "1-2" ]; then #Porta USB TIPO-C inferior
        ln -sf "$1" /dev/modbus/spuChB
    fi
}

# Garantir que exista diretório /dev/modbus/
mkdir -p /dev/modbus/

# Limpar o conteúdo do diretório
rm /dev/modbus/*

# Iterar sobre os dispositivos /dev/ttyUSB*
for device in /dev/ttyUSB*; do
    create_symbolic_link "$device"
done
