#!/bin/bash 



#############################################mainmenu############################################

function mainmenu(){
echo -e $grean "Please enter your choice: " 

echo -e $blue
options=("Creat Database" "List Database" "Connect Database" "Drop Database" "Exit")
select opt in "${options[@]}"
 do
    case $REPLY in
        1)
            creatdatabase
            ;;
        2)
            listdatabase
            ;;
        3)
            connectdatabase 
            ;;
        4) 
            dropdatabase
            ;;
        5) 
           echo -e $RED "You exit byee"
           exit
           break
            ;;
        *) 
           echo -e $RED "invalid option $REPLY"
           echo ""  
           echo -e $blue "Please enter your choice!!" 
            ;;
    esac
 done 
} 


########################################################creatdatabase##########################################
function  creatdatabase(){
cd ~/DBMS/
read -p "Enter the name of the database please :: " dbname
		if [ -z $dbname ]; then
                        echo ""
			echo -e $RED "please enter a correct name"
                        echo ""
			echo -e $blue "Please enter your choice :  "
		
		elif [[ -d $dbname ]]; then
                        echo "" 
			echo -e $RED "This database name is exists have another name"
                        echo ""
			echo -e  $blue  "Please enter your choice : "
			
		else
                         if [[ $dbname == [a-zA-Z]* ]]
                         then
                           mkdir  ~/DBMS/$dbname 2</dev/null 
                           cd ~/DBMS/$bdname
                           echo ""
			   echo -e $grean "Database $dbname created Successfully "
                         else
                           echo ""
                           echo -e  $RED "Please enter a correct name : "
			 fi
                         echo ""
                         mainmenu 
		fi 
} 

########################################################listdatabase##########################################
function listdatabase(){  
count="$(ls ~/DBMS | wc -l)"
if [ $count -eq 0 ] ; then
   echo -e $RED "You don't have any database yet "
else 
   echo -e $grean  "your databases are : "
   echo "" 
   ls  ~/DBMS
fi
echo ""
mainmenu
} 

########################################################connectdatabase##########callatablemenu################################
function connectdatabase(){
  cd ~/DBMS/
  echo -e $blue "Enter Database Name : "
  read dbName 
  if [ -z $dbName ]
     then
         echo ""
         echo -e $RED " please enter a correct name"
         echo ""
         echo -e $blue "Please enter your choice :  "

     elif [[ -d $dbName ]]; then
         cd ~/DBMS/$dbName
         echo ""  
         echo -e $grean "Database $dbName was Successfully connected" 
         echo ""
         tablemenu

     else
         echo ""
         echo -e $RED "Database $dbName wasn't found"
         echo ""
         echo -e $blue "Please enter your choice :  "
 fi

} 
 ########################################################dropdatabase##########################################
function dropdatabase(){
 cd ~/DBMS/ 
   echo -e $blue 
 read -p "Enter Database Name: " dbnam
 if [ -z $dbnam ]
     then
         echo ""
         echo -e  $RED "please enter a correct name"
         echo ""
         echo -e $blue "Please enter your choice : "


     elif [[ -d $dbnam ]]; then
         rm -r ~/DBMS/$dbnam 2</dev/null
         echo ""
         echo -e $grean "Database Dropped Successfully" 
         echo ""
         mainmenu

     else
         echo ""
         echo -e $RED "Database $dbnam wasn't found"
         echo ""
         echo -e $blue "Please enter your choice : " 
 fi

} 


########################################################tablemenu##########################################
function tablemenu(){
echo -e $blue "Please enter your choice: "
echo -e $blue
options1=("Creat Table" "List Table" "Drop Table" "Insert Into table" "Select from table" "Drop row from table" "Updata table" "Back to main menu")
select opt1 in "${options1[@]}"
do
    case $opt1 in
        "Creat Table")
            createTable
              ;;
        "List Table")
            listtables
              ;;
        "Drop Table") 
            droptable  
              ;;
        "Insert Into table")
            insertintotable 
              ;; 
        "Select from table") 
            selectfromtable
              ;; 
        "Drop row from table")
            dropfromtable
              ;; 
        "Updata table")
            updatetable
              ;;
        "Back to main menu")
            mainmenu
            break
              ;;
         *)
           echo "" 
           echo -e $RED "invalid option $REPLY" 
           echo ""
           echo -e $blue "Please enter your choice!!"
              ;;
    esac
done

}  


############################createtable########################################################## 

function createTable(){   

                         cd ~/DBMS/$dbName/ 
                            echo -e $blue

		read -p "Please enter name of table : " tablename
		
		if [ -z $tablename ]; then
                        echo ""
			echo -e  $RED  " Please enter a correct name"
                        echo ""
			echo -e $blue "Please enter your choice : "
		
		elif [ -f "$tablename" ]; then
                        echo ""
			echo -e $RED  "this table name exists"
                        echo ""
			echo -e  $blue " Please enter your choice : "
			
		else
                        if [[ $tablename == [a-zA-Z]* ]]
                        then 
                          echo ""
			  echo -e $grean "Table create Successfully "
                          echo ""
			  touch ./"$tablename"
                          touch ./metaData_$tablename
                          mv ./metaData_$tablename ./.metaData_$tablename
                          read -p "Enter Number of Columns : " colnumber

         echo "general : Table Name : "$tablename >> .metaData_$tablename
         echo "general : Number of Columns : "$colnumber >> .metaData_$tablename

          index=1
          while [ $index -le $colnumber ]
               do
                if [ $index -eq 1 ]
                then
                        echo -e $blue "===================================="
                        echo -e $blue "The First Column is primary Key"
                        echo -e $blue "===================================="
                        read -p "Enter column $index name : " colname
                        echo "primary key : $index : $colname : int " >> .metaData_$tablename
                        printf "$colname:" >> $tablename
                      

                else
                   echo ""     
                   read -p "Enter column $index name : " colname
                   echo ""
                   echo -e "Type of Column $colname: "
               select datatype in "int" "str"
                 do
                  case $datatype in
                  int ) colType="int";break;;
                  str ) colType="string";break;;
               * ) echo -e $RED "Wrong Choice!!!" ;;
              esac
             done
            echo "Not primary key : $index : $colname : $datatype " >> .metaData_$tablename
            printf "$colname:" >> $tablename
            

                fi

               ((index = $index+1))
        done
        printf "\n" >> $tablename
        printf "=================\n" >> $tablename
        echo
        echo -e  $grean "Table Created Successfully"
        echo ""
        tablemenu
                        else 
                          echo ""
                          echo -e $RED " Please enter a correct name"
                          echo ""
                        fi   
                        echo ""
                        tablemenu
		fi 
}




##########################################insert into table ##################################

function insertintotable(){
echo -e  $blue
read -p "Enter Table Name : " table_name   
	if [ -z $table_name ]; then
       echo ""
       echo -e $RED "Enter The Table Name!!!"	
       echo ""
       echo "Please enter your choice : "
	elif [[ -f $table_name  ]]
        then
	index=1
	size=0
	row=""
       for tableName in `ls`
        do
            if [ $tableName = $table_name ]; then 
           
	      echo -e $grean "Table Selected successfully" 
              echo  -e  $blue "===================================="
	      echo  -e  $blue "The First Column is primary Key and should be a number"
	      echo  -e  $blue "======================================================="
		array=(`awk -F":" '{if (NR>=3) print $3}' .metaData_$tableName`)
		arr=(`awk -F":" '{print $1}' $tableName`)		
		size=${#array[*]}
		read -p "Enter value of column ${array[0]} : " input
		    if [ -z $input ];  then
                     echo ""
		     echo -e $RED  "Primary Key Cann't be Null!!!" 
                     echo ""
                     echo -e $blue"back to menu" 
                     echo ""
                         tablemenu

              elif [[ $input =~ [a-zA-Z]+$ ]]; then 
                  echo ""
                  echo -e $RED "Primary Key accept numbers only!!!" 
                  echo ""
                  echo -e $blue"back to menu" 
                  echo ""         
                         tablemenu
			elif [ ${#arr[*]} -eq 0 ];    then
			inputarray[0]=$input 

               
			while (($index < $size))
			do
			read -p "Enter value of column ${array[index]} : " inputarray[index]
			((index =$index+1))
			done
		else
                    index=0
		while (($index < ${#arr[*]}))
		do
	       if [ $input = ${arr[index]} ];	then
                echo ""
		echo -e $RED "Primary Key must be unique!!!" 
                echo ""
                echo -e $blue"back to menu" 
                echo ""
                           
                         tablemenu
	         fi
	         ((index =$index+1))
		done

                index=1
                row=${inputarray[0]}
	         inputarray[0]=$input
		while (($index < $size))
		do
		read -p "Enter value of column ${array[index]} : " inputarray[index]
                
                let a=$index+3

               value=$(awk -v patt=$a  -F: '{if (NR == patt) print $4}' .metaData_$tableName)
               
                if [[ -z ${inputarray[index]}  ]]
                then
                 echo ""
                 echo -e $RED "attention this field will be empty field !!!!"
                 echo ""
                 read -p "Do you agree [y or n] ?  : " ans
                 if [[ $ans  == 'y' || $ans == 'Y' ]]
                 then
                    ((index =$index+1))
                else   
                   tablemenu
                fi

                elif [[ $value =~ "str" ]] 
                then
               
		if [[ ${inputarray[index]} =~ ^[a-zA-Z] ]]
                then
		((index =$index+1))
                else
                echo -e $RED you should enter string value
                echo "Please enter your choice"
                return 1
                fi
                elif [[ $value =~ "int" ]] 
                then
                if [[ ${inputarray[index]} =~ [0-9.]+$ ]]
                then
                ((index =$index+1))
                else
                echo -e $RED you should enter number
                echo "Please enter your choice"
                return 1
                fi
                else
                echo -e $RED you should enter valid value
                echo "Please enter your choice"
                return 1
                fi
		done
	fi              
               
                		
	    if [ $? == 0 ]
            then
             {
             index=1
		row=${inputarray[0]}
		while (($index < $size))
		do
		row=$row":"${inputarray[index]}
		((index =$index+1))
		done
              echo " "
                echo $row >> $tableName
                echo -e $grean "Row inserted successfully"
                echo ""
                echo -e $blue "Please enter your choice"
                return 0

             }
              
            fi

		fi	
        done
        else
	echo " "
	echo -e $RED "Table Not exists!!!"
	echo " "
        echo -e $blue "Please enter your choice"
fi
}


#############################################droptable#######################################
function droptable(){ 
cd ~/DBMS/$dbName/

echo -e $blue 
read -p "Enter table Name: " tablename
 if [ -z $tablename ]
     then
         echo ""
         echo -e  $RED " please enter a correct name"
         echo ""
         echo -e $blue "Please enter your choice : "

     elif [[ -f $tablename ]]; then
         rm  ./$tablename 2</dev/null
         rm ./.metaData_$tablename 2</dev/null
         echo ""
         echo -e $grean "Table Dropped Successfully" 
         echo ""
         tablemenu

     else
         echo ""
         echo -e $RED "Table $tablename  Not found"
         echo ""
         echo -e $blue " Please enter your choice  : "
 fi

}

##########################################listtables############################################

function listtables(){
cd  ~/DBMS/$dbName/

count="$(ls | wc -l)"
if [ $count -eq 0 ] ; then
echo ""
echo -e $RED "you don't have any tables yet "
else 
echo ""
echo -e $grean  "your tables are " 
echo ""
ls  ./
fi
echo ""
tablemenu
}




################################################################################

function selectfromtable(){

echo -e $blue "Please enter table name"
read tableNme
     if [ -z $tableNme ]
        then
        echo ""
        echo -e $RED "Please enter The Table Name!!!"   
        echo ""
        echo -e $blue "Please enter the choice : "
        else
        for tableList in `ls`
         do
          if [ -f "$tableNme" ]
          then
          {
            echo -e $blue "Please enter your choice: " 
         echo -e $blue

           select opt in "Select all table data" "Select row" "Select col" "back to table menu"
              do
                case $REPLY in
                1)
                  echo ""
                  selectall $tableNme
                        ;;
                2)
                  echo Please enter row primary key you want to select
                  read rowID
                  selectRow $tableNme  $rowID
                        ;;
                3)
                  echo enter column number you want to select
                  read colNum
                  selectCol $tableNme  $colNum
                        ;;
                4)
                  tablemenu
                  break
                       ;; 
                           
                *) 
                   echo ""  
                   echo -e $RED "invalid option $REPLY"   
                   echo ""
                   echo -e $blue "Please enter your choice !!"  
              ;;

                esac
             done
         }
         else
            echo ""
            echo -e $RED "This table not found" 
            echo ""
            break
         fi
   done
fi
}




#############################################################################

function selectCol(){
fileN=$1
selectedCol=$2

if [ -z $selectedCol ]
      then
        echo ""
        echo -e $RED " please enter column number"
        echo ""
        echo -e $blue "Please enter your choice  : "

      elif [[ $selectedCol =~ [0-9]+$ ]]
      then
         Ncol=$(awk -v p="$selectedCol" -F: 'FNR == 3 {print NF;exit}' $fileN)
         if [ $Ncol -ge $selectedCol ]
         then
         echo ""
         awk -v val="$selectedCol"  -F: '{print $val}' $fileN
         else
         echo ""
         echo -e $RED "This col number not found"
         echo -e $blue "Please enter your choice : "
         fi
      else
            echo ""
            echo -e $RED "You should enter column number"
            echo ""
            echo -e $blue "Please enter your choice  : " 
      fi
}

##############################################################################

function selectRow(){
fileNm=$1
selectedParameter=$2
      if [ -z $selectedParameter ]
      then
        echo ""
        echo -e $RED " primary key shouldn't be null !!!!"
        echo ""
        echo -e $blue " Please enter your choice : "

      elif [[ $selectedParameter =~ [0-9] ]]
      then
         val=$(awk  -F: '{print $1}' $fileNm | grep -w $selectedParameter)
            if [ $? == 0 ]
            then
             {
               awk -v pat="$selectedParameter"  -F: '$1 == pat' $fileNm
               echo ""
               echo -e $blue "Please enter your choice : "
             }
            else
              echo ""
              echo -e $RED "This primary key not found"
              echo ""
              echo -e $blue "Please enter your choice : "
            fi
      else
            echo ""
            echo -e $RED "Primary key should be number !!!!"
            echo ""
            echo -e $blue " Please enter your choice : "   
      fi

}
################################################################################

function selectall(){
echo -e $grean "Table data is :"
echo --------------
cat $1
echo ""
echo -e $blue "Please enter your choice : "
}


################################################################################33

function updatetable(){
echo ""
echo -e  $blue "Please enter table name : "
read tname
if [ -z $tname ]
     then
         echo ""
         echo -e $RED " please enter a correct name "
         echo ""
         echo -e $blue " Please enter your choice : "

     elif [[ -f $tname ]]
     then
         echo ""
         echo -e $blue " Please enter row primary key you want to update it " 
         read pk
         if [ -z $pk ]
         then
           echo ""
           echo -e $RED "Primary key shouldn't be null !!!!!"
           echo ""
           tablemenu

         elif [[ $pk =~ [0-9] ]]
         then
           echo ""
           echo -e $green "Row you want to update is : "
           awk -v pat1="$pk"  -F: '$1 == pat1' $tname
           alue=$(awk  -F: '{print $1}' $tname | grep -w $pk)
            if [ $? == 0 ]
            then
             {
               var=$(awk -v pat="$pk"  -F: '{if ($1 == pat) print NR}'  $tname)
               echo ""
               echo -e $blue "enter old value : "
               read old
               word=$(awk  -F: '{print $0}' $tname | grep -w $old)
               if [ $? == 0 ]
               then
               echo -e $blue "enter new value : "
               read new
               sed -i "$var s/$old/$new/" $tname
               echo ""
               echo -e $grean "Field updated successfully"
               echo ""
               echo -e  $blue "Table data after update  is : "
               echo -----------------------------
               cat $tname
               echo ""
               tablemenu
               else
               echo ""
               echo -e $RED "This word not found"
               echo ""
               tablemenu
               fi
             }
            else
              echo ""
              echo -e $RED "This primary key not found"
              echo ""
              echo -e $blue "Please enter your choice : "
            fi
else
            echo ""
            echo -e  $RED "Primary key should be number !!!"
            tablemenu
         fi
     else
         echo ""
         echo -e $RED "Table $tname  Not found"
         echo ""
         echo -e $blue "Please enter your choice  : " 
fi

}


######################################################################################3  

function dropfromtable(){ 
echo -e $blue
read -p "Enter table Name: " tabname
if [ -z $tabname ]
     then
         echo ""
         echo -e $RED " please enter a correct name  "
         echo ""
         echo -e $blue  " Please enter your choice : "

     elif [[ -f $tabname ]]
     then
         echo ""
         echo -e $blue "Please enter row primary key to delete : "
         read -r  rId
         if [ -z $rId ]
         then
           echo ""
           echo -e $RED "Primary key shouldn't be null !!!!!"
           tablemenu

         elif [[ $rId =~ [0-9] ]]
         then
            val=$(awk  -F: '{print $1}' $tabname | grep -w $rId)
            if [ $? == 0 ]
            then
             {
               sed -i "/$rId/d" $tabname
               echo ""
               echo -e $green "Row dropped successfully"
               echo ""
               echo  -e $grean "File data now : "
               echo --------------
               cat $tabname
               echo ""
               tablemenu
             }
            else
              echo ""
              echo -e $RED "This primary key not found"
              echo ""
              tablemenu
            fi
           
         else
            echo ""
            echo -e $RED "Primary key should be number !!!"
            echo ""
            tablemenu          
         fi
     else
         echo ""
         echo -e $RED "Table $tabname  Not found"
         echo ""
         echo -e $blue " Please enter your choice : "  
fi  

}






#####################################first outbut##################################################################### 

RED='\033[0;31m'
blue='\033[0;34m'
grean='\033[0;32m'

PS3='$'  
echo -e $RED
read -p "Do You Want to Start (y or n) ? : " answer
     if [[ $answer  == 'y' || $answer == 'Y' ]]
      then
	    echo  -e $green "Please Wait..."
            echo ""
	    sleep 2 
            if [[ -d ~/DBMS ]]
             then
	        echo -e $green  "You are in DBMS directory"
                echo ""
                else   mkdir ~/DBMS 
                cd ~/DBMS
                echo -e $blue  "you just created $PWD directory welcome to our  database"
                echo ""
            fi
           mainmenu
      elif [[ $answer == 'n' || $answer == 'N' ]]; then
            echo "" 
            echo -e $RED "Have a good day"
            echo ""
	    exit 
      else 
        echo ""
        echo -e $RED "Please enter correct answer"
        echo ""
        ./mainpage.sh
      fi 



