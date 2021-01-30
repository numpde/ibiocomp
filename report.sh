#!/usr/bin/env bash

rm report/15sticks.zip
zip report/15sticks.zip -x "*.bak" -r tex/main.pdf code/20201231*/*
cp tex/main.pdf report/15sticks.pdf
