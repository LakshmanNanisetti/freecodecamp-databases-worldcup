#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Create the table games
# $($PSQL "CREATE TABLE teams (team_id SERIAL PRIMARY KEY, name VARCHAR UNIQUE)")
# Create table teams

# $($PSQL "CREATE TABLE games (game_id SERIAL PRIMARY KEY, year INT, round VARCHAR UNIQUE)")
cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    RESULT=$($PSQL "SELECT * FROM TEAMS WHERE name = '$WINNER'")
    if [[ -z $RESULT ]]
    then
      echo $($PSQL "INSERT INTO teams(name) values('$WINNER')")
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    RESULT=$($PSQL "SELECT * FROM TEAMS WHERE name = '$OPPONENT'")
    if [[ -z $RESULT ]]
    then
      echo $($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    $PSQL "INSERT INTO games
    (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
