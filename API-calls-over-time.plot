# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of API calls in libcurl over time"
# where's the legend
set key top left

# Identify the axes
set xlabel "Time"
set ylabel "Number of API calls"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/API-calls-over-time.csv' using 1:2 with lines linestyle 1 title "Number of API calls"
