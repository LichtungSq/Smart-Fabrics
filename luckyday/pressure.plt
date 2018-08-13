#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "relaxation.eps"
set datafile separator ","

set key bottom left
set key samplen 2
set key spacing 1
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:2]
set xtics 0.5
set yrange [-1.0:0.2]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "relaxation.csv" using 1:2 title "Sample 1" w l ls 10,\
     0.0233*exp(-0.04591*(x-32.7646)) using 1:2 title "Sample 2" w l ls 11,\


   