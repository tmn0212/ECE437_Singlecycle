onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /request_block_tb/CLK
add wave -noupdate /request_block_tb/nRST
add wave -noupdate /request_block_tb/PROG/tb_test_case
add wave -noupdate /request_block_tb/PROG/tb_test_case_num
add wave -noupdate /request_block_tb/PROG/tb_check
add wave -noupdate /request_block_tb/PROG/tb_error
add wave -noupdate -expand -group DUT /request_block_tb/rbif/dhit
add wave -noupdate -expand -group DUT /request_block_tb/rbif/ihit
add wave -noupdate -expand -group DUT /request_block_tb/rbif/MemWrite
add wave -noupdate -expand -group DUT /request_block_tb/rbif/MemRead
add wave -noupdate -expand -group DUT /request_block_tb/rbif/halt
add wave -noupdate -expand -group DUT /request_block_tb/rbif/dmemWEN
add wave -noupdate -expand -group DUT /request_block_tb/rbif/dmemREN
add wave -noupdate -expand -group DUT /request_block_tb/rbif/imemREN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {1 us}
