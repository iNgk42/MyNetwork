#!/bin/bash
. ~/MyNetwork/scripts_rvsh/fonctions
echo "Vous vouleez créer un nouvel utilisateur, veuillez saisir les informations suivantes"
read -p "Entrez son nom : " nom
user_exist $nom
      if [ $? -eq 0 ];then
         read -p "Entrez son mot de passe : "  mpd
         password=$(echo $mpd | base64 | sha256sum | cut -f1 -d' ')
         echo "$nom $password">>~/MyNetwork/Users
         echo "L'utilisateur $nom vient d'etre ajouté au réseau"
      else
         echo "l'utilisateur existe déja"
      fi
