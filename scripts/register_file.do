onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /register_file_tb/PROG/tb_test_case
add wave -noupdate -expand -group TB -radix unsigned /register_file_tb/PROG/tb_test_case_num
add wave -noupdate -expand -group TB /register_file_tb/PROG/tb_check
add wave -noupdate -expand -group TB -color Magenta -itemcolor Violet /register_file_tb/PROG/tb_error
add wave -noupdate -expand -group DUT /register_file_tb/CLK
add wave -noupdate -expand -group DUT /register_file_tb/nRST
add wave -noupdate -expand -group DUT /register_file_tb/rfif/WEN
add wave -noupdate -expand -group DUT -radix unsigned /register_file_tb/rfif/wsel
add wave -noupdate -expand -group DUT /register_file_tb/rfif/wdat
add wave -noupdate -expand -group DUT -radix unsigned /register_file_tb/rfif/rsel1
add wave -noupdate -expand -group DUT -radix unsigned /register_file_tb/rfif/rsel2
add wave -noupdate -expand -group DUT -divider out
add wave -noupdate -expand -group DUT /register_file_tb/rfif/rdat1
add wave -noupdate -expand -group DUT /register_file_tb/rfif/rdat2
add wave -noupdate /register_file_tb/v1
add wave -noupdate /register_file_tb/v2
add wave -noupdate /register_file_tb/v3
add wave -noupdate /register_file_tb/PROG/tb_expected_rdat1
add wave -noupdate /register_file_tb/PROG/tb_expected_rdat2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {499981 ps} 0}
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
WaveRestoreZoom {471300 ps} {617300 ps}
