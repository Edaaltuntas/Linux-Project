#!/bin/bash

file=a.txt
add_entry() {

	entry=$(whiptail --fb --inputbox "Add an entry" 10 100 --cancel-button "Cancel" --title "Adding entry" 3>&1 1>&2 2>&3)
	esc=$?
	if [ $esc = 0 ]; then
		if [ -z "$entry" ]; then
			whiptail --fb --msgbox "Sorry, you have to type something." 10 50
		else
			counter="$(echo $entry | xargs)"
			if [ -z "$counter" ]; then
				whiptail --fb --msgbox "no entry added" 10 50
        		return 0
    		fi
    		esc=$?
		echo $entry >> $file
		whiptail --fb --msgbox "Success." 10 50
		fi
	fi
		
	return 0	
}


search() {
	Sentry=$(whiptail --fb --inputbox "Type what you want to find" 10 50 --title "SEARCH"  --nocancel 3>&1 1>&2 2>&3)
	esc=$?
	if [ $esc = 0 ]; then
    	if [ -z "$Sentry" ]; then
      		whiptail --msgbox "Sorry, you have to type something." 10 50
  		else
			if [[ -s $file ]]; then
				s=`cat a.txt | grep "$Sentry"`
				if [[ $s == $Sentry ]]; then
					whiptail --fb --title "Result" --msgbox "Avaliable: $s" --scrolltext 10 50
				else
					whiptail --fb --title "Result" --msgbox "Could not find it" --scrolltext 10 50
				fi

			else
				whiptail --fb --title "Result" --msgbox "No entry added yet." --scrolltext 10 50
			fi
		fi
	fi	
}

listAll() {

		if [[ -s $file ]]; then
		whiptail --title Listing --textbox a.txt --scrolltext 10 50
		else
		whiptail --fb --title "Result" --msgbox "No entry added yet." --scrolltext 10 50
		fi


}


delete() {
	Rentry=$(whiptail --fb --inputbox "Type what you want to delete" 10 50 --title "Delete" 3>&1 1>&2 2>&3)
	esc=$?

		if [[ $esc == 0 ]]; then
			del=$Rentry
			output=`cat a.txt | grep "$del"`
			if [[ $output == $del ]]; then
				sed -i "/^$del/d" a.txt
				whiptail --fb --title "Success" --msgbox "Successfully deleted" 10 50
			else
				whiptail --fb --title "Unsuccessful" --msgbox "Could not find it" 10 50
			fi
		fi
}

quit() {
if (whiptail --fb --title "Exit" --yesno "Are you sure?" --yes-button "I'm sure" --no-button "Cancel" 10 50 ); then
	exit
fi
}

while :; do
	secim=$(whiptail --fb --title "Menu" --menu "Choose what you want to do..." 15 45 5 --nocancel \
		"1)" "Add Entry"   \
		"2)" "List all"  \
		"3)" "Search an entry" \
		"4)" "Delete an entry" \
		"5)" "Exit"  3>&2 2>&1 1>&3)
	case "$secim" in
		"1)") add_entry ;;
		"2)") listAll ;;
		"3)") search ;;
		"4)") delete ;;
		"5)") quit ;;
		*)
		if [ "$?" == "1" ]; then
			quit
		fi
	
	esac
done