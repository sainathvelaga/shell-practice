#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e " $R not a root user, please run with root user $N "
    exit 1
else
    echo -e " $G starting the script $N"
fi

VALIDATE() {

    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILURE"
    else
        echo -e "$2 is $G Success"

}

for i in $@
do
{
    echo "package to be installed :$i
    dnf list installed $i &>>$LOGFILE
    if [ $? -eq 0 ]
    then
        echo -e " $Y $i is already installed , so it is skipped for installation $N"
    else
        dnf install $i -y >>$LOGFILE
        VALIDATE() $? "installation of $i"
    fi
}
done


