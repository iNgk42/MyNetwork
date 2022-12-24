#!/bin/bash


. ~/MyNetwork/scripts_rvsh/fonctions

if [ $# -eq 3 ]
then
	if [ $1 == '-connect' ]
	then
		machine_exist $2
		if [ $? -eq 1 ]
		then
			user_exist $3
			if [ $? -eq 1 ]
			then
				user_rights $3 $2
				if [ $? -eq 1 ]
				then
					password_cpt=0
					mot_de_passe="NULL"
					while [ $password_cpt -lt 3 ]
					do	
						read -p "password for $3: " mot_de_passe
						if [ -z "$mot_de_passe" ] #empeche l'erreur nbre param de la fonction user_password
						then
							mot_de_passe="NULL"
						fi
						user_password $3 "$mot_de_passe"
						if [ $? -eq 1 ]
						then
							break
						else
							echo "mot de passe incorrect"
							((password_cpt++))
						fi
					done
					
# # # # # # # # # # # # #  # si le mot de passe est correct # # # # #  # # # # # # #

					user_password $3 "$mot_de_passe"
					if [ $? -eq 1 ]
					then
						editConn $3 $2 add 
						saisie=''
						while [ "$saisie" != "EXITexitSORTIEsortieENDendFINfin" ]
						do
							prompt $3 $2 saisie

							arg=$(echo $saisie | awk '{print $2}')
							comm=$(echo $saisie | awk '{print $1}')
							
							if [ "$comm" == "rvecho" ]
							then
								rvecho "$saisie"
							else
								if [ "$comm" == "rconnect" ]
								then
									echo "ici on remet le case de la section du bas"
									echo "apres avoir verifié les param de connexion et on va travailler sur le exit"
									echo "on doit gerer la precedence de connexion avec un fichier"
								else
									if [ "$comm" == "write" ]
									then
										write_file_tmp=~/MyNetwork/write.tmp
										echo $saisie >> $write_file_tmp
								                read wcomm wdest wmess < $write_file_tmp
                								rm $write_file_tmp
										
										write $3 $2 $wdest "$wmess"

									else
										if [ ! -z "$saisie" ]
										then
											case $saisie in
								     
												   "?") commandlist;;	
												 rhost) rhost $2;;
								   				   who) who $2;;
												rusers) rusers;;
												finger) finger $2 ;;
			   								 "finger $arg") finger $2 $arg;;
												passwd) passwd $3;;
												 clear) clear;;	
												  exit)
													saisie="EXITexitSORTIEsortieENDendFINfin"
													editConn $3 $2 del;;
												     *)
													echo -e "\n $comm : Unknown command or bad arguments"
													echo -e " type '?' to see available commands\n";;
											esac
										fi
									fi
								fi
							fi

						done
					else
						echo "		Trop de tentatives"
					fi
				else
					echo "connexion de $3 à $2 impossible: permission denied"
				fi
			else
				echo "l'utilisateur $3 n'esxite pas"
			fi
		else
			echo "la machine $2 n'exite pas"
		fi
	else
		usage
	fi	
else
	if [ $# -eq 1 ]
	then
		if [ $1 == '-admin' ]
                then
                        echo "admin mode coming soon" # # # # # # # # # # # # #code Cédric
                else
			usage
                fi
	else
		usage
	fi
fi
