#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
INSERT_TEAM() {
  # check if the teams already exists in the database 
  # by selecting an id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
  # if the id is empty
  if [[ -z $TEAM_ID ]]
  then
    # insert the team with the following name into the table
    RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1')")
    # if insertion was successfull
    if [[ $RESULT == "INSERT 0 1" ]]
    then
      # print the message
      echo "Inserted into teams: $1"
    fi
  fi
}

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # value should not be equal to a header
  if [[ $WINNER != winner ]]
  then
    INSERT_TEAM "$WINNER"
  fi
  # value should not be equal to a header
  if [[ $OPPONENT != opponent ]]
  then
    INSERT_TEAM "$OPPONENT"
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # value should not be equal to a header
  if [[ $YEAR != year ]]
  then
    # extracting winnder_id from a database
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # extracting opponent_id from a database
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # inserting game data into a games table
    RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    # checking if assertion was successfull
    if [[ $RESULT == "INSERT 0 1" ]]
    then
      # printing insertion message
      echo "Inserted a game $WINNER VS $OPPONENT held in $YEAR into games table"
    fi
  fi
done