onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/nRST
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/opcode
add wave -noupdate -expand -group DP -expand -group unimportant /system_tb/DUT/CPU/DP/r_i
add wave -noupdate -expand -group DP -expand -group unimportant /system_tb/DUT/CPU/DP/i_i
add wave -noupdate -expand -group DP -expand -group unimportant /system_tb/DUT/CPU/DP/s_i
add wave -noupdate -expand -group DP -expand -group unimportant /system_tb/DUT/CPU/DP/u_i
add wave -noupdate -expand -group DP -expand -group unimportant /system_tb/DUT/CPU/DP/next_PC
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/PC
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -expand -group DP /system_tb/DUT/CPU/halt
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/Reg
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/aif/A
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/aif/B
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/aif/ALUout
add wave -noupdate -expand -group alu /system_tb/DUT/CPU/DP/aif/aluop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {343563 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 143
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
WaveRestoreZoom {54228 ps} {1770397 ps}
