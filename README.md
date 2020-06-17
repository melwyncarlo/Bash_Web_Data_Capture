# Bash_Web_Data_Capture

<br>
A Bash Script Library to Download Select Data from the World Wide Web and perform Basic Text Manipulations on them.

<br><br>
### This repository contains 5 MAIN files :
<pre>
1.  webdatacapture.sh                         =>  Main Source (Library) File
2.  *headerdesign.sh                          =>  Supplementary Library File
3.  dailyreading_webdatacapture_demo.shh      =>  Demo 1 File
4.  currencyconverter_webdatacapture_demo.sh  =>  Demo 2 File
5.  webdatacapture_demo_output.txt            =>  Youtube links to the outputs of Demos 1 and 2

* REF - https://github.com/melwyncarlo/Bash_Header_Design
  For Designing CUI-based Heading Banners
</pre>

<br><br>
### The source library contains 2 MAIN functions. <br>Given below are function calls and descriptive lists of arguments :

**1.  Including the Main Source File in Demo Script Files**

`webdata_directory="data"`

`source src/webdatacapture.sh "$webdata_directory/"`

<ins>NOTE :</ins>
- _The main source file is located in the 'src' directory._
- _The argument denotes that downloaded data will be stored in the 'data' directory._
- _Don't forget to add the ending '/' in the argument. (e.g. 'data/' is valid; but 'data' is not)_ <br>

`url="SOME_WEBSITE_ADDRESS"` <br>
`sorted_contents_directory="$webdata_directory"` <br>
`sorted_contents_filename="stuff"` <br><br>

`startClues=("Tag1" "Tag2" "Tag3")` <br>
`endClues=("Tag1" "Tag2" "Tag3")` <br><br>

<ins>NOTE :</ins>
- _Start Tags may be of the form ' ... Some Text ... <TAG> ... Some Text ... '._
- _End Tags may be of the form ' ... Some Text ... </TAG> ... Some Text ... '._
- _'Some Text' may not exist in some cases._
- _'TAG' is meant to be replaced with actual HTML tag names._
- _In some cases, simply text may be used instead of tags._
- _All this depends on the required contents and their placement in the webpage soruce file_
<br>

**2.  Function Calls**

`mfc_getwebdata "$url" "1" "0" "1" "1" "0" "0" "$sorted_contents_directory" \ `<br>
`"$sorted_contents_filename" "${startClues[@]}" "${endClues[@]}"`

To obtain result : <br>
`$mfc_getwebdata_success` <br>
_OR_ <br>
Read the file `mfc_getwebdata_success.txt` in the directory named in `$webdata_directory` <br>
_[ If '1', it implies Success; if '0', it implies Failure. ]_<br><br>

`mfc_removetags "$sorted_contents_directory" "$sorted_contents_filename" "0" "0" ` <br>

To obtain result : <br>
`$mfc_removetags_success` <br>
_OR_ <br>
Read the file `mfc_removetags_success.txt` in the directory named in `$webdata_directory` <br>
_[ If '1', it implies Success; if '0', it implies Failure. ]_<br><br>

To know how old the file is : <br>
`$mfc_time` <br>
`$mfc_time_code` <br>
`$mfc_time_text` <br>
_OR_ <br>
Read the file `mfc_time.txt`, `mfc_time_code.txt` and `mfc_time_text.txt` in the directory <br>
named in `$webdata_directory` <br><br>
`$mfc_time` contains the time in seconds in numerical format. <br>
`$mfc_time_code` contains the time in the following format : <br>
<pre>Xs, Xmin, Xh, Xd, or Xm.</pre>
Where, 'X' is a number and : <br>
<pre>
s   =>  seconds
min =>  minutes
h   =>  hours
d   =>  days
m   =>  months
</pre>
`$mfc_time_text` contains the time in the following format : <br>
<pre>X second(s), X minute(s), X hours(s), X day(s), or X month(s).</pre>
Where, 'X' is a number. <br>

<ins>NOTE :</ins>
- _Read the resultant files and variables immediately after calling the functions._ <br>


**3.  List of Arguments**

<pre>
mfc_getwebdata        -->   Parameter 1 - URL
                            Parameter 2 - Cached Duration
                            ( 1 => New; 2 => Old; 3 => Day-old; ?* => Specified Duration )
                            [ h =>  Hours; d => Days; w => Weeks; m => Months ]
                            Parameter 3 - Quiet Mode
                            Parameter 4 - Independent Mode
                            Parameter 5 - Overwrite Mode
                            Parameter 6 - Repeat Read from Start Mode
                            Parameter 7 - Read Start from Line Number
                            Parameter 8 - Save File Directory ( Absolute Path )
                            Parameter 9 - Save File Name
                            Parameter N1 - Start Tags as an Array
                            Parameter N2 - End Tags as an Array

mfc_removetags        -->   Parameter 1 - Save File Directory ( Absolute Path )
                            Parameter 2 - Save File Name
                            Parameter 3 - Mode ( 0 => Simple; 1 => Array based )
                            Parameter 4 - Quiet Mode
                            Parameter N1 - Start Tags as an Array
                            Parameter N2 - End Tags as an Array
</pre>

<ins>NOTE :</ins>
- _Unless otherwise stated, in mode arguments, an input value of 1 is ON, and 0 is OFF._
- _Quiet Mode means that Errors and Info's will not be displayed in the terminal window._
- _In 'mfc_removetags', Simple mode means that the start tag is "<" and the end tag is ">"._
- _In 'mfc_removetags', in Simple mode, Parameters N1 and N2 should be ignored._
- _In 'mfc_removetags', in Array based mode, Parameters N1 and N2 must not be ignored._
- _In any case, the number of start tags must be equal to the number of end tags._
<br>

**4.  List of ERRORS**

<pre>
ERROR 01
</pre>

<br><br>
### The source library also contains 2 SUPPLEMENTARY functions. <br>Given below are function calls and descriptive lists of arguments :

**1.  Function Calls**

`mfc_only "70" "8" "130" "0" "1" "5" "1" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

`mfc_remove "80" "8" "0" "1" "1" "5" "1" "1" "1" "0" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

<ins>NOTE :</ins>
- _The '-e' is not required for Simple (Character-based) Heading Banners_
- _Assigning too small values for design lengths or large values for border thickness will lead to a run-time error that results in loss of text_
- _Use individual '\n' to denote a line break as shown in 'sampletext'_
<br>

**2.  List of Arguments**

<pre>
mfc_only        -->   Parameter 1 - Data
                      Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum )
                      Parameter 3 - Return Data	[ REFERENCE ]

mfc_remove      -->   Parameter 1 - Data
                      Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum; ?* => Specific Characters)
                      Parameter 3 - Return Data	[ REFERENCE ]
</pre>

<br><br>
### For any other queries :

<ins>Email me on :</ins>
- _Github_
- _carlo.melwyn@outlook.com_

