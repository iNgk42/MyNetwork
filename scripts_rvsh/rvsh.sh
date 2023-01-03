#!/bin/bash


. ~/MyNetwork/scripts_rvsh/fonctions
con_fil=~/MyNetwork/Conn
Users=~/MyNetwork/Users
user_non_con=~/MyNetwork/result
Mess=~/MyNetwork/Mess

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
						#originuser=$3
						#originhost=$2
						saisie=''
						while [ "$saisie" != "EXITexitSORTIEsortieENDendFINfin" ]
						do
							if [ -r $Mess ]
							then
								while read w1 w2
								do
									if [ $3 == $w1 ]
									then
										echo "$3@$2> "
										./wall_fonction $3
									fi
								done < $Mess
							fi
							prompt $3 $2 saisie

							arg=$(echo $saisie | awk '{print $2}')
							comm=$(echo $saisie | awk '{print $1}')
							
							if [ "$comm" == "rvecho" ]
							then
								rvecho "$saisie"
							else
								if [ "$comm" == "rconnect" ]
								then
									if [ ! -z $arg ]
									then
										rsu_tTy=$(tty | awk -F/ '{print $4}')
                                                                                rsutempfile=~/MyNetwork/sufile.temp_$2_$rsu_tTy
										if [ ! -r $rsutempfile ]
                                                                                then
											rconnect $3 $arg
											if [ $? -eq 1 ]
											then
												rco_tTy=$(tty | awk -F/ '{print $4}')
												Crcotempfile=~/MyNetwork/rcofile.temp_$3_$rco_tTy
												echo "$2" >> $Crcotempfile
												set 'connect' $arg $3
											fi
										else
											echo " Impossible d'utiliser rconnect en mode su"
										fi
									else
										echo " Usage : rconnect machine-name" 
									fi

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
											    "rvi $arg") rvi $2 $3 $arg;;
												   rls) rls $2 $3;;
											    "rrm $arg") rrm $2 $3 $arg;;
			   								 "finger $arg") finger $2 $arg;;
												passwd) passwd $3;;
												 clear) clear;;	
											     "su $arg")	su $arg $2 
													if [ $? -eq 1 ]
													then
														su_tTy=$(tty | awk -F/ '{print $4}')
														Csutempfile=~/MyNetwork/sufile.temp_$2_$su_tTy
														echo "$3" >> $Csutempfile
														set 'connect' $2 $arg
													fi
													;;

												  exit) Msu_tTy=$(tty | awk -F/ '{print $4}')
													Mrco_tTy=$(tty | awk -F/ '{print $4}')
													Msutempfile=~/MyNetwork/sufile.temp_$2_$Msu_tTy
													Mrcotempfile=~/MyNetwork/rcofile.temp_$3_$Mrco_tTy

													if [ -r $Msutempfile ]
													then
															previous_user=$(tail -1 $Msutempfile)
															head -n -1 $Msutempfile >> ~/MyNetwork/eexiit.tmp
															cat ~/MyNetwork/eexiit.tmp > $Msutempfile
															rm ~/MyNetwork/eexiit.tmp

															editConn $3 $2 del
															set "connect" $2 $previous_user

															if [ $(wc -w < $Msutempfile) -eq 0 ]
															then
																rm $Msutempfile
															fi

													else
														if [ -r $Mrcotempfile ]
														then
															previous_host=$(tail -1 $Mrcotempfile)
                                                                                                                        head -n -1 $Mrcotempfile >> ~/MyNetwork/eexxiit.tmp
                                                                                                                        cat ~/MyNetwork/eexxiit.tmp > $Mrcotempfile
                                                                                                                        rm ~/MyNetwork/eexxiit.tmp

                                                                                                                        editConn $3 $2 del
                                                                                                                        set "connect" $previous_host $3

                                                                                                                        if [ $(wc -w < $Mrcotempfile) -eq 0 ]
                                                                                                                        then
                                                                                                                                rm $Mrcotempfile
                                                                                                                        fi
														else
															saisie="EXITexitSORTIEsortieENDendFINfin"
															editConn $3 $2 del
														fi
													fi;;

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
			roothost="roothost"
			rootuser="root"
                        # # # # # # # # # # # # # # # # # # # #code Cédric# # # # # # # # # #
                        
			cpt=0
			while  [ $cpt -lt 3 ]
			do
				read -p "mot de passe pour le mode admin(vous avez $((3-$cpt)) tentatives) : " password
				if [ -z "$password" ] #empeche l'erreur nbre param de la fonction user_password
				then
					password="NULL"
				fi
				user_password $rootuser "$password"
				if [ $? -eq 1 -a -n "$password" ]; then
			        	cpt=4
				else
					echo "Mot de passe incorrect "
					((cpt ++ ))
				fi
			done
			#####si il entre le bon mot de  passe
			if [ $cpt -eq 4 ] ;then
		    		saisie="moi"
				editConn $rootuser $roothost add
		    		while [ "$saisie" != "EXITexitSORTIEsortieENDendFINfin" ]
		    		do
		      			admin_prompt "root" "hostroot" saisie
		  			cob=$(echo $saisie | awk '{print $1}')
					Arg=$(echo $saisie | awk '{print $2}')
					Comm=$(echo $saisie | awk '{print $1}')
		    			if [ "$cob" == "wall" ];then
						echo  $saisie >> ~/MyNetwork/brouillon
						read w1 w2 w3 < ~/MyNetwork/brouillon
						rm ~/MyNetwork/brouillon
						if [ "$w2" == "-n" ];then
				 			#no=$w3
				 			while read w1 w2
				 			do
								if [ $w1 != $rootuser ]
								then
									a=$(echo $w2 | cut -f4 -d' ' | cut -c4 )
                                                                	echo -e "\n" >> /dev/pts/$a
                                                                	echo "  INCOMING MESSAGE">> /dev/pts/$a
                                                                	echo "  Sender: Administrateur" >> /dev/pts/$a
                                                                	echo -e "  Time: $(date | sed 's/CET//')\n" >> /dev/pts/$a
                                                                	echo "  CONTENU:" >> /dev/pts/$a
                                                                	echo "  $w3" >> /dev/pts/$a

				   					echo "$w1" >> ~/MyNetwork/mess
								fi
				 			done<$con_fil
				 			
				 			while read w1 w2
				   			do
				    				echo $w1 >> ~/MyNetwork/ken
				  			done<$Users
							diff --old-line-format='%L' --unchanged-line-format= --new-line-format= <(sort ~/MyNetwork/ken) <(sort ~/MyNetwork/mess) > ~/MyNetwork/result
				 			if [ -s ~/MyNetwork/result ];then
				      				while  read w1;do
				         				q=$(date +"%c")
				       					echo "$w1 $q $w3" >> ~/MyNetwork/Mess
				  				done<$user_non_con
				      				rm -f ~/MyNetwork/result
				      				rm -f ~/MyNetwork/ken
				      				rm -f ~/MyNetwork/mess
				  			else
			     					echo "Tous les utilisateurs sont connectés"
			  				fi
		  				else
			    				echo $saisie >> ~/MyNetwork/brouillon
			    				read w1 w2 < ~/MyNetwork/brouillon
			    				rm ~/MyNetwork/brouillon
			    				no=$w2
			    				while read w1 w2
			     	 			do
								if [ $w1 != "root"  ]
								then
				    					a=$(echo $w2 | cut -f4 -d' ' | cut -c4 )
									echo -e "\n" >> /dev/pts/$a
                							echo "  INCOMING MESSAGE">> /dev/pts/$a
               				 				echo "  Sender: Administrateur" >> /dev/pts/$a
                							echo -e "  Time: $(date | sed 's/CET//')\n" >> /dev/pts/$a
                							echo "  CONTENU:" >> /dev/pts/$a
                							echo "  $no" >> /dev/pts/$a
								fi
			     	 			done<$con_fil
                					echo -e "  \nMessage sent succesfully !"
			     			fi
		    			else
		    				if [ "$Comm" == "rvecho" ]
		    				then
		    					rvecho "$saisie"
		    				else
		    					if [ "$Comm" == "write" ]
		    					then
								write_file_tmp=~/MyNetwork/write.tmp
								echo $saisie >> $write_file_tmp
								read wcomm wdest wmess < $write_file_tmp
                						rm $write_file_tmp
										
								write $rootuser $roothost $wdest "$wmess"
		    					else
				    				if [ ! -z "$saisie" ]
				    				then
						  			case $saisie in
										"?") command_list_admin;;
							 		      rhost) rhost $roothost;;
							 			who)  who $roothost ;;
		   							     rusers) rusers;;
									     finger) finger $roothost;;
									     passwd) passwd $rootuser;;
									 "rvi $Arg") rvi $roothost $rootuser $Arg;;
								       	        rls) rls $roothost $rootuser;;
									 "rrm $Arg") rrm $roothost $rootuser $Arg;;
					   			      "finger $Arg") finger $roothost $Arg;;
							 		  "host -a") ./addhost;;
							 		  "host -d") ./delhost;;
							 	       	  "user -D") ./ajout_droit;;
							 		  "user -a") ./adduser.sh;;
							 		  "user -d") ./deluser;;
							 		  "host -D") ./ajout_droit_machine  ;;
							 		    afinger) ./afinger      ;;
							 		      clear) clear;;
							 		       exit) saisie="EXITexitSORTIEsortieENDendFINfin"
										     editConn $rootuser $roothost del;;
							    			  *) echo -e "\n $Comm : Unknown command or bad arguments"
						  				     echo -e " type '?' to see available commands\n";;

						      			esac
				      				fi
				      			fi
				      		fi
		       			fi
				done
			else
		     		echo "Trop de tentatives"

                        fi
                        # # # # # # # # # # # # # # # # # # # #code Cédric# # # # # # # # # #
                else
			usage
        	fi
	else
		usage
	fi
fi
