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
######                     PARTE 1:                     ######
######     Formatação e instalação do sistema base      ######
######                                                  ######
##############################################################
##############################################################


"""
read -p "Pressione enter para iniciar... "


# Fontes, locales e mapa do teclado
echo "{[( Configurando fontes, locales e mapa do teclado )]}"
loadkeys br-abnt2
setfont ter-132b
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8

# Conectar a internet pelo Wifi EDUROAM
echo "{[( Conectando a internet pelo Wifi EDUROAM )]}"
systemctl start NetworkManager.service
python ./eduroam-linux-CDTN.py

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

# Instalação do sistema base
echo "{[( Instalando sistema base )]}"
sudo pacman -Sy archlinux-keyring
pacstrap -K /mnt base linux linux-firmware intel-ucode grub efibootmgr nano vim e2fsprogs ntfs-3g networkmanager sudo

# Gerar fstab
echo "{[( Gerando fstab )]}"
genfstab -U /mnt >> /mnt/etc/fstab

# Copiar script para pasta root
echo "{[( Copiando script para pasta root )]}"
cp configGNU.sh /mnt/root

# Fazer chroot e executar script de configuração
echo "{[( Fazendo chroot e executando script de configuração )]}"
arch-chroot /mnt ./configGNU.sh
