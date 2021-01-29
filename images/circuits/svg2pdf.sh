#!/usr/bin/env bash

for i in *.svg
do
j="${i}.pdf"
echo "${i}" "-->" "${j}"
#inkscape -D -z --file="${i}" --export-pdf="${j}" --export-margin=1
rsvg-convert -f pdf -o "${j}" "${i}"
pdfcrop "${j}" "${j}"
done

