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
######     Configuração do ArchIso (internet, etc.)     ######
######                                                  ######
##############################################################
##############################################################


"""
read -p "Pressione enter para iniciar... "

set -e

# Fontes, locales e mapa do teclado
echo "{[( Configurando fontes, locales e mapa do teclado )]}"
loadkeys br-abnt2
#setfont ter-132b
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8

# Conectar a internet pelo Wifi EDUROAM
echo "{[( Conectando a internet pelo Wifi EDUROAM )]}"
systemctl start wpa_supplicant.service
mkdir -p /root/.config
python ./eduroam-linux-CDTN.py
wpa_supplicant -B -i wlan0 -c /root/.config/cat_installer/cat_installer.conf
