module	tb_prj03_2;
//------------------
//instances
//------------------
reg	in0, in1, in2 , in3	;
reg[1:0] sel;

wire	out1, out2, out3;



instantiation 	 dut_1(	.out  (out1),
			.sel  (sel),
			.in0  (in0),
			.in1  (in1),
			.in2  (in2),
			.in3  (in3));	

mux4to1_if	 dut_2(	.out  (out2),
			.sel  (sel),
			.in0  (in0),
			.in1  (in1),
			.in2  (in2),
			.in3  (in3));	

mux4to1_case     dut_3(	.out  (out3),
			.sel  (sel),
 			.in0  (in0), 
			.in1  (in1), 
			.in2  (in2),
			.in3  (in3));
	


//------------------------------------------
//stimulus
//------------------------------------------
initial begin
	$display("using 'ins.':		out1");
	$display("using 'if':		out2");
	$display("Using 'case':		out3");
	$display("=============================================================");
	$display("  sel  in0  in1   in2   in3  out1  out2  out3  ");
	$display("=============================================================");
	#(50) {sel, in0, in1, in2, in3}=5'b00001;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) {sel, in0, in1, in2, in3}=5'b00010;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) {sel, in0, in1, in2, in3}=5'b00011;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) {sel, in0, in1, in2, in3}=5'b00100;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) {sel, in0, in1, in2, in3}=5'b00101;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) {sel, in0, in1, in2, in3}=5'b00110;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",sel, in0, in1, in2, in3, out1, out2, out3);
	#(50) $finish	     ;
end

endmodule
