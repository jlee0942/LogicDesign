module	tb_prj03;
//------------------
//instances
//------------------
reg	sel;
reg	in0;
reg	in1;

wire	out1;
wire	out2;
wire	out3;


mux2to1_cond 	 dut_1(	.sel  (sel),
			.in0  (in0),
			.in1  (in1),
			.out  (out1));	

mux2to1_if	 dut_2(	.sel  (sel),
			.in0  (in0),
			.in1  (in1),
			.out  (out2));	

mux2to1_case     dut_3(	.sel  (sel),
			.in0  (in0),
			.in1  (in1),
			.out  (out3));	

	


//------------------------------------------
//stimulus
//------------------------------------------
initial begin
	$display("using 'cond expr?':	out1");
	$display("using 'if':		out2");
	$display("Using 'case':		out3");
	$display("=============================================================");
	$display("  sel  in0  in1  out1  out2  out3  ");
	$display("=============================================================");
	#(50) {sel, in0, in1}=3'b000;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b001;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b010;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b011;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b100;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b101;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b110;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) {sel, in0, in1}=3'b111;	#(50)	$display("  %b\t%b\t%b\t%b\t%b\t%b\t",sel, in0, in1, out1, out2, out3);
	#(50) $finish	     ;
end

endmodule
