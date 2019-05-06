#!/bin/bash
# capitals - A country capital guessing game. Requires the country capitals
# Inspired on Wicked Shell Scripts
# Usage:  
# ./capitals.sh europa.txt

db="$1"     # Format is country[tab]City
dbGen="./temp.txt"

if [ ! -r "$db" ] ; then
  echo "$0: Can't open $db for reading." >&2
  echo "(get a file like http://www.intuitive.com/wicked/examples/state.capitals.txt" >&2
  echo "save the file and run $0 capitals.txt!)" >&2
  exit 1
fi

#TODO: Avoid the need of dbGen variable and corresponding file.
#Shuffling and storing to 'lines' array
shuf $db > $dbGen
readarray -t lines < "$dbGen"

#shuf ./capitales.txt | readarray -t lines 
#readarray -t lines < shuf ./capitales.txt

for thiskey in "${lines[@]}"
do
   #echo "$thiskey"
   # $thiskey is the selected line. Now let’s grab country and city info,
  # then also have "match" as the all-lowercase version of the city name

  country="$(echo $thiskey | cut -d\   -f1 | sed 's/-/ /g')"
   city="$(echo $thiskey | cut -d\   -f2 | sed 's/-/ /g')"
  match="$(echo $city | tr '[:upper:]' '[:lower:]')"

  guess="??" ; total=$(( $total + 1 )) ;

  echo ""
  echo "What city is the capital of $country?"
  echo "(You can also type 'next' or 'quit')"

  # Main loop where all the action takes place. Script loops until
  # city is correctly guessed, or the user types "next" to 
  # skip this one, or "quit" to quit the game

  while [ "$guess" != "$match" -a "$guess" != "NEXT" -a "$guess" != "QUIT" ]
  do
    /bin/echo -n "Answer: "
    read guess
    #uppercase
    guess=${guess^^}
    if [ "$guess" = "$match" -o "$guess" = "$city" ] ; then
      echo ""
      echo "*** Absolutely correct!  Well done! ***"
      correct=$(( $correct + 1 ))
      guess=$match
    elif [ "$guess" = "NEXT" -o "$guess" = "QUIT" ] ; then
      echo ""
      echo "$city is the capital of $country."  # what you SHOULD have known       
    else
      echo "I'm afraid that's not correct."
    fi     
  done
  if [ "$guess" = "QUIT" ] ; then
    break
  fi  
done

echo "You got $correct out of $total presented."
exit 0
