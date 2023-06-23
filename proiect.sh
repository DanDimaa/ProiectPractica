#!/bin/bash

sudo chmod +x ./$1

function check_cod_return(){
	./$1

	if [[ $? == 1 ]] 
	then
		echo Cod return 1 : Numar parametrii gresiti
	fi

	./$1 -k $2/file_49

	if [[ $? == 2 ]]
	then
		echo Cod return 2 : Al doilea parametru nu este -l sau -w
	fi

	./$1 -l $2/dada

	if [[ $? == 3 ]]
	then
		echo Cod return 3 : Fisierul nu exista
	fi

	read -p "Apasa orice tasta pentru a continua:" key
}

function check_input_output(){

	infiles=$(ls $2 | cut -f1 -d" ")

	declare -i testnumber=1
	declare -i numbersucces=0
	declare -i numbererror=0

	for infile in $infiles
	do
		resultlin=$(./$1 -l $2/$infile)
		resultwin=$(./$1 -w $2/$infile)

		outputl=$(cat $3/${infile}_l)
		outputw=$(cat $3/${infile}_w)

		if [[ $resultlin == $outputl ]]
		then
			echo TEST $testnumber, comm: ./app -l $infile ............PASSED
			testnumber=$testnumber+1
			numbersucces=$numbersucces+1
		else
			echo TEST $testnumber, comm: ./app -l $infile ...........FAILED 
			testnumber=$testnumber+1
			numbererror=$numbererror+1
		fi

		if [[ $resultwin == $outputw ]]
		then
			numbersucces=$numbersucces+1
			echo TEST $testnumber, comm: ./app -w $infile ............PASSED
                	testnumber=$testnumber+1
        	else
			numbererror=$numbererror+1
         		echo TEST $testnumber, comm: ./app -w $infile ............FAILED
                	testnumber=$testnumber+1
		fi
	done

	rate=$(expr $numbersucces / $testnumber \* 100)
	echo TOTAL: $numbererror FAILED, $numbersucces PASSED, RATE $rate
	
	read -p "Apasa orice tasta pentru a continua:" key
}


#Main Loop
while true
do
	clear
	
	printf "1.Verifica cod return aplicatie\n2.Verificare fisier input cu fisier output\n9.Iesire script\n" 

	read -p "Alege o optiune:" optiune
	
	case $optiune in
		1)	check_cod_return $1 ;;
		2)	check_input_output $1 $2 $3 ;;
		9) 	exit 1 ;;
		*)	echo Optiune gresita ;; 
	esac

done
