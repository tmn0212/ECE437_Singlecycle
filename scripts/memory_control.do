onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/RAMCLK
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_test_case
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_request
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_test_case_num
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_check
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_error
add wave -noupdate -expand -group TB /memory_control_tb/PROG/tb_instr
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_iload
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_dload
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_ramstore
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_ramaddr
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_iwait
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_dwait
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_ramREN
add wave -noupdate -expand -group TB -group {Expected Outputs} /memory_control_tb/PROG/tb_expected_ramWEN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/iwait
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/iREN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/iaddr
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/iload
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/dwait
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/dREN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/dWEN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/daddr
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/dload
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/dstore
add wave -noupdate -expand -group ccif -divider {Ram Interface}
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramstate
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramREN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramWEN
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramaddr
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramload
add wave -noupdate -expand -group ccif /memory_control_tb/ccif/ramstore
add wave -noupdate -group cif0 /memory_control_tb/cif0/iwait
add wave -noupdate -group cif0 /memory_control_tb/cif0/dwait
add wave -noupdate -group cif0 /memory_control_tb/cif0/iREN
add wave -noupdate -group cif0 /memory_control_tb/cif0/dREN
add wave -noupdate -group cif0 /memory_control_tb/cif0/dWEN
add wave -noupdate -group cif0 /memory_control_tb/cif0/iload
add wave -noupdate -group cif0 /memory_control_tb/cif0/dload
add wave -noupdate -group cif0 /memory_control_tb/cif0/dstore
add wave -noupdate -group cif0 /memory_control_tb/cif0/iaddr
add wave -noupdate -group cif0 /memory_control_tb/cif0/daddr
add wave -noupdate -group RAM /memory_control_tb/ramif/ramREN
add wave -noupdate -group RAM /memory_control_tb/ramif/ramWEN
add wave -noupdate -group RAM /memory_control_tb/ramif/ramaddr
add wave -noupdate -group RAM /memory_control_tb/ramif/ramstore
add wave -noupdate -group RAM /memory_control_tb/ramif/ramload
add wave -noupdate -group RAM /memory_control_tb/ramif/ramstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2669520 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 171
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
WaveRestoreZoom {2814076 ps} {2973997 ps}
