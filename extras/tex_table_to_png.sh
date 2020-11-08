#!/bin/bash

for file in $(ls {*table.tex,*table_[0-9].tex})
do
  pdflatex $file
  name=${file%.tex}
  magick convert -density 300 -units pixelsperinch $name.pdf -trim $name.png
done
