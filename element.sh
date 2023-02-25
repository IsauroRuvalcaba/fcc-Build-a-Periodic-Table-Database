#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE '$1' IN (symbol, name)")
  else
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE '$1' IN (atomic_number)")
  fi
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
  # echo "$ELEMENT_INFO" | while read TYPE_ID BAR A_NUM BAR SYM BAR NAME BAR A_MASS BAR MPC BAR BPC BAR TYPE
  echo "$ELEMENT_INFO" | while IFS=" | " read TYPE_ID A_NUM SYM NAME A_MASS MPC BPC TYPE
  do
    echo "The element with atomic number $A_NUM is $NAME ($SYM). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  done
  fi
fi
