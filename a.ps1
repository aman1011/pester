# Author:
# Script Name: get_Queries
# Date: July 2021
# Jira:LEOP-3851
# Action: Report Update Restore
# Description: purpose, scope
$query="TRANSACTION ISOLATION LEVEL READ UNCOMMITTED select ACTOR from LMGENDB.lm_gen.ACTORROLE"
$updatequery="update ACTOR set something to something" 
$deletequery="delete ACTOR from something"
