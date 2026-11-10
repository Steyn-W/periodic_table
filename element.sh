#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check for missing argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
# Get all the information from the database
ELEMENT_INFO=$($PSQL "
  SELECT elements.atomic_number, elements.name, elements.symbol,
         types.type, properties.atomic_mass,
         properties.melting_point_celsius,
         properties.boiling_point_celsius
  FROM elements
  INNER JOIN properties ON elements.atomic_number = properties.atomic_number
  INNER JOIN types ON properties.type_id = types.type_id
  WHERE elements.atomic_number::TEXT = '$1'
     OR elements.symbol = '$1'
     OR LOWER(elements.name) = LOWER('$1');
")

# If the element is not found
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Put the ELEMENT_INFO into 7 variables
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"

# Output message
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."