#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "blue_1layer.eps"
set datafile separator ","

set key at graph 0.85,0.97 
set key box 
set key samplen 3
set key spacing 1.2
set key reverse
set key Left
set key font "Helvetica,18"
set size 0.8,0.7

set xrange [0:66]
set xtics 20
set yrange [0:3.5]
set ytics 1

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "nonstop50_bareblue_1layer_spe25_pull20_per.csv" using 1:2 title "Raw Data" w l ls 10,\
    "peaks_blue1.csv" using 1:2 title "y=0.0014x+2.23  r=0.40" w l ls 19,\
    "troughs_blue1.csv" using 1:2 title "y=0.00053x+0.29  r=0.34" w l ls 20
   