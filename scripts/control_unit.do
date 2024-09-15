onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/PROG/tb_test_case
add wave -noupdate /control_unit_tb/PROG/tb_test_case_num
add wave -noupdate /control_unit_tb/PROG/tb_check
add wave -noupdate /control_unit_tb/PROG/tb_error
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/opcode
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/funct7
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/funct3
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/alu_zero
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/ALUSrc
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/MemtoReg
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/RegWrite
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/MemWrite
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/MemRead
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/PCSrc
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/Jump
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/halt
add wave -noupdate -expand -group DUT /control_unit_tb/CU/cuif/aluop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {74 ns}
