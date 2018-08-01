#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "grey_1layer.eps"
set datafile separator ","

set key at graph 0.86,0.97 
set key box 
set key samplen 3
set key spacing 1.2
set key reverse
set key Left
set key font "Helvetica,18"
set size 0.8,0.7

set xrange [0:65.7]
set xtics 20
set yrange [0:6]
set ytics 2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "nonstop50_baregrey_1layer_spe25_pull20_per.csv" using 1:2 title "Raw Data" w l ls 10,\
    "peaks_grey1.csv" using 1:2 title "y=-0.0026x+3.41  r=-0.17" w l ls 19,\
    "troughs_grey1.csv" using 1:2 title "y=-0.0015x+0.54  r=-0.51" w l ls 20
   