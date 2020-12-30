#!/usr/bin/env bash

for i in *.svg
do
j="${i}.pdf"
echo "${i}" "-->" "${j}"
inkscape -D -z --file="${i}" --export-pdf="${j}"
done

