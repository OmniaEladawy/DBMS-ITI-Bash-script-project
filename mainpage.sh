#!/bin/bash

function selectCol(){
fileN=$1
selectedCol=$2

if [ -z $selectedCol ]
      then
        echo -e " please enter column number"
        echo Please enter your choice

      elif [[ $selectedCol =~ [0-9] ]]
      then
         awk -v val="$selectedCol"  -F: '{print $val}' $fileN
         echo Please enter your choice
      else
            echo "You should enter column number"
            echo Please enter your choice   
      fi
}

##############################################################################

function selectRow(){
fileNm=$1
selectedParameter=$2
      if [ -z $selectedParameter ]
      then
        echo -e " primary key shouldn't be null !!!!"
        echo Please enter your choice

      elif [[ $selectedParameter =~ [0-9] ]]
      then
         val=$(awk  -F: '{print $1}' $fileNm | grep -w $selectedParameter)
            if [ $? == 0 ]
            then
             {
               awk -v pat="$selectedParameter"  -F: '$1 == pat' $fileNm
               echo ""
               echo Please enter your choice
             }
            else
              echo "This primary key not found"
              echo ""
              echo Please enter your choice
            fi
      else
            echo "Primary key should be number !!!!"
            echo ""
            echo Please enter your choice   
      fi

}
################################################################################

function selectall(){
echo Table data is :
echo --------------
cat $1
echo ""
echo Please enter your choice
}

################################################################################

function selectfromtable(){

echo "Please enter table name"
read tableNme
     if [ -z $tableNme ]
        then
        echo "Please enter The Table Name!!!"   
        echo Please enter the choice
        else
        for tableList in `ls`
         do
          if [ -f "$tableNme" ]
          then
          {
            echo "Please enter your choice: "

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
                *) echo "invalid option $REPLY";;
                esac
             done
         }
         else
            echo this table not found
         fi
   done
fi
}

################################################################################33

function updatetable(){
echo ""
echo Please enter table name
read tname
if [ -z $tname ]
     then
         echo -e " please enter a correct name"
         echo Please enter your choice

     elif [[ -f $tname ]]
     then
         echo Please enter row primary key you want to update in 
         read pk
         if [ -z $pk ]
         then
           echo -e "Primary key shouldn't be null !!!!!"
           tablemenu

         elif [[ $pk =~ [0-9] ]]
         then
           echo ""
           echo "Row you want to update is"
           awk -v pat1="$pk"  -F: '$1 == pat1' $tname
           alue=$(awk  -F: '{print $1}' $tname | grep -w $pk)
            if [ $? == 0 ]
            then
             {
               var=$(awk -v pat="$pk"  -F: '{if ($1 == pat) print NR}'  $tname)
               echo ""
               echo enter old value
               read old
               echo enter new value
               read new
               sed -i "$var s/$old/$new/" $tname
               echo ""
               echo "Field updated successfully"
               echo ""
               echo Table data after update  is :
               echo -----------------------------
               cat $tname
               echo ""
               tablemenu
             }
            else
              echo "This primary key not found"
              echo ""
              echo Please enter your choice
            fi
else
            echo "Primary key should be number !!!"
            tablemenu
         fi
     else
         echo -e "Table $tname  Not found"
         echo Please enter your choice  
fi

}


######################################################################################3  

function dropfromtable(){
read -p "Enter table Name: " tabname
if [ -z $tabname ]
     then
         echo -e " please enter a correct name"
         echo Please enter your choice

     elif [[ -f $tabname ]]
     then
         echo Please enter row primary key to delete
         read -r  rId
         if [ -z $rId ]
         then
           echo -e "Primary key shouldn't be null !!!!!"
           tablemenu

         elif [[ $rId =~ [0-9] ]]
         then
            val=$(awk  -F: '{print $1}' $tabname | grep -w $rId)
            if [ $? == 0 ]
            then
             {
               sed -i "/$rId/d" $tabname
               echo ""
               echo "Row dropped successfully"
               echo ""
               echo "File data now"
               echo --------------
               cat $tabname
               echo ""
               tablemenu
             }
            else
              echo "This primary key not found"
              echo ""
              tablemenu
            fi
           
         else
            echo "Primary key should be number !!!"
            tablemenu          
         fi
     else
         echo -e "Table $tabname  Not found"
         echo Please enter your choice  
fi  

}



##########################################insert into table ##################################

function insertintotable(){
read -p "Enter Table Name : " table_name   
	if [ -z $table_name ]; then
       echo "Enter The Table Name!!!"	
	elif [[ -f $table_name  ]]
        then
	index=1
	size=0
	row=""
       for tableName in `ls`
        do
            if [ $tableName = $table_name ]; then 
           
	      echo "Table Selected successfully" 
              echo "===================================="
	      echo "The First Column is primary Key and should be a number"
	      echo "===================================="
		array=(`awk -F":" '{if (NR>=3) print $3}' .metaData_$tableName`)
		arr=(`awk -F":" '{print $1}' $tableName`)		
		size=${#array[*]}
		read -p "Enter value of column ${array[0]} : " input
		    if [ -z $input ];  then
		     echo "Primary Key Cann't be Null!!!" 
                        return 1 
              elif [[ $input =~ [a-zA-Z]+$ ]]; then 
                  echo "Primary Key accept numbers only!!!" 
                        return 1
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
		echo "Primary Key must be unique!!!" 
                return 1
	         fi
	         ((index =$index+1))
		done

                index=1
                row=${inputarray[0]}
	         inputarray[0]=$input
		while (($index < $size))
		do
		read -p "Enter value of column ${array[index]} : " inputarray[index]
                echo ${inputarray[index]}
                let a=$index+3

               value=$(awk -v patt=$a  -F: '{if (NR == patt) print $4}' .metaData_$tableName)
              
               
                if [[ -z ${inputarray[index]}  ]]
                then
                 echo "attention this field will be empty field !!!!"
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
                echo you should enter string value
                return 1
                fi
                elif [[ $value =~ "int" ]]
                then
                if [[ ${inputarray[index]} =~ [0-9.]+$ ]]
                then
                ((index =$index+1))
                else
                echo you should enter number
                return 1
                fi
                else
                echo you should enter valid value
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
                echo "Row inserted successfully"
                return 0

             }
              
            fi
		fi	
        done
        else
	echo " "
	echo "Table Not exists!!!"
	echo " "
fi
}


#############################################droptable#######################################
function droptable(){
read -p "Enter table Name: " tablename
 if [ -z $tablename ]
     then
         echo -e " please enter a correct name"
         echo Please enter your choice

     elif [[ -f $tablename ]]; then
         rm  ./$tablename 2</dev/null
         rm ./.metaData_$tablename 2</dev/null
         echo -e "Table Dropped Successfully" 
         tablemenu

     else
         echo -e "Table $tablename  Not found"
         echo Please enter your choice  
 fi

}

##########################################listtables############################################

function listtables(){
count="$(ls ./ | wc -l)"
if [ $count -eq 0 ] ; then
echo -e "you don't have any tables yet "
else 
echo -e  "your tables are " 
ls  ./
fi
tablemenu
}

############################createtable########################################################## 

function createTable(){

		read -p "Please enter name of table : " tablename
		
		if [ -z $tablename ]; then
			echo -e " Please enter a correct name"
			echo Please enter your choice
		
		elif [ -f "$tablename" ]; then
			echo -e "this table name exists"
			echo Please enter your choice
			
		else
                        if [[ $tablename == [a-zA-Z]* ]]
                        then 
			  echo -e "Table create Successfully "
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
                        echo "===================================="
                        echo "The First Column is primary Key"
                        echo "===================================="
                        read -p "Enter column $index name : " colname
                        echo "primary key : $index : $colname : int " >> .metaData_$tablename
                else
                        read -p "Enter column $index name : " colname
                   echo -e "Type of Column $colname: "
               select datatype in "int" "str"
                 do
                  case $datatype in
                  int ) colType="int";break;;
                  str ) colType="string";break;;
               * ) echo "Wrong Choice" ;;
              esac
             done
            echo "Not primary key : $index : $colname : $datatype " >> .metaData_$tablename

                fi

               ((index = $index+1))
        done
        echo "Table Created Successfully"
        tablemenu
                        else 
                          echo -e " Please enter a correct name"
                        fi   
                        echo Please enter your choice
		fi 
}


########################################################tablemenu##########################################
function tablemenu(){
echo "Please enter your choice: "
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
        *) echo "invalid option $REPLY"
              ;;
    esac
done

}

########################################################creatdatabase##########################################
function  creatdatabase(){
cd ~/DBMS/
read -p "Enter the name of the database please :: " dbname
		if [ -z $dbname ]; then
			echo -e " please enter a correct name"
			echo Please enter your choice
		
		elif [[ -d $dbname ]]; then
			echo -e "This database name is exists have another name"
			echo Please enter your choice
			
		else
                         if [[ $dbname == [a-zA-Z]* ]]
                         then
                           mkdir  ~/DBMS/$dbname 2</dev/null 
                           cd ~/DBMS/$bdname
			   echo -e "Database $dbname created Successfully "
                         else
                           echo Please enter a correct name
			 fi
                         echo Please enter your choice
		fi 
} 

########################################################listdatabase##########################################
function listdatabase(){  
count="$(ls ~/DBMS | wc -l)"
if [ $count -eq 0 ] ; then
   echo -e "You don't have any database yet "
else 
   echo -e  "your databases are : " 
   ls  ~/DBMS
fi
echo Please enter your choice
} 

########################################################connectdatabase##########callatablemenu################################
function connectdatabase(){
  cd ~/DBMS/
  echo -e "Enter Database Name : "
  read dbName 
  if [ -z $dbName ]
     then
         echo -e " please enter a correct name"
         echo Please enter your choice

     elif [[ -d $dbName ]]; then
         cd ~/DBMS/$dbName  
         echo "Database $dbName was Successfully connected" 
         tablemenu

     else
         echo "Database $dbName wasn't found"
         echo Please enter your choice  
 fi

} 
 ########################################################dropdatabase##########################################
function dropdatabase(){
 cd ~/DBMS/
 read -p "Enter Database Name: " dbnam
 if [ -z $dbnam ]
     then
         echo -e " please enter a correct name"
         echo Please enter your choice


     elif [[ -d $dbnam ]]; then
         rm -r ~/DBMS/$dbnam 2</dev/null
         echo -e "Database Dropped Successfully" 
         echo Please enter your choice

     else
         echo "Database $dbnam wasn't found"
         echo Please enter your choice  
 fi

} 

#############################################mainmenu############################################

function mainmenu(){
echo "Please enter your choice: "

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
           exit
           break
            ;;
        *) echo "invalid option $REPLY"
            ;;
    esac
 done 
}

#####################################first outbut#####################################################################
PS3='$' 
read -p "Do You Want to Start (y or n) ? : " answer
     if [[ $answer  == 'y' || $answer == 'Y' ]]
      then
	    echo "Please Wait..."
	    sleep 2 
            if [[ -d ~/DBMS ]]
             then
	        echo -e "You are in DBMS directory"

                else   mkdir ~/DBMS 
                cd ~/DBMS
                echo -e "you just created $PWD directory welcom to our  database"
            fi
           mainmenu
      elif [[ $answer == 'n' || $answer == 'N' ]]; then 
            echo -e "Have a good day"
	    exit 
      else 
        echo -e "Please enter correct answer"
        ./mainpage.sh
      fi 



