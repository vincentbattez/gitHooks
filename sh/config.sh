#!/bin/sh

# Colors
badTxt="\e[91m"
goodTxt="\e[92m"
actionTxt="\e[96m"
infoTxt="\e[95m"
endColor="\e[39m"

# Fonts
bold=$(tput bold)
normal=$(tput sgr0)

# 
# @props color
# @props step
# @props commitMessage
# 
message() {
  colorType=$1
  gitStep=$2
  commitMessage=$3
  symbol=""
  color=$endColor
  
  if [[ $gitStep != '' ]];
  then
    gitStep="[$gitStep] "
  fi

  if [[ $colorType == 'fail' ]];
  then
    symbol="✖ "
    color=$badTxt
  elif [[ $colorType == 'success' ]];
  then
    symbol="✓ "
    color=$goodTxt
  else
    color=$colorType
  fi
  
  printf "${bold}${color}${symbol}${gitStep}${commitMessage}${endColor}\n";
}

# 
# @props RT_currentTest name of current test ex: 'Unit test - Jest'
# @props RT_step        name of current step ex: 'pre-push'
# @props RT_command     command how want to run ex: 'npx jest' 
# @props RT_failValue   fail value returned by command ex: 1
# 
runTest() {
  RT_currentTest=$1
  RT_step=$2
  RT_command=$3
  RT_failValue=$4

  message ${infoTxt} '' "run ${RT_currentTest}..."
  $RT_command
  if [[ "$?" == $RT_failValue ]];
  then
    message 'fail' "$RT_step" "$RT_currentTest"
    echo
    exit 1
  fi
  message 'success' "$RT_step" "$RT_currentTest"
}