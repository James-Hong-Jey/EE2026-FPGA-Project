-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../MODS.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
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
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../MODS.srcs/sources_1/imports/Desktop/Mouse_Control.vhd" \
  "../../MODS.srcs/sources_1/imports/Desktop/Ps2Interface.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../MODS.srcs/sources_1/new/Top_Student.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

