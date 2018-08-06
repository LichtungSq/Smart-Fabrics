#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "longtime.eps"
set datafile separator ","

set key at graph 0.89,0.97 
set key box 
set key samplen 3
set key spacing 1.2
set key reverse
set key Left
set key font "Helvetica,18"
set size 0.8,0.7

set xrange [0:291]
set xtics 50
set yrange [0:0.7]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "nonstop300s_baregrey_2layer_heat_slp1_spe75_pull20_per.csv" using 1:2 title "Raw Data" w l ls 23,\
    "peaks_long.csv" using 1:2 title "y=-0.00020x+0.42  r=0.95" w l ls 19,\
    "troughs_long.csv" using 1:2 title "y=0.00025x+0.98  r=0.98" w l ls 20
   