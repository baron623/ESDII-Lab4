# ##############################################################################
# Dr. Kaputa
# Vivado Scripting Utopia
# Copyright (c) 2017 Craft Drones.
# SPDX-License-Identifier: BSD-3-Clause [https://spdx.org/licenses/]
# ##############################################################################

set projectName blink

# 0: setup project, 1: setup and compile project
set compileProject 0

# 0: plain,  1: black,  2: blue
set target 1

# 0: leave messy, 1: blow away everything but sources and .bit file
set cleanup 0

# ##############################################################################
# setup project
# ##############################################################################
if {$target == 0 } {
  # plain
  create_project $projectName project -part xc7z010clg400-1 -force
  set_property board_part krtkl.com:snickerdoodle:part0:1.0 [current_project]
} elseif {$target == 1 } {
  # black
  create_project $projectName project -part xc7z020clg400-3 -force
  set_property board_part krtkl.com:snickerdoodle_black:part0:1.0 [current_project]
} else {
  # blue
  create_project $projectName project -part xc7z020clg400-1 -force
  set_property board_part krtkl.com:snickerdoodle_prime_le:part0:1.0 [current_project]
}

# setup various project properties
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
set_property STEPS.OPT_DESIGN.IS_ENABLED false [get_runs impl_1]

# setup repositories
set_property ip_repo_paths ip [current_project]
update_ip_catalog

# add files to project
add_files -norecurse src/design_1.bd
make_wrapper -files [get_files src/design_1.bd] -top
import_files -norecurse src/hdl/design_1_wrapper.vhd
add_files -fileset constrs_1 -norecurse src/constraints.xdc

# either just setup or setup and compile
if { $compileProject == 0 } {
  # just close the project
  close_project
} else {
  # compile and create boot.bin

  # start synthesis
  launch_runs synth_1 -jobs 8
  wait_on_run synth_1
  
  # netlist is complete
  launch_runs impl_1 -to_step write_bitstream -jobs 8
  wait_on_run impl_1
  
  file mkdir project/$projectName.sdk
  write_hwdef -force  -file pynq/design_1.hdf
  
  close_project
  
  # copy over .bit file to system.bit
  file copy -force project/$projectName.runs/impl_1/design_1_wrapper.bit system.bit
  file copy -force project/$projectName.runs/impl_1/design_1_wrapper.bin system.bin
  #file copy -force project/$projectName.runs/impl_1/design_1_wrapper.bit pynq/design_1.bit
  #file copy -force src/hw_handoff/design_1.hwh pynq/design_1.hwh
  #file copy -force src/hw_handoff/design_1_bd.tcl pynq/design_1.tcl
  
  # create system.bit.bin file for linux flashing
  exec bootgen -image bootimage.bif -arch zynq -process_bitstream bin
  
  if {$cleanup == 1 } {
    # clean out bloatware from src folder
    file delete src/design_1.bxml
    file delete src/design_1_ooc.xdc
    file delete -force src/ip
    file delete -force src/hdl
    file delete -force src/hw_handoff
    file delete -force src/ipshared
    file delete -force project
    file delete -force .xil
  }
}