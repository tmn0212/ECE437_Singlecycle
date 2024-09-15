onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /alu_tb/PROG/tb_test_case
add wave -noupdate -expand -group TB /alu_tb/PROG/tb_test_case_num
add wave -noupdate -expand -group TB -group {Expected Outputs} /alu_tb/PROG/tb_expected_ALUout
add wave -noupdate -expand -group TB -group {Expected Outputs} /alu_tb/PROG/tb_expected_negative
add wave -noupdate -expand -group TB -group {Expected Outputs} /alu_tb/PROG/tb_expected_overflow
add wave -noupdate -expand -group TB -group {Expected Outputs} /alu_tb/PROG/tb_expected_zero
add wave -noupdate -expand -group TB /alu_tb/PROG/tb_check
add wave -noupdate -expand -group TB /alu_tb/PROG/tb_error
add wave -noupdate -expand -group DUT -radix decimal /alu_tb/aif/A
add wave -noupdate -expand -group DUT -radix decimal /alu_tb/aif/B
add wave -noupdate -expand -group DUT /alu_tb/aif/aluop
add wave -noupdate -expand -group DUT -radix decimal /alu_tb/aif/ALUout
add wave -noupdate -expand -group DUT /alu_tb/aif/negative
add wave -noupdate -expand -group DUT /alu_tb/aif/overflow
add wave -noupdate -expand -group DUT /alu_tb/aif/zero
add wave -noupdate -radix decimal /alu_tb/PROG/tb_expected_ALUout
add wave -noupdate /alu_tb/PROG/tb_expected_negative
add wave -noupdate /alu_tb/PROG/tb_expected_overflow
add wave -noupdate /alu_tb/PROG/tb_expected_zero
add wave -noupdate -radix hexadecimal /alu_tb/PROG/tb_array_A
add wave -noupdate /alu_tb/PROG/tb_array_B
add wave -noupdate /alu_tb/PROG/tb_array_C
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
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
WaveRestoreZoom {0 ns} {11 ns}
