vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/blk_mem_gen_v8_4_1

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap blk_mem_gen_v8_4_1 questa_lib/msim/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib -64 -sv \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1 -64 \
"../../MODS.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 \
"../../MODS.srcs/sources_1/imports/Desktop/blk_mem_gen_inter/sim/blk_mem_gen_inter.v" \
"../../MODS.srcs/sources_1/imports/Desktop/blk_mem_gen_const/sim/blk_mem_gen_const.v" \
"../../MODS.srcs/sources_1/imports/Desktop/blk_mem_gen_img/sim/blk_mem_gen_img.v" \
"../../MODS.srcs/sources_1/imports/Desktop/blk_mem_gen_0_1/sim/blk_mem_gen_0.v" \
"../../MODS.srcs/sources_1/imports/Desktop/CanvasTransfer.v" \
"../../MODS.srcs/sources_1/imports/Desktop/Oled_Display.v" \
"../../MODS.srcs/sources_1/imports/Desktop/clk_divider.v" \
"../../MODS.srcs/sources_1/imports/Desktop/module_pack.v" \
"../../MODS.srcs/sources_1/imports/Desktop/neural_net.v" \
"../../MODS.srcs/sources_1/imports/Desktop/paint.v" \
"../../MODS.srcs/sources_1/imports/Desktop/ss_display.v" \

vcom -work xil_defaultlib -64 -93 \
"../../MODS.srcs/sources_1/imports/Desktop/Mouse_Control.vhd" \
"../../MODS.srcs/sources_1/imports/Desktop/Ps2Interface.vhd" \

vlog -work xil_defaultlib -64 \
"../../MODS.srcs/sources_1/new/Top_Student.v" \

vlog -work xil_defaultlib \
"glbl.v"

