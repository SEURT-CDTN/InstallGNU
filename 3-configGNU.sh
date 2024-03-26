#!/bin/bash

echo """
##############################################################
##############################################################
######                                                  ######
######  Instalação do Sistema Operacional GNU para URT  ######
######               Unidade do Reator Triga            ######
######                                                  ######
######          Distribuição: ArchLinux Rolling         ######
######                                                  ######
######         Autor: Thalles Oliveira Campagnani       ######
######                                                  ######
##############################################################
##############################################################
######                                                  ######
######                     PARTE 3:                     ######
######              Configuração do sistema             ######
######                em ambiente chroot                ######
######                                                  ######
##############################################################
##############################################################


"""
read -p "Pressione enter para iniciar... "

# Configurar fuso horário
echo "{[( Configurando fuso horário )]}"
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# Locales e mapa do teclado
echo "{[( Configurando locales e mapa do teclado )]}"
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo """
LANG=pt_BR.UTF-8
LANGUAGE=pt_BR.UTF-8
LC_ADDRESS=pt_BR.UTF-8
LC_COLLATE=pt_BR.UTF-8
LC_CTYPE=pt_BR.UTF-8
LC_IDENTIFICATION=pt_BR.UTF-
LC_MEASUREMENT=pt_BR.UTF-8
LC_MESSAGES=pt_BR.UTF-8
LC_MONETARY=pt_BR.UTF-8
LC_NAME=pt_BR.UTF-8
LC_NUMERIC=pt_BR.UTF-8
LC_PAPER=pt_BR.UTF-8
LC_TELEPHONE=pt_BR.UTF-8
LC_TIME=pt_BR.UTF-8
""" > /etc/locale.conf

# Hostname
echo "{[( Configurando Hostname )]}"
echo "ServidorTriga" > /etc/hostname
echo """
127.0.0.1   localhost
::1         localhost
127.0.1.1   ServidorTriga.localdomain ServidorTriga
""" > /etc/hosts

# Ativando serviço do NetworkManager e SSHD
echo "{[( Ativando serviço do NetworkManager e SSHD )]}"
systemctl enable NetworkManager.service
systemctl enable sshd.service

# Configurar pacman
echo "{[( Configurando pacman )]}"
systemctl disable reflector.service
cp -f /root/mirrorlist /etc/pacman.d/mirrorlist
cp -f /root/pacman.conf /etc/pacman.conf

# Senha do root
echo "{[( Criando senha para root )]}"
passwd

# Criando usuário trigauser
TRIGAUSER=trigauser
echo "{[( Criando usuário $TRIGAUSER e definindo senha )]}"
sudo useradd -m $TRIGAUSER && sudo passwd $TRIGAUSER

while true; do
    # Criando usuários para manutenção
    read -p "Digite o nome do usuário para manutenção (sudo) ou deixe em branco para não criar: " ADDUSER

    # Verificar se o campo está vazio
    if [[ -z $ADDUSER ]]; then
        break
    fi

    # Criar usuário e definir senha
    echo "{[( Criando usuário $ADDUSER e definindo senha )]}"
    sudo useradd -m $ADDUSER && sudo usermod -aG wheel $ADDUSER && sudo passwd $ADDUSER && echo "Usuário $ADDUSER criado com sucesso."

    echo "{[( Você pode adicionar mais usuários para manutenção se quiser )]}"
done

# GRUB
echo "{[( Instalando GRUB na UEFI )]}"
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux
sudo grub-mkconfig -o /boot/grub/grub.cfg
