onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Top_Student -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Top_Student xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Top_Student.udo}

run -all

endsim

quit -force
