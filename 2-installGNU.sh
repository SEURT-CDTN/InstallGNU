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
######                     PARTE 2:                     ######
######     Formatação e instalação do sistema base      ######
######                                                  ######
##############################################################
##############################################################


"""
read -p "Pressione enter para iniciar... "

set -e

# Atualizar relógio
echo "{[( Atualizando relógio )]}"
timedatectl

# Configuração das partições
echo "{[( Configuração das partições )]}"
fdisk -l

echo """
# Configuração das partições esperada pelo instalador:
    #/dev/nvme0n1p1 - EFI
    #/dev/nvme0n1p2 - MS Reserved
    #/dev/nvme0n1p3 - Windows CDTN
    #/dev/nvme0n1p4 - Arch
    #/dev/nvme0n1p5 - Debian
    #/dev/nvme0n1p6 - Home
"""
# Formatar a partição raiz
read -p "Deseja formatar a partição raiz (/dev/nvme0n1p4)? [y/N]: " formatar_raiz
if [[ $formatar_raiz == "y" || $formatar_raiz == "Y" ]]; then
    echo "Formatando partição raiz..."
    mkfs.ext4 /dev/nvme0n1p4
fi

# Formatar a partição home
read -p "Deseja formatar a partição home (/dev/nvme0n1p6)? [y/N]: " formatar_home
if [[ $formatar_home == "y" || $formatar_home == "Y" ]]; then
    echo "Formatando partição home..."
    mkfs.ext4 /dev/nvme0n1p6
fi

# Montar partições
echo "{[( Montando partições )]}"
mount /dev/nvme0n1p4 /mnt
mount --mkdir /dev/nvme0n1p6 /mnt/home
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi

# Configuração dos repositórios
echo "{[( Configurando repositórios )]}"
systemctl stop reflector.service
cp -f mirrorlist /etc/pacman.d/mirrorlist
cp -f pacman.conf /etc/pacman.conf
#pacman -Sy archlinux-keyring
#pacman -Sy

# Instalação do sistema base
echo "{[( Instalando sistema base )]}"
pacstrap -K /mnt base linux linux-firmware intel-ucode grub efibootmgr nano vim e2fsprogs ntfs-3g networkmanager sudo openssh python dbus dbus-python

# Gerar fstab
echo "{[( Gerando fstab )]}"
genfstab -U /mnt >> /mnt/etc/fstab

# Copiar script para pasta root
echo "{[( Copiando script de configuração para pasta root )]}"
cp 3-configGNU.sh /mnt/root
cp eduroam-linux-CDTN.py /mnt/root
cp mirrorlist /mnt/root
cp pacman.conf /mnt/root

# Fazer chroot e executar script de configuração
echo "{[( Fazendo chroot e executando script de configuração )]}"
arch-chroot /mnt /root/3-configGNU.sh
