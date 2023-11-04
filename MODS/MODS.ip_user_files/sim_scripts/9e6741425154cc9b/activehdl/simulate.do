onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+9e6741425154cc9b -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.9e6741425154cc9b xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {9e6741425154cc9b.udo}

run -all

endsim

quit -force
