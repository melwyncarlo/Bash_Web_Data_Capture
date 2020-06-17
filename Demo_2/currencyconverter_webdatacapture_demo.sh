#!/bin/bash



readonly curconvSavedir="data"



source src/headerdesign.sh
source src/webdatacapture.sh "$curconvSavedir/"



readonly currency_list=("Indian Rupee" "Malaysian Ringgit" "Singapore Dollar" "Japanese Yen" "Bangladeshi Taka" "Chinese Yuan" \
			"Hong Kong Dollar" "Indonesian Rupiah" "Cambodian Riel" "South Korean Won" "Lao Kip" "Sri Lankan Rupee" \
			"Maldivian Rufiyaa" "Nepalese Rupee" "Philippine Peso" "Pakistani Rupee" "Thai Baht" "Taiwanese Dollar" \
			"Vietnamese Dong" \
			"European Euro" "British Pound Sterling" "Swiss Franc" "Bosnia and Herzegovina convertible mark" "Bulgarian Lev" \
			"Czech Koruna" "Danish Krone" "Croatian Kuna" "Hungarian Forint" "Icelandic Krona" "Moldovan Leu" \
			"Macedonian Denar" "Norwegian Krone" "Polish Zloty" "Romanian Leu" "Serbian Dinar" "Russian Rouble" \
			"Swedish Krona" "Turkish Lira" "Ukraine Hryvnia" \
			"United Arab Emirates Dirham" "Saudi Riyal" "Omani Rial" "Bahraini Dinar" "Israeli Sheqel" "Iranian Rial" \
			"Jordanian Dinar" "Kuwaiti Dinar" "Lebanese Pound" "Qatari Riyal" "Syrian Pound" \
			"United States Dollar" "Canadian Dollar" "Aruban Florin" "Barbadian Dollar" "Bermudian Dollar" \
			"Bahamian Dollar" "Dominican Peso" "Guatemalan Quetzal" "Jamaican Dollar" "Mexican Peso" \
			"Panamanian Balboa" "East Caribbean Dollar" \
			"Australian Dollar" "Fijian Dollar" "New Zealand Dollar" "CFP Franc" \
			"Argentine Peso" "Bolivian Boliviano" "Brazilian Real" "Chilean Peso" "Colombian Peso" "Peruvian Sol" \
			"Paraguayan Guaraní" "Uruguayan Peso" "Venezuelan Bolívar" \
			"South African Rand" "Egyptian Pound" "Ghana Cedi" "Gambian Dalasi" "Kenyan Shilling" "Moroccan Dirham" \
			"Malagasy Ariary" "Mauritian Rupee" "Namibian Dollar" "Nigerian Naira" "Seychellois Rupee" "Tunisian Dinar" \
			"Ugandan Shilling" "Central African CFA Franc" "West African CFA Franc")

readonly currency_code=("INR" "MYR" "SGD" "JPY" "BDT" "CNY" "HKD" "IDR" "KHR" "KRW" "LAK" "LKR" "MVR" "NPR" "PHP" "PKR" "THB" "TWD" "VND" \
			"EUR" "GBP" "CHF" "BAM" "BGN" "CZK" "DKK" "HRK" "HUF" "ISK" "MDL" "MKD" "NOK" "PLN" "RON" "RSD" "RUB" "SEK" "TRY" "UAH" \
			"AED" "SAR" "OMR" "BHD" "ILS" "IRR" "JOD" "KWD" "LBP" "QAR" "SYP" \
			"USD" "CAD" "AWG" "BBD" "BMD" "BSD" "DOP" "GTQ" "JMD" "MXN" "PAB" "XCD" \
			"AUD" "FJD" "NZD" "XPF" \
			"ARS" "BOB" "BRL" "CLP" "COP" "PEN" "PYG" "UYU" "VES" \
			"ZAR" "EGP" "GHS" "GMD" "KES" "MAD" "MGA" "MUR" "NAD" "NGN" "SCR" "TND" "UGX" "XAF" "XOF")

readonly country_list=("India" "Malaysia" "Singapore" "Japan" "Bangladesh" "China" "Hong Kong" "Indonesia" "Cambodia" "South Korea" \
			"Laos" "Sri Lanka" "Maldives" "Nepal" "Philippines" "Pakistan" "Thailand" "Taiwan" "Vietnam" \
			"European Union (EU / Europe)" "Britain (England / Scotland / Wales / Northern Ireland / United Kingdom / UK)" \
			"Switzerland" "Bosnia and Herzegovina" "Bulgaria" "Czech Republic" "Denmark" "Croatia" "Hungary" "Iceland" "Moldova" \
			"Republic of North Macedonia" "Norway" "Poland" "Romania" "Serbia" "Russia" "Sweden" "Turkey" "Ukraine" \
			"United Arab Emirates (UAE / Dubai / Abu Dhabi)" "Saudi Arabia" "Oman" "Bahrain" "Israel" "Iran" "Jordan" \
			"Kuwait" "Lebanon" "Qatar" "Syria" \
			"United States of America (USA)" "Canada" "Aruba" "Barbados" "Bermuda" "The Bahamas" "Dominican Republic" \
			"Guatemala" "Jamaica" "Mexico" "Republic of Panama" \
			"Caribbean (Antig. / Barb. / Domin. / Gren. / St. Kit. / Nev. / St. Luc. / St. Vin. / Grenad. / Ang. / Mont." \
			"Australia" "Fiji" "New Zealand" "French Overseas Collectivities (French Polynesia, New Caledonia and Wallis and Futuna)" \
			"Argentina" "Bolivia" "Brazil" "Chile" "Colombia" "Peru" "Paraguay" "Uruguay" "Venezuela" \
			"South Africa" "Egypt" "Ghana" "The Gambia" "Kenya" "Morocco" "Madagascar" "Mauritius" "Namibia" "Nigeria" \
			"Seychelles" "Tunisia" "Uganda" \
			"Central Africa (Cameroon / Central African Republic / Chad / Republic of the Congo / Equatorial Guinea / Gabon)" \
			"West Africa (Benin / Burkina Faso / Guinea-Bissau / Ivory Coast / Mali / Niger / Senegal / Togo)")

readonly eu_country_list=("Austria" "Belgium" "Cyprus" "Estonia" "Finland" "France" "Germany" "Greece" "Ireland" "Italy" "Latvia" \
				"Lithuania" "Luxembourg" "Malta" "Netherlands" "Portugal" "Slovakia" "Slovenia" "Spain")





tmparr1=()
tmparr2=()

for ((i = 1 ; i < ${#currency_code[@]} ; i++))
do
	tmparr1+=("${currency_code[$i]} = <span>")
	tmparr2+=("</span>")
done

readonly startClues=("${tmparr1[@]}")
readonly endClues=("${tmparr2[@]}")

unset tmparr1
unset tmparr2
unset tmparr3

readonly url="https://www.goodreturns.in/currency/world-currencies-vs-indian-rupee-inr.html"
readonly mArray=("-" "country name" "currency name" "currency code")
readonly curconvWhiptailSavefile="curconvtemp.txt"
readonly gibberish="lN0hLz7bINdcilgc8QQb"
readonly curconvSavefilename="curconv"
readonly waitingGIF="/-\|"




# CALL-BASED FUNCTIONS  -  START

function_end()
{
	clear
	clear
	echo
	echo
	if (whiptail --title "QUERY 00" --yesno "Do you wish to end this program ?" 8 78); then
		tmpinfo1=("\n" " THIS PROGRAM HAS ENDED !" "\n")
		tmpinfo1+=("----------------------------------------------------" "\n")
		tmpinfo1+=(" Thank you for your time." "\n")
		mfc_rectangularheader "70" "" "0" "1" "1" "5" "1" "1" "3" "" "#" "${tmpinfo1[@]}"
		tmpinfo2="\n\n\n"
		tmpinfo2+="$mfc_headerdesignresult"
		tmpinfo2+="\n\n\n"
		whiptail --title "INFO 00" --msgbox "$tmpinfo2" 30 150
		exit 0
	fi
}

# Parameter 1 - Mode ( 1 => Country Name; 2 => Currency Name; 3 => Currency Code )
# Parameter 2 - Input
# Parameter 3 - Output 1 (Text)	[ REFERENCE ]
# Parameter 4 - Output 2 (ID)	[ REFERENCE ]
function_country_opt()
{
	local tmpStr0=""
	local cElem=""
	local cfound=0
	local count=0
	local cArray=()
	local cSubArray=()
	local cSubArrayIDs=()

	local cmode=$1
	local cname=$2
	local -n outputname=$3
	local -n outputid=$4
	outputname=""
	outputid=0

	if [[ "$cname" != "" ]]; then

		# VALIDATION - START
		mfc_only "$cmode" "2" tmpStr0
		if [[ "$tmpStr0" == "" ]]; then
			cmode=1
		fi
		if [ $cmode -lt 1 ]; then
			cmode=1
		elif [ $cmode -gt 3 ]; then
			cmode=3
		fi
		# VALIDATION - END

		if [ $cmode -eq 1 ]; then
			cArray=("${country_list[@]}")
		elif [ $cmode -eq 2 ]; then
			cArray=("${currency_list[@]}")
		else
			cArray=("${currency_code[@]}")
		fi

		if [ $cmode -eq 1 ]; then
			for cElem in ${!eu_country_list[@]}
			do
				if [[ "${eu_country_list[$cElem]}" == *"$cname"* ]]; then
					cSubArrayIDs+=("19")
					cSubArray+=("${eu_country_list[$cElem]}" "  ")
					if [ $count -eq 0 ]; then
						cSubArray+=("ON")
					else
						cSubArray+=("OFF")
					fi
					let "count++"
					cfound=1
				fi
			done
		fi
		cElem=""
		for cElem in ${!cArray[@]}
		do
			if [[ "${cArray[$cElem]}" == *"$cname"* ]]; then
				cSubArrayIDs+=("$cElem")
				cSubArray+=("${cArray[$cElem]}" "  ")
				if [ $count -eq 0 ]; then
					cSubArray+=("ON")
				else
					cSubArray+=("OFF")
				fi
				let "count++"
				cfound=1
			fi
		done

		if [ $cfound -eq 1 ]; then
			eval `resize`
			tmpStr0=$(whiptail --title "SUB-QUERY 0X" --radiolist \
			"\n\n  Select the required ${mArray[$cmode]} :" 30 140 20 \
			"${cSubArray[@]}" 3>&1 1>&2 2>&3)
			if [ $? -eq 0 ]; then
				outputname="$tmpStr0"
				cElem=""
				for cElem in ${!cSubArray[@]}
				do
					if [[ "${cSubArray[$cElem]}" == *"$outputname"* ]]; then
						let "tmpStr0 = cElem + 2 + 1"
						let "tmpStr0 = tmpStr0 / 3"
						let "tmpStr0 = tmpStr0 - 1"
						outputid=${cSubArrayIDs[$tmpStr0]}
						break
					fi
				done
			fi
		else
			tmpStr0="\n\n     The ${mArray[$cmode]} '$inputmsg' does not exist in our database.\n     Please try again."
			whiptail --title "ERROR 01" --msgbox "$tmpStr0" 12 70
		fi
	else
		tmpStr0="\n\n     The ${mArray[$cmode]} '$inputmsg' does not exist in our database.\n     Please try again."
		whiptail --title "ERROR 01" --msgbox "$tmpStr0" 12 70
	fi
}

# Parameter 1 - Host Country ID (Index No.)
# Parameter 2 - Client Country ID (Index No.)
# Parameter 3 - Client Country Amount
# Parameter 4 - Host Country Amount	[ REFERENCE ]
function_getrate()
{
	local hcid=$1
	local ccid=$2
	local ccam=$3
	local -n hcam=$4
	hcam=0

	hcam=`echo "scale=2; ($ccam*${exchangerateArray[ccid]})/${exchangerateArray[hcid]}" | bc`
	if [[ "${hcam:0:1}" == "." ]]; then
		hcam="0""$hcam"
	fi
}

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

# CALL-BASED FUNCTIONS  -  END



clear
clear
resize -s 37 150


exchangerateArray=()
clientmoderesultname=""
clientmoderesultid=""
phaseDataCompleted=""
hostcountryname=""
hostcountryid=""
headingString=""
clientmode=""
exitstatus=""
inputmsg=""
tmpmsg1=""
tmpmsg2=""
ltime=""
processdone=0
tmpLen1=0
tmpLen2=0
count=0




headingString=("\n" "WELCOME  TO  THE  CURRENCY  CONVERTER  APP (CUI) !" "\n")
headingString+=("----------------------------------------------------" "\n")
headingString+=("This program belongs to Mr. Melwyn Francis Carlo." "\n")
mfc_scrollheader "80" "" "" "0" "1" "5" "1" "#" "${headingString[@]}"
phaseDataCompleted="\n\n\n"
phaseDataCompleted+="$mfc_headerdesignresult"
phaseDataCompleted+="\n\n\n"
whiptail --title "Introduction" --msgbox "$phaseDataCompleted" 30 140



mfc_getwebdata "$url" "1" "1" "1" "1" "0" "0" "$curconvSavedir" "$curconvSavefilename" "${startClues[@]}" "${endClues[@]}" &

PROC_ID=$!
count=1
clear
clear
echo
echo
echo -en "  INFO :\n\n  Please Wait !\n\n  Accessing Live Data . . .     "
while [ -d /proc/$PROC_ID ]
do
	printf "\b${waitingGIF:count++%${#waitingGIF}:1}"
	sleep 0.1
done
printf "\bDone."
tmpmsg1=""
while [ ${#tmpmsg1} -eq 0 ]; do
	sleep 0.1
	function_readfile "$curconvSavedir/mfc_getwebdata_success.txt" tmpmsg1
done

if [[ "$tmpmsg1" != "1" ]]; then

	mfc_getwebdata "$url" "2" "1" "1" "1" "0" "0" "$curconvSavedir" "$curconvSavefilename" "${startClues[@]}" "${endClues[@]}" &

	PROC_ID=$!
	count=1
	clear
	clear
	echo
	echo
	echo -en "  INFO :\n\n  Please Wait !\n\n  Accessing Cached Data . . .     "
	while [ -d /proc/$PROC_ID ]
	do
		printf "\b${waitingGIF:count++%${#waitingGIF}:1}"
		sleep 0.1
	done
	printf "\bDone."
	tmpmsg1=""
	while [ ${#tmpmsg1} -eq 0 ]; do
		sleep 0.1
		function_readfile "$curconvSavedir/mfc_getwebdata_success.txt" tmpmsg1
	done

fi

if [[ "$tmpmsg1" != "1" ]]; then
	while :
	do
		headingString=("\n" "We've encountered a PROBLEM!" "\n")
		headingString+=("We've been unable to access live data. This could be due to ")
		headingString+=("no internet connection or the website's server being down.")
		headingString+=("Also no cached version exists. Therefore, you can't proceed")
		headingString+=("with this program any further." "\n")
		mfc_scrollheader "90" "" "" "0" "1" "5" "1" "#" "${headingString[@]}"
		phaseDataCompleted="\n\n\n"
		phaseDataCompleted+="$mfc_headerdesignresult"
		phaseDataCompleted+="\n\n\n"
		whiptail --title "ERROR 00" --msgbox "$phaseDataCompleted" 30 150
		function_end
	done
else
	function_readfile "$curconvSavedir/mfc_time_code.txt" tmpmsg1
	if [[ "$tmpmsg1" == *"0s"* ]]; then
		ltime="LIVE."
	else
		function_readfile "$curconvSavedir/mfc_time_text.txt" tmpmsg1
		ltime="$tmpmsg1 old."
	fi

	mfc_removetags "$curconvSavedir" "$curconvSavefilename" "0" "1" &

	PROC_ID=$!
	count=1
	clear
	clear
	echo
	echo
	echo -en "  INFO :\n\n  Please Wait !\n\n  Preparing Data . . .     "
	while [ -d /proc/$PROC_ID ]
	do
		printf "\b${waitingGIF:count++%${#waitingGIF}:1}"
		sleep 0.1
	done
	printf "\bDone."
	tmpmsg1=""
	while [ ${#tmpmsg1} -eq 0 ]; do
		sleep 0.1
		function_readfile "$curconvSavedir/mfc_removetags_success.txt" tmpmsg1
	done

	if [[ "$tmpmsg1" != "1" ]]; then
		tmpmsg1="     The webdata contents cannot be manipulated and prepared. \n"
		tmpmsg1+="     Please try either deleting or moving the following files : \n"
		tmpmsg1+="     $curconvSavefilename""1, $curconvSavefilename""2, $curconvSavefilename"
		tmpmsg1+="3, $curconvSavefilename""4, $curconvSavefilename""5, etc. \n"
		tmpmsg1+="     These files can be found in the $curconvSavedir directory/folder."
		whiptail --title "ERROR 0X" --msgbox "$tmpmsg1" 30 100
		function_end
	else
		count=0
		exchangerateArray+=("1.0")
		while :
		do
			let "count = count + 1"
			tmpmsg1="$curconvSavedir/$curconvSavefilename$count.txt"
			if [ -f "$tmpmsg1" ]; then
				function_readfile "$tmpmsg1" inputmsg
				mfc_remove "$inputmsg" "1" tmpmsg1
				mfc_remove "$tmpmsg1" " " tmpmsg2
				exchangerateArray+=("$tmpmsg2")
			else
				break
			fi
		done
	fi
fi

tmpmsg1="India"
while :
do
	inputmsg=$(whiptail --inputbox "\nWhich country do you belong to? :" 12 70 $tmpmsg1 --title "QUERY 01" 3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		while :
		do
			if [[ "$inputmsg" != "$gibberish" ]]; then
				function_country_opt "1" "$inputmsg" tmpmsg1 tmpmsg2;
			fi

			if [[ "$tmpmsg1" != "" ]] && [[ "$inputmsg" != "$gibberish" ]]; then
				hostcountryname="$tmpmsg1"
				hostcountryid="$tmpmsg2"
				while :
				do
					inputmsg=""
					eval `resize`
					clientmode=$(whiptail --title "QUERY 02" --radiolist \
					"\n\n  Search through :\n" 30 100 20 \
					"1." "  Country Name   " ON \
					"2." "  Currency Name   " OFF \
					"3." "  Currency Code   " OFF 3>&1 1>&2 2>&3)
					if [ $? -eq 0 ]; then
						while :
						do
							if [[ "$inputmsg" == "$gibberish" ]]; then
								break
							fi
							tmpmsg1="\n\nEnter the ${mArray[${clientmode:0:1}]} :"
							inputmsg=$(whiptail --inputbox "$tmpmsg1" 12 70 --title "QUERY 03" 3>&1 1>&2 2>&3)
							if [ $? = 0 ]; then
								function_country_opt "${clientmode:0:1}" "$inputmsg" tmpmsg1 tmpmsg2
								if [[ $tmpmsg1 != "" ]]; then
									clientmoderesultname="$tmpmsg1"
									clientmoderesultid="$tmpmsg2"
									while :
									do
										tmpmsg1="\n\nEnter the amount :"
										inputmsg=$(whiptail --inputbox "$tmpmsg1" 12 70 1 --title "QUERY 04" \
												3>&1 1>&2 2>&3)
										if [ $? = 0 ]; then
											mfc_remove "$inputmsg" "2" tmpmsg1
											mfc_remove "$tmpmsg1" "." tmpmsg2
											let "tmpLen1 = ${#tmpmsg1} - ${#tmpmsg2}"
											let "tmpLen2 = ${#inputmsg} - 1"
											if [ ${#tmpmsg2} -eq 0 -o $tmpLen1 -eq 1 ] && \
											[[ "${inputmsg:0:1}" != "." ]] && \
											[[ "${inputmsg:$tmpLen2:1}" != "." ]]; then
												function_getrate "$hostcountryid" \
												"$clientmoderesultid" "$inputmsg" tmpmsg1
												tmpmsg2="\n\n"
												tmpmsg2+="  The converted amount of '$inputmsg' "
												tmpmsg2+="${currency_list[$clientmoderesultid]} ("
												tmpmsg2+="${currency_code[$clientmoderesultid]}) is "
												tmpmsg2+="'$tmpmsg1' "
												tmpmsg2+="${currency_list[$hostcountryid]} ("
												tmpmsg2+="${currency_code[$hostcountryid]}) \n\n\n"
												tmpmsg2+="  1 ${currency_code[$clientmoderesultid]}"
												tmpmsg2+=" =  "
												function_getrate "$hostcountryid" \
												"$clientmoderesultid" "1.0" tmpmsg1
												tmpmsg2+="$tmpmsg1 "
												tmpmsg2+="${currency_code[$hostcountryid]} \n\n\n"
												tmpmsg2+="\n\n               "
												tmpmsg2+="[ ***  This information is $ltime  *** "
												tmpmsg2+="] \n\n"
												whiptail --title "INFO" --msgbox "$tmpmsg2" 20 75
											else
												tmpmsg1="\n     Enter a valid numeric or decimal "
												tmpmsg1+="value only."
												whiptail --title "ERROR 02" --msgbox "$tmpmsg1" 12 70
											fi
										else
											inputmsg="$gibberish"
											break
										fi
									done
								fi
							else
								break
							fi
						done
					else
						inputmsg="$gibberish"
						break
					fi
				done
			else
				break
			fi
		done
	else
		function_end
	fi
	tmpmsg1=""
done



