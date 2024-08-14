#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -t -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
else
if [[ $1 =~ ^[0-9]+$  ]]
then
RESULT_INIT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
else
INPUT_LENGTH=$(echo -n $1 | wc -c)
if [[ $INPUT_LENGTH < 3 ]] 
then
RESULT_INIT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1'")
else
RESULT_INIT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name='$1'")
fi
fi
fi

if [[ -z $RESULT_INIT ]]
then
echo "I could not find that element in the database."
else
echo "$RESULT_INIT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
do
#echo "$ATOMIC_NUMBER"echo "$SYMBOL"echo "$NAME"
PROPERTIES_RESULT=$($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
echo "$PROPERTIES_RESULT" | while read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
done
fi


