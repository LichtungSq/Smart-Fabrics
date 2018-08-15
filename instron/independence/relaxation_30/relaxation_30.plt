#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "relaxation_30.eps"
set datafile separator ","

set key bottom right
set size 0.8,0.7

set xrange [0:60]
set xtics 15
set yrange [0:1.6]
set ytics 1

set xlabel "Extension(mm)"
set ylabel "R Change Ratio"

plot "bare_15_1_30_30_per.csv" using 1:2 title "30mm/min" w l ls 10, \
	"bare_15_1_30_90_per.csv" using 1:2 title "90mm/min" w l ls 11, \
	"bare_15_1_30_150_per.csv" using 1:2 title "150mm/min" w l ls 12