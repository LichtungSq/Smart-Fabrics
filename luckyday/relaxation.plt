#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "relaxation.eps"
set datafile separator ","

set key bottom right
set key samplen 2
set key spacing 1
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:80]
set xtics 20
set yrange [0:0.7]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "relaxation.csv" using 1:2 title "Data" w l ls 10,\
     "curve.csv" using 1:2 title "Fitted Curve" w l ls 19,\


   