# Author: JK Joseph
# Script Name: get_Queries
# Date: July 2021
# Action: Report Update Restore
# Description: purpose, scope
$query="TRANSACTION ISOLATION LEVEL READ UNCOMMITTED select ACTOR from LMGENDB.lm_gen.ACTORROLE"
$updatequery="TRANSACTION ISOLATION LEVEL READ UNCOMMITTED update ACTOR set something to something"