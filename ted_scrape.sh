#!/usr/bin/env bash

for i in {1..107}
do
    curl "https://www.ted.com/talks?sort=popular&language=en&topics%5B%5D=Technology&page=$i&sort=popular" |
    grep "href='/talks/" | # grap only talks that have a link
    sed "s/^.*href='/https\:\/\/www\.ted\.com/" | 
    sed "s/?.*$/\/transcript/" | # clean the link to fetch the transcript only
    uniq # remove duplictae
done > ted_links.csv # save the links in a csv file

counter=1
for i in $(cat ted_links.csv)
do
    curl $i |
    html2text |
    sed -n '/Details About the talk/,$p' | # remove extra space at the top of each talk
    tail -r | # reverse the order of the lines in its input
    tail -n +45 |  # remove the footer space
    tail -r > ted_transcripts/talk$counter.csv # return the order of the line and seperate each talk into a seperate file
    counter=$((counter+1))
done
