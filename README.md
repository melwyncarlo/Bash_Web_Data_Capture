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
- _Don't forget to add the ending '/' in the argument. (e.g. 'data/' is valid)_


**2.  Function Calls**

`mfc_scrollheader "70" "8" "130" "0" "1" "5" "1" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

`mfc_rectangularheader "80" "8" "0" "1" "1" "5" "1" "1" "1" "0" "" "${sampletext[@]}"` <br>
`echo -e "$mfc_headerdesignresult"` &#8195; &#8195; &#8195; &#8195; &#8195; &#8195; <= &#8195; <ins>(Note that the double quotes are very important)</ins>

<ins>NOTE :</ins>
- _The '-e' is not required for Simple (Character-based) Heading Banners_
- _Assigning too small values for design lengths or large values for border thickness will lead to a run-time error that results in loss of text_
- _Use individual '\n' to denote a line break as shown in 'sampletext'_


**3.  List of Arguments**

<pre>
mfc_scrollheader        -->   Parameter 1 - Columns
                              Parameter 2 - Scroll Sheet Color Code
                              Parameter 3 - Scroll Bar Color Code
                              Parameter 4 - Full Size (Length)
                              Parameter 5 - Scroll Alignment ( 1 => Center; 2 => Left)
                              Parameter 6 - Text Left/Right Offset
                              Parameter 7 - Text Top/Bottom Offset
                              Parameter 8 - Simple Mode Character
                              Parameter N - Data as an Array

mfc_rectangularheader   -->   Parameter 1 - Columns
                              Parameter 2 - Border Color Code
                              Parameter 3 - Full Size (Length)
                              Parameter 4 - Box Alignment ( 1 => Center; 2 => Left)
                              Parameter 5 - Text Alignment ( 1 => Center; 2 => Left)
                              Parameter 6 - Text Left/Right Offset
                              Parameter 7 - Text Top/Bottom Offset
                              Parameter 8 - Design Mode ( 1 => Thickness Mode; 2 => Shadow Mode )
                              Parameter 9 - Design Mode Value
                              Parameter 10 - Shadow Mode Color Code
                              Parameter 11 - Simple Mode Character
                              Parameter N - Data as an Array
</pre>

<br><br>
### The source library also contains 2 SUPPLEMENTARY functions. Given below are function calls and descriptive lists of arguments :



                              
### For any other queries :

<ins>Email me on :</ins>
- _Github_
- _carlo.melwyn@outlook.com_

