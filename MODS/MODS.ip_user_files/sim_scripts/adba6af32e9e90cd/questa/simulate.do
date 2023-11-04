onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib adba6af32e9e90cd_opt

do {wave.do}

view wave
view structure
view signals

do {adba6af32e9e90cd.udo}

run -all

quit -force
