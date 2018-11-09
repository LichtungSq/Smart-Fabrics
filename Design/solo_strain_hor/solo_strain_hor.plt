#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "solo_strain_hor.eps"
set datafile separator ","

set key at graph 1.05,0.98
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:36]
set xtics 10
set yrange [-0.05:0.18]
set ytics 0.05

set y2range [-50:180]
set y2tics 60

set xlabel "Time (sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0
set y2label "Angle (degree)" offset -1,0

plot "test_day_hor_strain_mid_per.csv" using 1:2 title "Middle" w l ls 10, \
"test_day_hor_strain_low_per.csv" using 1:2 title "Higher" w l ls 11, \
"test_day_hor_strain_up_per.csv" using 1:2 title "Lower" w l ls 12, \
"output_hor_strain_mid_1.csv" using 1:2 axis x1y2 title "Kinect" w l ls 19, \


   