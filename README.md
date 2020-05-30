# EAN-13 barcode generator

Short C + x86 program written as a project for Computer Architecture course.<br />
Each code can be made with different stripe width.<br />
You can easily modify the codes inside the *main* function in **main.c** file.<br />
Each code should have corresponding width which can also be added in **main.c** file.<br />
The program does not check whether user input is correct or not.<br />

You need to have gcc and nasm compilators installed.<br />
To initialize building use ```make all``` command.<br />

Output: **full EAN-13** ([Wikipedia](https://en.wikipedia.org/wiki/International_Article_Number)) **barcode**<br />

Examples:<br />
![alt-text](https://github.com/tedtheripper/EAN13-generator-Cx86/blob/master/img/barcode1.bmp "Result barcode1")<br />
![alt-text](https://github.com/tedtheripper/EAN13-generator-Cx86/blob/master/img/barcode2.bmp "Result barcode2")<br />
![alt-text](https://github.com/tedtheripper/EAN13-generator-Cx86/blob/master/img/barcode3.bmp "Result barcode3")<br />