#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "length.eps"
set datafile separator ","

set key bottom left
set size 0.8,0.7

set xrange [0:40]
set xtics 15
set yrange [0:1.3]
set ytics 1

set xlabel "Extension(mm)"
set ylabel "R Change Ratio"

plot "12_2_40_bf_spe60_per.csv" using 1:2 title "12cm * 2cm" w l ls 10, \
	"15_2_40_bf_spe60_per.csv" using 1:2 title "15cm * 2cm" w l ls 11, \
	"18_2_40_bf_spe60_per.csv" using 1:2 title "18cm * 2cm" w l ls 12