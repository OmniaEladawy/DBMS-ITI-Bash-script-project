#!/bin/bash

function selectCol(){
fileN=$1
selectedCol=$2
echo $selectedCol
awk -v val="$selectedCol"  -F: '{print $val}' $fileN
}

##############################################################################

function selectRow(){
fileNm=$1
selectedParameter=$2
echo $selectedParameter
awk -v pat="$selectedParameter"  -F: '{for (i=1;i<=NF;i++) if ($i~pat) {print $0}}' $fileNm
}
################################################################################

function selectall(){
cat $1
}

################################################################################

function selectfromtable(){

echo "Please enter table name"
read tableNme
        if [ -z $tableNme ]
 then
       echo "Enter The Table Name!!!"   
        fi
echo the table you entered is $tableNme
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
        echo select all table data
        selectall $tableNme 
            ;;
        2)
          echo select row by id
          echo enter id
          read rowID
          selectRow $tableNme  $rowID    
            ;;
        3)
            echo select field
            echo enter col number
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
echo This table not exist 
tablemenu
fi

done

}

################################################################################33

function updatetable(){
echo hello
}


######################################################################################3  

function dropfromtable(){
read -p "Enter table Name: " tabname
if [ -z $tabname ] ; then
echo -e "please enter the name to delet"
else

echo please enter row id to delete
read -r  rId
sed -i "/$rId/d" $tabname
cat $tabname
  fi
if [ $? == 0 ]; then
    echo -e "row Dropped Successfully"
     tablemenu
  else
    echo -e "table Not found"
    tablemenu
  fi
}





##########################################insert into table ##################################

function insertintotable(){
read -p "Enter Table Name : " table_name   
	if [ -z $table_name ]; then
       echo "Enter The Table Name!!!"	
	fi

	 index=1
	size=0
	row=""
        for tableName in `ls`
        do
            if [ $tableName = $table_name ]; then
	      echo "Table Selected successfully" 
              echo "===================================="
	      echo "The First Column is the primary Key"
	      echo "===================================="
		array=(`awk -F":" '{if (NR>=3) print $3}' metaData_$tableName`)
		arr=(`awk -F":" '{print $1}' $tableName`)		
		size=${#array[*]}
		read -p "Enter the value of column ${array[0]} : " input
		    if [ -z $input ];  then
		     echo "Primary Key Cann't be Null!!!" 
                        return 1 
              elif [[ $input =~ ^[a-zA-Z]+$ ]]; then 
                  echo "Primary Key accept numbers only!!!" 
                        return 1
			elif [ ${#arr[*]} -eq 0 ];    then
			inputarray[0]=$input 

               
			while (($index < $size))
			do
			read -p "Enter the value of column ${array[index]} : " inputarray[index]
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
	         inputarray[0]=$input
		while (($index < $size))
		do
		read -p "Enter the value of column ${array[index]} : " inputarray[index]
		((index =$index+1))
		done
		fi
			
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
		fi	
        
        done
	echo " "
	echo "Table Not exists!!!"
	echo " "
}

#############################################droptable#######################################
function droptable(){
read -p "Enter table Name: " tablename 
if [ -z $tablename ] ; then 
echo -e "please enter the name to delet"
else 
 rm  ./$tablename 2</dev/null 
  fi 
if [ $? == 0 ]; then
    echo -e "table Dropped Successfully"
     tablemenu
  else
    echo -e "table Not found"
    tablemenu
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
echo Please enter your choice
fi
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
                        echo "The First Column is the peimary Key"
                        echo "===================================="
                        read -p "Enter column name of $index : " colname
                        echo "primary key : $index : $colname : int " >> .metaData_$tablename
                else
                        read -p "Enter column name of $index : " colname
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
options1=("Creat Table" "List Table" "Drop Table" "Insert Into table" "Select from table" "Drop from table" "Updata table" "Back to main menu")
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
        "Drop from table")
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



