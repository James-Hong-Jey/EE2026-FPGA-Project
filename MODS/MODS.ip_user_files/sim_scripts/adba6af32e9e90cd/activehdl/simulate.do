onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+adba6af32e9e90cd -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.adba6af32e9e90cd xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {adba6af32e9e90cd.udo}

run -all

endsim

quit -force
