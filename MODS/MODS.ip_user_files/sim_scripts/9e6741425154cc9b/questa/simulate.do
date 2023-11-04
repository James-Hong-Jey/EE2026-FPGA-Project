onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib 9e6741425154cc9b_opt

do {wave.do}

view wave
view structure
view signals

do {9e6741425154cc9b.udo}

run -all

quit -force
