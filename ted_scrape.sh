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
    sed -n '/Programs &amp. initiatives/q;p' | # remove footer from **** Programs & initiatives ****
    head -n-1 |  # remove header space
    tail -n+2 > ted_transcripts/talk$counter.csv # remove footer and seperate each talk into a seperate file
    counter=$((counter+1))
done