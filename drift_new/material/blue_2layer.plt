#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "blue_2layer.eps"
set datafile separator ","

set key at graph 0.9,0.97 
set key box 
set key samplen 3
set key spacing 1.2
set key reverse
set key Left
set key font "Helvetica,18"
set size 0.8,0.7

set xrange [0:66]
set xtics 20
set yrange [0:0.8]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "nonstop50_bareblue_2layer_heat_slp1_spe25_pull20_per.csv" using 1:2 title "Raw Data" w l ls 10,\
    "peaks_blue2.csv" using 1:2 title "y=-0.00015x+0.48  r=-0.54" w l ls 19,\
    "troughs_blue2.csv" using 1:2 title "y=0.00034x+0.069  r=0.88" w l ls 20
   