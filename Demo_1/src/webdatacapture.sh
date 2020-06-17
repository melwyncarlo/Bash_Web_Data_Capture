#!/bin/bash



# 0 => FAILURE; 1 => SUCCESS
mfc_getwebdata_success=0
mfc_removetags_success=0
mfc_time=""
mfc_time_code=""
mfc_time_text=""


# ( Don't forget to add the ending '/' )
readonly mfc_webdata_storage_dir="$1"


# Parameter 1 - Data
# Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum )
# Parameter 3 - Return Data	[ REFERENCE ]
mfc_only()
{
	local mainStr=$1
	local mode=$2
	local -n returnStr=$3
	returnStr=""
	
	for ((i = 0 ; i < ${#mainStr} ; i++))
	do
		if [[ "$mode" == "1" ]] && [[ "${mainStr:$i:1}" =~ ^[a-zA-Z]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		elif [[ "$mode" == "2" ]] && [[ "${mainStr:$i:1}" =~ ^[0-9]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		elif [[ "$mode" == "3" ]] && [[ "${mainStr:$i:1}" =~ ^[0-9a-zA-Z]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		fi
	done
}


# Parameter 1 - Data
# Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum; ?* => Specific Characters)
# Parameter 3 - Return Data	[ REFERENCE ]
mfc_remove()
{
	local tmpNum=0

	local mainStr=$1
	local mode=$2
	local -n returnStr=$3
	returnStr=""
	
	for ((i = 0 ; i < ${#mainStr} ; i++))
	do
		if [[ "$mode" == "1" ]] && ! [[ "${mainStr:$i:1}" =~ ^[a-zA-Z]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		elif [[ "$mode" == "2" ]] && ! [[ "${mainStr:$i:1}" =~ ^[0-9]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		elif [[ "$mode" == "3" ]] && ! [[ "${mainStr:$i:1}" =~ ^[0-9a-zA-Z]+$ ]]; then
			returnStr+="${mainStr:$i:1}"
		else
			let "tmpNum = ${#mode} - 1"
			if [[ "${mode:0:1}" == "?" ]] && [[ "${mainStr:$i:$tmpNum}" == "${mode:1:$tmpNum}" ]]; then
				let "i = i + tmpNum - 1"
			else
				if [[ "$mode" != "1" ]] && [[ "$mode" != "2" ]] && [[ "$mode" != "3" ]]; then
					returnStr+="${mainStr:$i:1}"
				fi
			fi
		fi
	done
}


# Parameter 1 - Data
# Parameter 2 - Mode ( 1 => Codified; 2 => Simple Text; )
# Parameter 3 - Return Data	[ REFERENCE ]
mfc_timedifftext()
{
	local tmpStr=""
	local suffix1=("" "s" " second(s)")
	local suffix2=("" "min" " minute(s)")
	local suffix3=("" "h" " hour(s)")
	local suffix4=("" "d" " day(s)")
	local suffix5=("" "m" " month(s)")

	local mainStr=$1
	local mode=$2
	local -n returnStr=$3
	returnStr=""

	mfc_only "$mainStr" "2" tmpStr
	
	if [ $tmpStr -lt 60 ]; then
		returnStr="$tmpStr""${suffix1[$mode]}"
	elif [ $tmpStr -lt 3600 ]; then
		let "tmpStr= tmpStr / 60"
		returnStr="$tmpStr""${suffix2[$mode]}"
	elif [ $tmpStr -lt 86400 ]; then
		let "tmpStr= tmpStr / 3600"
		returnStr="$tmpStr""${suffix3[$mode]}"
	elif [ $tmpStr -lt 2592000 ]; then
		let "tmpStr= tmpStr / 86400"
		returnStr="$tmpStr""${suffix4[$mode]}"
	else
		let "tmpStr= tmpStr / 604800"
		returnStr="$tmpStr""${suffix5[$mode]}"
	fi
}


# Parameter 1 - Save File Directory ( Absolute Path )
# Parameter 2 - Save File Name
# Parameter 3 - Mode ( 0 => Simple; 1 => Array based )
# Parameter 4 - Quiet Mode
# Parameter N1 - Start Tags as an Array
# Parameter N2 - End Tags as an Array
mfc_removetags()
{
	mfc_getwebdata_success=0
	mfc_removetags_success=0
	mfc_time=""
	mfc_time_code=""
	mfc_time_text=""
	echo -n "" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_removetags_success.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time_code.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time_text.txt"

	local searchStr1=""
	local searchStr2=""
	local savedata=""
	local tmpStr1=""
	local tmpStr1b=""
	local tmpStr1c=""
	local dirElem=""
	local starttags=()
	local endtags=()
	local dirList=()
	local count=1
	local tmpPos1=0
	local oldfileexists=0

	local savedirpath=$1
	local savefilename=$2
	local tagsmode=$3
	local quietmode=$4
	shift 4
	local tagsarray=("${@}")


	# Validation
	mfc_only "$quietmode" "2" tmpStr0
	if [[ "$tmpStr0" == "" ]]; then
		quietmode=0
	fi
	if [ $quietmode -lt 0 ]; then
		quietmode=0
	elif [ $quietmode -gt 1 ]; then
		quietmode=1
	fi
	mfc_only "$tagsmode" "2" tmpStr0
	if [ "$tmpStr0" == "" ]; then
		tagsmode=0
	fi
	if [ $tagsmode -eq 0 ]; then
		tagsarray=(" ")
		tmpStr0=0
	else
		let "tmpStr0 = ${#tagsarray[@]} % 2"
	fi


	mfc_only "$savefilename" "3" tmpStr1
	mfc_remove "$savefilename" "3" tmpStr1b
	# Checking if tags exist
	# Checking if equal number of start and end tags exist
	# Checking if Destination Directory Path exists
	# Checking if file name contains Alpha-Numeric characters
	# Checking if file name contains any Special characters
	if [ ${#tagsarray[@]} -gt 0 ] && [ $tmpStr0 -eq 0 ] && [ -d "$savedirpath" ] && [ ${#tmpStr1} -gt 0 ] && [ ${#tmpStr2} -eq 0 ]; then
		# Validation - START

		let "tmpStr1 = ${#savedirpath} - 1"
		if [[ "${savedirpath:$tmpStr1:1}" == "/" ]]; then
			savedirpath=${savedirpath:0:$tmpStr1}
		fi

		# Validation - END


		# Sorting out the Tags
		if [ $tagsmode -eq 0 ]; then
			starttags=("<")
			endtags=(">")
		else
			let "tmpStr0 = ${#tagsarray[@]} / 2"
			for ((i = 0 ; i < $tmpStr0 ; i++))
			do	
				starttags+=("${tagsarray[$i]}")
				let "tmpStr1 = $i + tmpStr0"
				endtags+=("${tagsarray[$tmpStr1]}")
			done
		fi


		while :
		do
			oldfileexists=0
			dirList=($(ls -A $savedirpath))
			for dirElem in "${dirList[@]}"
			do
				if [[ "$dirElem" == *"$savefilename$count.txt"* ]]; then
					savedata=""
					while read -r -s line
					do
						savedata+=$line
					done < "$savedirpath/$savefilename$count.txt"
					oldfileexists=1
					break
				fi
			done
			if [ $oldfileexists -eq 1 ]; then

				for ((j = 0 ; j < ${#starttags[@]} ; j++))
				do
					searchStr1=${starttags[$j]}
					searchStr2=${endtags[$j]}
					while :
					do
						local tmpStr1=${savedata#*$searchStr1}
						local tmpPos1=$(( ${#savedata} - ${#tmpStr1} - ${#searchStr1} ))
						if [ $tmpPos1 -lt 0 ]; then
							break
						else
							local tmpStr1b=${savedata:0:$tmpPos1}
							local tmpStr1c=${savedata:tmpPos1}
							local tmpStr2=${tmpStr1c#*$searchStr2}
							local tmpPos2=$(( ${#tmpStr1c} - ${#tmpStr2} - ${#searchStr2} ))
							if [ $tmpPos2 -lt 0 ]; then
								tmpStr1c=""
							else
								let "tmpPos3 = tmpPos2 + ${#searchStr2}"
								tmpStr1c=${tmpStr1c:tmpPos3}
							fi
							savedata=$tmpStr1b$tmpStr1c
							echo "$savedata" > "$savedirpath/$savefilename$count.txt"
						fi
					done
				done

				let "count++"
			else
				if [ $count -eq 1 ]; then
					mfc_removetags_success=0
					echo "0" > "$mfc_webdata_storage_dir""mfc_removetags_success.txt"
					if [ $quietmode -eq 0 ]; then
						echo "ERROR 07 :  This error has occurred because no web data have been gathered yet."
						echo "            This function 'mfc_removetags' is meant to supplement the predecessor"
						echo "            function 'mfc_getwebdata'. Please achieve successful completion of"
						echo "            that function before operating on this function."
						echo
					fi
				else
					mfc_removetags_success=1
					echo "1" > "$mfc_webdata_storage_dir""mfc_removetags_success.txt"
					if [ $quietmode -eq 0 ]; then
						echo
						echo "INFO :  MFC-REMOVE-TAGS - SUCCESS"
						echo
					fi
				fi
				break
			fi
		done
	else
		mfc_removetags_success=0
		echo "0" > "$mfc_webdata_storage_dir""mfc_removetags_success.txt"
		if [ $quietmode -eq 0 ]; then
			if [ ${#tagsarray[@]} -le 0 ]; then
				echo
				echo "ERROR 01 :  No start or end tags have been inputted."
				echo
			elif [ $tmpStr0 -ne 0 ]; then
				echo
				echo "ERROR 02 :  Number of start and end tags are unequal."
				echo "            If there are 2 start tags, there must be 2 end tags as well."
				echo
			elif ! [ -d "$savedirpath" ]; then
				echo
				echo "ERROR 03 :  The chosen directory does not exist."
				echo "            Please choose an appropriate directory or"
				echo "            ensure that the external devices are properly connected."
				echo
			elif [ ${#tmpStr1} -le 0 ]; then
				echo
				echo "ERROR 04 :  The chosen Save Filename either contains special charcters or"
				echo "            does not contain any alpha-numeric characters."
				echo "            Please input alpha-numeric characters only"
				echo
			else # [ ${#tmpStr2} -ne 0 ]; then
				echo
				echo "ERROR 04 :  The chosen Save Filename either contains special charcters or"
				echo "            does not contain any alpha-numeric characters."
				echo "            Please input alpha-numeric characters only"
				echo
			fi
		fi
	fi
}


# Parameter 1 - URL
# Parameter 2 - Cached Duration ( 1 => New; 2 => Old; 3 => Day-old; ?* => Specified Duration )
# [ h =>  Hours; d => Days; w => Weeks; m => Months ]
# Parameter 3 - Quiet Mode
# Parameter 4 - Independent Mode
# Parameter 5 - Overwrite Mode
# Parameter 6 - Repeat Read from Start Mode
# Parameter 7 - Read Start from Line Number
# Parameter 8 - Save File Directory ( Absolute Path )
# Parameter 9 - Save File Name
# Parameter N1 - Start Tags as an Array
# Parameter N2 - End Tags as an Array
mfc_getwebdata()
{
	mfc_getwebdata_success=0
	mfc_removetags_success=0
	mfc_time=""
	mfc_time_code=""
	mfc_time_text=""
	echo -n "" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_removetags_success.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time_code.txt"
	echo -n "" > "$mfc_webdata_storage_dir""mfc_time_text.txt"

	local flag=0
	local filenamenew="tmpfile"
	local timenew=`date +"%s"`
	local timeold=0
	local timediff=0
	local timecond=0
	local mainrdstrtlnno=0
	local oldfileexists=0
	local oldfilevalid=0
	local deloldfile=0
	local contdpos=0
	local tmpLen1=0
	local rdlnno=1
	local start=1
	local loop=1
	local tmpStr0=""
	local tmpStr1=""
	local tmpStr2=""
	local tmpStr3=""
	local tmpPos1=""
	local tmpPos2=""
	local tmpPos3=""
	local savedata=""
	local dirElem=""
	local dirList=()
	local starttags=()
	local endtags=()

	local urlname=$1
	local cachedur=$2
	local quietmode=$3
	local indemode=$4
	local owmode=$5
	local reprdstrt=$6
	local rdstrtlnno=$7
	local savedirpath=$8
	local savefilename=$9
	shift 9
	local tagsarray=("${@}")


	# Validation
	mfc_only "$quietmode" "2" tmpStr0
	if [[ "$tmpStr0" == "" ]]; then
		quietmode=0
	fi
	if [ $quietmode -lt 0 ]; then
		quietmode=0
	elif [ $quietmode -gt 1 ]; then
		quietmode=1
	fi
	mfc_only "$owmode" "2" tmpStr0
	if [[ "$tmpStr0" == "" ]]; then
		owmode=0
	fi
	if [ $owmode -lt 0 ]; then
		owmode=0
	elif [ $owmode -gt 1 ]; then
		owmode=1
	fi


	let "tmpStr0 = ${#tagsarray[@]} % 2"
	mfc_only "$savefilename" "3" tmpStr1
	mfc_remove "$savefilename" "3" tmpStr2
	# Checking if tags exist
	# Checking if equal number of start and end tags exist
	# Checking if Destination Directory Path exists
	# Checking if file name contains Alpha-Numeric characters
	# Checking if file name contains any Special characters
	if [ ${#tagsarray[@]} -gt 0 ] && [ $tmpStr0 -eq 0 ] && [ -d "$savedirpath" ] && [ ${#tmpStr1} -gt 0 ] && [ ${#tmpStr2} -eq 0 ]; then
		# Checking if filename already exists in destination directory
		oldfileexists=0
		dirList=($(ls -A $savedirpath))
		for dirElem in "${dirList[@]}"
		do
			if [[ "$dirElem" == *"$savefilename"* ]]; then
				oldfileexists=1
				break
			fi
		done
		if [ $oldfileexists -eq 0 -o $owmode -eq 1 ]; then

			# Validation - START

			if [[ "$cachedur" != "1" ]] && [[ "$cachedur" != "2" ]] && [[ "$cachedur" != "3" ]] && \
			[[ "${cachedur:0:1}" != "?" ]]; then
				cachedur=1
			fi

			if [[ "${cachedur:0:1}" == "?" ]]; then
				let "tmpStr0 = ${#cachedur} - 1"
				tmpStr1=${cachedur:1:$tmpStr0}
				mfc_only "$tmpStr1" "1" tmpStr0
				if [ ${#tmpStr0} -ne 1 ]; then
					cachedur=1
				else
					mfc_remove "$tmpStr1" "3" tmpStr0
					if [ ${#tmpStr0} -eq 0 ]; then
						cachedur=1
					else
						mfc_only "$tmpStr1" "2" tmpStr0
						if [ ${#tmpStr0} -lt 1 ]; then
							cachedur=1
						else
							let "tmpStr0 = ${#cachedur} - 1"
							tmpStr1=${cachedur:tmpStr0:1}
							mfc_only "$tmpStr1" "1" tmpStr0
							if [ ${#tmpStr0} -eq 0 ]; then
								cachedur=1
							else
								tmpStr1=${tmpStr1,,}
								if [[ "$tmpStr1" != "h" ]] && [[ "$tmpStr1" != "d" ]] && \
								[[ "$tmpStr1" != "w" ]] && [[ "$tmpStr1" != "m" ]]; then
									cachedur=1
								fi
							fi
						fi
					fi
				fi
			fi

			mfc_only "$indemode" "2" tmpStr0
			if [[ "$tmpStr0" == "" ]]; then
				indemode=0
			fi
			if [ $indemode -lt 0 ]; then
				indemode=0
			elif [ $indemode -gt 1 ]; then
				indemode=1
			fi

			mfc_only "$reprdstrt" "2" tmpStr0
			if [[ "$tmpStr0" == "" ]]; then
				reprdstrt=0
			fi
			if [ $reprdstrt -lt 0 ]; then
				reprdstrt=0
			elif [ $reprdstrt -gt 1 ]; then
				reprdstrt=1
			fi

			mfc_only "$rdstrtlnno" "2" tmpStr0
			if [[ "$tmpStr0" == "" ]]; then
				rdstrtlnno=0
			fi
			if [ $rdstrtlnno -lt 0 ]; then
				rdstrtlnno=0
			fi

			let "tmpStr0 = ${#savedirpath} - 1"
			if [[ "${savedirpath:$tmpStr0:1}" == "/" ]]; then
				savedirpath=${savedirpath:0:$tmpStr0}
			fi

			# Validation - END


			# Sorting out the Tags
			let "tmpStr0 = ${#tagsarray[@]} / 2"
			for ((i = 0 ; i < $tmpStr0 ; i++))
			do	
				starttags+=("${tagsarray[$i]}")
				let "tmpStr1 = $i + tmpStr0"
				endtags+=("${tagsarray[$tmpStr1]}")
			done


			# Creating a structured filename

			mfc_only "$urlname" "1" tmpStr0
			tmpStr1=$tmpStr0
			mfc_remove "$tmpStr1" "?https" tmpStr0
			tmpStr1=$tmpStr0
			mfc_remove "$tmpStr1" "?http" tmpStr0
			tmpStr1=$tmpStr0
			mfc_remove "$tmpStr1" "?www" tmpStr0
			filenamenew+="${tmpStr0:0:20}"

			oldfileexists=0
			dirList=()
			dirList=($(ls -A "$mfc_webdata_storage_dir"))
			for dirElem in "${dirList[@]}"
			do
				if [[ "$dirElem" == *"$filenamenew"* ]]; then
					oldfileexists=1
					break
				fi
			done

			filenamenew+=`date +"%s"`
			filenamenew+=".txt"


			# Dealing with Old Files

			if [ $oldfileexists -eq 1 ]; then
				if [[ "$cachedur" == "1" ]]; then
					timecond=0
					deloldfile=1
				elif [[ "$cachedur" == "2" ]]; then
					timecond=9999999999
				elif [[ "$cachedur" == "3" ]]; then
					tmpStr0=`date +"%H"`
					let "tmpStr1 = (tmpStr0 * 3600)"
					tmpStr0=`date +"%M"`
					let "tmpStr1 = tmpStr1 + (tmpStr0 * 60)"
					let "timecond = $tmpStr1"
				else
					let "tmpStr0 = ${#cachedur} - 2"
					tmpStr1=${cachedur:1:tmpStr0}
					let "tmpStr0 = ${#cachedur} - 1"
					tmpStr2=${cachedur:tmpStr0:1}
					if [[ "${tmpStr2,,}" == "h" ]]; then
						let "timecond = tmpStr1 * 3600"
					elif [[ "${tmpStr2,,}" == "d" ]]; then
						let "timecond = tmpStr1 * 24 * 3600"
					elif [[ "${tmpStr2,,}" == "w" ]]; then
						let "timecond = tmpStr1 * 7 * 24 * 3600"
					else
						let "timecond = tmpStr1 * 30 * 24 * 3600"
					fi
				fi
				let "tmpStr1 = ${#dirElem} - 10 - 4"
				timeold=${dirElem:$tmpStr1:10}
				let "timediff = timenew - timeold"
				mfc_time="$timediff"

				if [ $timediff -le $timecond ]; then
					filenamenew=$dirElem
					oldfilevalid=1
					if [ $quietmode -eq 0 ]; then
						echo
						echo "INFO :  Data already present in storage and within the "
						echo "        limits of the inputted cache duration."
						echo
					fi
				else
					deloldfile=1
				fi
			fi


			# Setting File Access Time
			if [[ "$cachedur" == "1" ]]; then
				mfc_time="0"
			fi
			echo "$mfc_time" > "$mfc_webdata_storage_dir""mfc_time.txt"
			mfc_timedifftext "$mfc_time" "1" tmpStr0
			mfc_time_code="$tmpStr0"
			echo "$tmpStr0" > "$mfc_webdata_storage_dir""mfc_time_code.txt"
			mfc_timedifftext "$mfc_time" "2" tmpStr0
			mfc_time_text="$tmpStr0"
			echo "$tmpStr0" > "$mfc_webdata_storage_dir""mfc_time_text.txt"


			# Accessing Data from the Web

			if [ $oldfileexists -eq 0 -o $oldfilevalid -eq 0 ]; then
				if [ $quietmode -eq 1 ]; then
					wget $urlname -O "$mfc_webdata_storage_dir$filenamenew" -q --no-cookies
				else
					wget $urlname -O "$mfc_webdata_storage_dir$filenamenew" --progress="bar" \
					--no-cookies --show-progress --server-response
				fi
				local newfilesize=0
				newfilesize=`du --si -s -b "$mfc_webdata_storage_dir$filenamenew"`
				mfc_remove "$newfilesize" "?$mfc_webdata_storage_dir$filenamenew" tmpStr0
				newfilesize=$tmpStr0
				mfc_only "$newfilesize" "2" tmpStr0
				newfilesize=$tmpStr0
				tmpStr0=""
				if [ $newfilesize -le 100 ]; then
					while read -r -s line
					do
						tmpStr0+=$line
					done < "$mfc_webdata_storage_dir$filenamenew"
					tmpStr0=$(echo -e $tmpStr0 | tr -d '\n')
					tmpStr0=$(echo -e $tmpStr0 | tr -d '\r')
					tmpStr0=$(echo -e $tmpStr0 | tr -d '\t')
					tmpStr0=$(echo -e $tmpStr0 | tr -d ' ')
					if [ ${#tmpStr0} -eq 0 ]; then
						flag=1
						if [ -f "$mfc_webdata_storage_dir$filenamenew" ]; then
							rm -f "$mfc_webdata_storage_dir$filenamenew"
						fi
					fi
				else
					if [ $deloldfile -eq 1 ]; then
						rm -f "$mfc_webdata_storage_dir$dirElem"
					fi
				fi
			fi


			if [ $flag -eq 1 ]; then
				mfc_getwebdata_success=0
				echo "0" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
				if [ $quietmode -eq 0 ]; then
					echo
					echo "ERROR 05 :  The web contents downloaded file is empty."
					echo "            Please check your internet connection or"
					echo "            the website's server is down."
					echo
				fi
			else
				# Retrieving Required Data
				tmpStr0=`wc -l < "$mfc_webdata_storage_dir$filenamenew"`
				mfc_only "$tmpStr0" "2" tmpStr2
				let "rdstrtlnno = tmpStr2 - rdstrtlnno"
				if [ $rdstrtlnno -le 0 ]; then
					rdstrtlnno=1
				fi

				if [ $quietmode -eq 0 ]; then
					echo
					echo "INFO :  Data accessed and downloaded successfully."
					echo
				fi
				# Checking if Destination Directory Path exists, again
				if ! [ -d "$savedirpath" ]; then
					mfc_getwebdata_success=0
					echo "0" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
					if [ $quietmode -eq 0 ]; then
						echo
						echo "ERROR 03 :  The chosen directory does not exist."
						echo "            Please choose an appropriate directory or"
						echo "            ensure that the external devices are properly connected."
						echo
					fi
				else
					tmpStr1=""
					tmpStr2=""
					tmpPos1=""
					tmpPos2=""
					tmpPos3=""
					contdpos=0
					flag=0
					mainrdstrtlnno=$rdstrtlnno
					local j=0
					for ((j = 0 ; j < ${#starttags[@]} ; j++))
					do
						local k=0
						let "k = j + 1"
						start=1
						loop=1
						if [ $flag -eq 1 ]; then
							let "rdlnno = tmpStr0 - rdstrtlnno"
							flag=0
						else
							let "rdlnno = tmpStr0 - mainrdstrtlnno"
							start=1
							if [ $j -ne 0 -a $indemode -eq 1 ]; then
								local l=0
								for ((l = $j ; l < ${#starttags[@]} ; l++))
								do
									local m=0
									let "m = l + 1"
									echo -n "" >> "$savedirpath/$savefilename$m.txt"
								done
								break
							fi
						fi
						echo -n "" > "$savedirpath/$savefilename$k.txt"
						while read -r -s line 
						do
							let "rdlnno++"

							if [ $start -eq 1 ] && [[ "$line" == *"${starttags[$j]}"* ]]; then
								tmpStr2=${starttags[$j]}
								if [ $rdlnno -ne 1 ]; then
									tmpStr3=${line:$contdpos}
									let "contdpos = contdpos + ${#tmpStr2} - 1"
								else
									tmpStr3=$line
								fi
								tmpStr1=${line#*$tmpStr2}
								tmpPos1=$(( ${#line} - ${#tmpStr1} - ${#tmpStr2} ))
								start=0
							fi
								
							if [ $start -eq 0 ]; then
								tmpStr1=${endtags[$j]}
								tmpStr2=${line:contdpos}
								tmpStr2=${tmpStr2#*$tmpStr1}
								tmpStr3=${starttags[$j]}
								tmpPos2=$(( ${#line} - ${#tmpStr2} - ${#tmpStr1} ))
								if [ $tmpPos2 -lt 0 ]; then
									contdpos=0
									if [ $loop -eq 1 ]; then
										loop=2
										let "tmpPos3 = tmpPos1 + ${#tmpStr3}"
										savedata="${line:$tmpPos3}"
										savedata=$(echo -e $savedata | tr -d '\n')
										savedata=$(echo -e $savedata | tr -d '\r')
										savedata=$(echo -e $savedata | tr '\t' ' ')
										echo "$savedata" >> "$savedirpath/$savefilename$k.txt"
									else
										savedata="$line"
										savedata=$(echo -e $savedata | tr -d '\n')
										savedata=$(echo -e $savedata | tr -d '\r')
										savedata=$(echo -e $savedata | tr '\t' ' ')
										echo "$savedata" >> "$savedirpath/$savefilename$k.txt"
									fi
								else
									if [ $loop -eq 1 ]; then
										let "tmpPos3 = tmpPos1 + ${#tmpStr3}"
										let "tmpLen1 = $tmpPos2 - $tmpPos1 - ${#tmpStr3}"
									else
										let "tmpPos3 = 0"
										let "tmpLen1 = $tmpPos2"
									fi

									savedata="${line:$tmpPos3:$tmpLen1}"
									savedata=$(echo -e $savedata | tr -d '\n')
									savedata=$(echo -e $savedata | tr -d '\r')
									savedata=$(echo -e $savedata | tr '\t' ' ')
									echo "$savedata" >> "$savedirpath/$savefilename$k.txt"
									start=1
									if [ $reprdstrt -eq 0 ]; then
										let "rdstrtlnno = tmpStr0 - rdlnno"
										let "contdpos = tmpPos3 + tmpLen1"
									fi
									flag=1
									break
								fi
							fi
						done < <(tail -n "$rdstrtlnno" "$mfc_webdata_storage_dir$filenamenew")
					done
					# Checking if Destination Directory Path exists, and again
					if ! [ -d "$savedirpath" ]; then
						mfc_getwebdata_success=0
						echo "0" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
						if [ $quietmode -eq 0 ]; then
							echo
							echo "ERROR 03 :  The chosen directory does not exist."
							echo "            Please choose an appropriate directory or"
							echo "            ensure that the external devices are properly connected."
							echo
						fi
					else
						mfc_getwebdata_success=1
						echo "1" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
						if [ $quietmode -eq 0 ]; then
							echo
							echo "INFO :  MFC-WEB-DATA-CAPTURE - SUCCESS"
							echo
						fi
					fi
				fi
			fi
		else
			mfc_getwebdata_success=0
			echo "0" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
			if [ $quietmode -eq 0 ]; then
				echo
				echo "ERROR 06 :  The Save Filename already exists in the chosen directory."
				echo "            Please choose another directory or a new filename."
				echo
			fi
		fi
	else
		mfc_getwebdata_success=0
		echo "0" > "$mfc_webdata_storage_dir""mfc_getwebdata_success.txt"
		if [ $quietmode -eq 0 ]; then
			if [ ${#tagsarray[@]} -le 0 ]; then
				echo
				echo "ERROR 01 :  No start or end tags have been inputted."
				echo
			elif [ $tmpStr0 -ne 0 ]; then
				echo
				echo "ERROR 02 :  Number of start and end tags are unequal."
				echo "            If there are 2 start tags, there must be 2 end tags as well."
				echo
			elif ! [ -d "$savedirpath" ]; then
				echo
				echo "ERROR 03 :  The chosen directory does not exist."
				echo "            Please choose an appropriate directory or"
				echo "            ensure that the external devices are properly connected."
				echo
			elif [ ${#tmpStr1} -le 0 ]; then
				echo
				echo "ERROR 04 :  The chosen Save Filename either contains special charcters or"
				echo "            does not contain any alpha-numeric characters."
				echo "            Please input alpha-numeric characters only"
				echo
			else # [ ${#tmpStr2} -ne 0 ]; then
				echo
				echo "ERROR 04 :  The chosen Save Filename either contains special charcters or"
				echo "            does not contain any alpha-numeric characters."
				echo "            Please input alpha-numeric characters only"
				echo
			fi
		fi
	fi
}



