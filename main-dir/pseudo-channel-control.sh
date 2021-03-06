#!/bin/bash
source config.cache
re='^[0-9]+$'
number_of_channels=$(ls | grep pseudo-channel_ | wc -l)
clear
echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
echo "Choose a CATEGORY"
select category in "CONTROL" "EDIT" "UPDATE" "EXIT"
	do
	sleep 1
	clear
	echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
	if [[ "$category" == "CONTROL" ]]
		then
		echo "PSEUDO CHANNEL CONTROL OPTIONS"
		select pseudo_channel_do in "START CHANNEL" "NEXT CHANNEL" "PREVIOUS CHANNEL" "STOP CHANNEL" "BACK"
			do
			sleep 1
			clear
			echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
			if [[ "$pseudo_channel_do" == "START CHANNEL" ]]
				then
				echo "PSEUDO CHANNEL - START CHANNEL"
				echo "Enter CHANNEL NUMBER between 1 and $number_of_channels"
				read -p "Channel: " channel_number
				while ! [[ $channel_number =~ $re ]] # VALIDATES THAT CHANNEL NUMBER IS ACTUALLY A NUMBER
					do
					echo "Enter CHANNEL NUMBER between 1 and $number_of_channels"
					read -p "Channel: " channel_number
				done
				while ! [[ $channel_number -ge 1 && $channel_number -le $number_of_channels ]]
					do
					echo "ERROR: Channel NOT FOUND."
					echo "Channels must be between 1 and $number_of_channels"
					echo "Enter CHANNEL NUMBER"
					read -p 'Channel: ' channel_number
				done
				if [[ $channel_number -ge 1 && $channel_number -le 9 ]]
					then
					(sudo ./manual.sh 0"$channel_number")
					else
					(sudo ./manual.sh "$channel_number")
				fi
				break
			fi
                        if [[ "$pseudo_channel_do" == "NEXT CHANNEL" ]]
                                then
				(sudo ./channelup.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "PREVIOUS CHANNEL" ]]
                                then
				(sudo ./channeldown.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "STOP CHANNEL" ]]
                                then
				(sudo ./stop-all-channels.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "BACK" ]]
                                then
				break
                        fi
		sleep 1
	        clear
        	echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
		echo "PSEUDO CHANNEL CONTROL OPTIONS"
		echo "1) START CHANNEL 3) PREVIOUS CHANNEL 5) BACK"
		echo "2) NEXT CHANNEL  4) STOP CHANNEL"
		done
	fi
	if [[ "$category" == "EDIT" ]]
                then
                sleep 1
                clear
                echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
		echo "PSEUDO CHANNEL EDIT OPTIONS"
		select pseudo_channel_do in "EDIT SCHEDULE" "EDIT CONFIG" "ADD CLIENT" "BACK"
			do
	                sleep 1
        	        clear
                	echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
                        if [[ "$pseudo_channel_do" == "EDIT SCHEDULE" ]]
                                then
				(sudo ./schedule-editor.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "EDIT CONFIG" ]]
                                then
				(sudo ./config_editor.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "ADD CLIENT" ]]
                                then
				echo "SELECT the PLEX CLIENT for the NEW CLIENT SETUP or ENTER one manually"
				clientlist=$(xmllint --xpath "//Server/@name" "http://$server_ip:$server_port/clients" | sed "s|name=||g" | sed "s|^ ||g" && echo -e " Other")
				eval set $clientlist
				select create_box_client in "$@"
					do
					if [[ "$create_box_client" == "Other" ]]
						then
						read -p 'Client Name: ' create_box_client
						create_box_client=$(eval echo $create_box_client)
					fi
				break
				done
				(sudo ./create_box.sh "$create_box_client")
                        fi
                        if [[ "$pseudo_channel_do" == "BACK" ]]
                                then
				break
                        fi
		sleep 1
		clear
		echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
		echo "PSEUDO CHANNEL EDIT OPTIONS"
		echo "1) EDIT SCHEDULE"
		echo "2) EDIT CONFIG"
		echo "3) ADD CLIENT"
		echo "4) BACK"
		done
        fi
        if [[ "$category" == "UPDATE" ]]
                then
		echo "PSEUDO CHANNEL UPDATE OPTIONS"
		select pseudo_channel_do in "DATABASE UPDATE" "SOFTWARE UPDATE" "BACK"
			do
	                sleep 1
        	        clear
                	echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
                        if [[ "$pseudo_channel_do" == "DATABASE UPDATE" ]]
                                then
				echo "Select DATABASE to UPDATE"
				select update_database in "TV Shows" "Movies" "Commercials" "All"
					do
				if [[ "$update_database" == "TV Shows" ]]
					then
					(sudo python Global_DatabaseUpdate.py -ut)
				elif [[ "$update_database" == "Movies" ]]
					then
					(sudo python Global_DatabaseUpdate.py -um)
				elif [[ "$update_database" == "Commercials" ]]
					then
					(sudo python Global_DatabaseUpdate.py -uc)
				elif [[ "$update_database" == "All" ]]
					then
					(sudo python Global_DatabaseUpdate.py -u)
				fi
				break
				done
                        fi
                        if [[ "$pseudo_channel_do" == "SOFTWARE UPDATE" ]]
                                then
				(sudo ./update-channels-from-git.sh)
                        fi
                        if [[ "$pseudo_channel_do" == "BACK" ]]
                                then
				break
                        fi
		sleep 1
		clear
		echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
		echo "PSEUDO CHANNEL UPDATE OPTIONS"
		echo "1) DATABASE UPDATE"
		echo "2) SOFTWARE UPDATE"
		echo "3) BACK"
		done
        fi
        if [[ "$category" == "EXIT" ]]
                then
		echo "EXITING PSEUDO CHANNEL CONTROL SCRIPT..."
		sleep 1
		clear
		exit
        fi
sleep 1
clear
echo "+++++++++++++++++++++++++++PSEUDO CHANNEL+++++++++++++++++++++++++++"
echo "Choose a CATEGORY"
echo "1) CONTROL"
echo "2) EDIT"
echo "3) UPDATE"
echo "4) EXIT"
done
