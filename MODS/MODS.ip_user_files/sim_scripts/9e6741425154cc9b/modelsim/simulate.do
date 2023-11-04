onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.9e6741425154cc9b xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {9e6741425154cc9b.udo}

run -all

quit -force
