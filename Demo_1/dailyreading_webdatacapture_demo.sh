#!/bin/bash



readonly drSavedir="data"


source src/headerdesign.sh
source src/webdatacapture.sh "$drSavedir/"


readonly paraNames=("1st Reading" "Psalm" "Gospel" "2nd Reading")
readonly endClues=('</h1>' '</h3>' '<br>' '</h3>' '<br>' '</h3>' '<br>' '</h3>' '<br>')
readonly startClues=('<h1 class="page-title">' '<h3>Reading 1, ' '<p>' '<h3>Responsorial Psalm, ' '<p>' \
			'<h3>Gospel, ' '<p>' '<h3>Reading 2, ' '<p>')
readonly url="https://www.catholic.org/bible/daily_reading/?select_date="`date +%F`
readonly changesfilelist=("dr3.txt" "dr5.txt" "dr7.txt" "dr9.txt")
readonly drSavefile="drtemp.txt"
readonly drSavefilename="dr"


phaseDataCompleted=""
changesfilepath=""
headingString=""
phaseData=""
tmpPos1=0
count=0


# Parameter 1 - Filepath
# Parameter 2 - Return String	[ REFERENCE ]
function_readfile()
{
	local filepath=$1
	local -n returnstr=$2
	returnstr=""

	while read -r -s line
	do
		returnstr+=$line
	done < "$filepath"
}


resize -s 37 150
clear
clear

echo
echo
echo "---------------------------------------------------------"
echo
echo -e "\e[1m WELCOME  TO  DAILY  READING !\e[0m"
echo
echo -e " This program belongs to Mr. Melwyn Francis Carlo."
echo -e "---------------------------------------------------------"
echo
echo
sleep 1

echo " Accessing contents from : "
echo -e "\e[4m $url\e[0m"
echo
echo "  . . ."
echo
echo
sleep 1


mfc_getwebdata "$url" "3" "0" "1" "1" "0" "0" "$drSavedir" "$drSavefilename" "${startClues[@]}" "${endClues[@]}"

if [ $mfc_getwebdata_success -eq 1 ]; then

	echo
	echo
	echo "Preparing contents . . ."

	mfc_removetags "$drSavedir" "$drSavefilename" "0" "0"

	if [ $mfc_removetags_success -eq 1 ]; then

		count=0
		while :
		do
			data=""
			newdata=""
			changesfilepath="$drSavedir/${changesfilelist[$count]}"
			if [ -f $changesfilepath ]; then
				while read -r -s line
				do
					data+="$line"
				done < "$changesfilepath"
				mfc_remove "$data" "2" newdata
				echo "$newdata" > "$changesfilepath"
			else
				break
			fi
			let "count++"
		done
		echo " . . . Done"
		sleep 1

		echo
		echo
		echo "Displaying contents . . ."


		headingString=("\n" "WELCOME  TO  DAILY  READING !" "\n" "This program belongs to Mr. Melwyn Francis Carlo." "\n")
		headingString+=("-------------------------------------------------------")

		count="1"
		function_readfile "$drSavedir/$drSavefilename$count.txt" phaseData
		headingString+=("\n" "$phaseData" "\n")
		mfc_scrollheader "100" "" "" "0" "1" "5" "1" "#" "${headingString[@]}"
		phaseDataCompleted+="$mfc_headerdesignresult"

		phaseDataCompleted+="\n\n\n\n"

		count=0
		for ((count = 0 ; count < 4 ; count++))
		do
			let "tmpPos1 = (count * 2) + 2"
			function_readfile "$drSavedir/$drSavefilename$tmpPos1.txt" phaseData
			if [[ "$phaseData" == "" ]]; then
				phaseData=" [ N/A ]"
			fi
			headingString=("${paraNames[$count]} :   $phaseData")
			mfc_rectangularheader "70" "" "0" "1" "2" "5" "1" "1" "2" "" "#" "${headingString[@]}"
			phaseDataCompleted+="$mfc_headerdesignresult"
			phaseDataCompleted+="\n\n"
			let "tmpPos1 = (count * 2) + 3"
			function_readfile "$drSavedir/$drSavefilename$tmpPos1.txt" phaseData
			if [[ "$phaseData" == "" ]]; then
				phaseData=" [ No '${paraNames[$count]}' today. ]"
			fi
			phaseDataCompleted+="$phaseData"
			phaseDataCompleted+="\n\n\n\n\n"
		done

		echo "$phaseDataCompleted" > "$drSavedir/$drSavefile"

		sleep 0.5
		whiptail --textbox "$drSavedir/$drSavefile" --scrolltext 37 150
		echo " . . . Done"


	else
		echo
		echo
		echo "ERROR MANIPULATING DATA"
	fi
else
	echo
	echo
	echo "ERROR ACCESSING DATA"
fi


sleep 2
echo
echo
echo "----------------------------------------------------"
echo
echo -e "\e[1m THIS PROGRAM HAS ENDED !"
echo
echo -e "\e[0m Thank you for your time."
echo -e "----------------------------------------------------"
echo
echo
sleep 2



