#!/bin/bash


. ~/MyNetwork/scripts_rvsh/fonctions

write_file_tmp=~/MyNetwork/write.tmp
WConnfile=~/MyNetwork/Conn

if [ $# -ge 4  ]
then
	echo $* >> $write_file_tmp
	read wsenderuser wsenderhost wdest wmess < $write_file_tmp  
	rm $write_file_tmp
	wuser=$(echo $wdest | awk -F@ '{print $1}')
	whost=$(echo $wdest | awk -F@ '{print $2}')
	if [ $(echo $wuser | wc -w) -ne 0 -a $(echo $whost | wc -w) -ne 0 ]
        then
        	user_exist $wuser
        	if [ $? -eq 1 ]
        	then
        		machine_exist $whost
        		if [ $? -eq 1 ]
        		then
                		user_connected $wuser
                		if [ $? -eq 1 ]
                		then
                        		wtty_list=$(awk -v wvuser=$wuser '$1==wvuser {print}' $WConnfile | awk -v wvhost=$whost '$2==wvhost {print $5}')

                        		if [ ! -z $wtty_list ]
                        		then
                                		for wtty in $wtty_list
                                		do
                                        		wnumtty=$(echo $wtty | cut -c4)
							
							echo -e "\n" >> /dev/pts/$wnumtty
							echo "  INCOMING MESSAGE">> /dev/pts/$wnumtty
							echo "  Sender: $wsenderuser@$wsenderhost" >> /dev/pts/$wnumtty
							echo -e "  Time:   $(date | sed 's/CET//')\n" >> /dev/pts/$wnumtty
                                        		echo "  CONTENU:" >> /dev/pts/$wnumtty
                                        		echo "  $wmess" >> /dev/pts/$wnumtty
							echo >> /dev/pts/$wnumtty
                                        	done
                                	else
                                		echo " $user n'est pas connecté sur l'hote $whost"
                                	fi
                        	else
                        		echo " $wuser n'est pas connecté sur le réseau"
                        	fi
                	else
                		echo " la machine $whost n'existe pas"
                	fi
        	else
        		echo " l'utilisateur $wuser n'existe pas"
        	fi
	else
		echo "Usage : write username@machine-name message"
	fi
else
	echo "Usage : write username@machine-name message"
fi


