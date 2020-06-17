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
### The source library contains 2 MAIN functions. Given below are function calls and descriptive lists of arguments :

**1.  Including the Main Source File in Demo Script Files**

`source src/webdatacapture.sh "data/"`

_NOTE :_
- _The main source file is located in the 'src' directory._
- _The argument denotes that downloaded data will be stored in the 'data' directory._
- _Don't forget to add the ending '/' in the argument. (e.g. 'data/' is valid; but 'data' is not)_


**2.  Function Calls**

`mfc_getwebdata "70" "8" "130" "0" "1" "5" "1" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

`mfc_removetags "80" "8" "0" "1" "1" "5" "1" "1" "1" "0" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

<ins>NOTE :</ins>
- _The '-e' is not required for Simple (Character-based) Heading Banners_
- _Assigning too small values for design lengths or large values for border thickness will lead to a run-time error that results in loss of text_
- _Use individual '\n' to denote a line break as shown in 'sampletext'_


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

<br><br>
### The source library also contains 2 SUPPLEMENTARY functions. Given below are function calls and descriptive lists of arguments :

**2.  Function Calls**

`mfc_only "70" "8" "130" "0" "1" "5" "1" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

`mfc_remove "80" "8" "0" "1" "1" "5" "1" "1" "1" "0" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

<ins>NOTE :</ins>
- _The '-e' is not required for Simple (Character-based) Heading Banners_
- _Assigning too small values for design lengths or large values for border thickness will lead to a run-time error that results in loss of text_
- _Use individual '\n' to denote a line break as shown in 'sampletext'_


**3.  List of Arguments**

<pre>
mfc_only        -->   Parameter 1 - Data
                      Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum )
                      Parameter 3 - Return Data	[ REFERENCE ]

mfc_remove      -->   Parameter 1 - Data
                      Parameter 2 - Mode ( 1 => Alpha; 2 => Num; 3 => AlphaNum; ?* => Specific Characters)
                      Parameter 3 - Return Data	[ REFERENCE ]
</pre>

                              
### For any other queries :

<ins>Email me on :</ins>
- _Github_
- _carlo.melwyn@outlook.com_

