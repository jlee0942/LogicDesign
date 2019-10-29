module instantiation(	sel,
			in0,
			in1,
			in2,
			in3,
			out);
output		out	;
input	[1:0]	sel	;
input		in0, in1, in2 , in3	;

wire	[1:0]	carry	;


mux2to1_cond    mux2to1_cond_u0( 	.sel (sel[0]),
					.in0 (in0),
					.in1 (in1),
					.out (carry[0]));
mux2to1_cond	mux2to1_cond_u1( 	.sel (sel[0]),
					.in0 (in2),
					.in1 (in3),
					.out (carry[1]));
mux2to1_cond	mux2to1_cond_u2( 	.sel (sel[1]),
					.in0 (carry[0]),
					.in1 (carry[1]),
					.out (out));
endmodule


module mux4to1_if (	out,
			sel,
 			in0, 
			in1, 
			in2,
			in3);

output out;
input sel, in0, in1, in2, in3;

reg out;

always @(sel, in0, in1, in2, in3) begin
	if(sel==2'b00)begin
		out=in0;
	end else if(sel==2'b01)begin
		out=in1;
	end else if(sel==2'b10)begin
		out=in2;
	end else begin
		out=in3;
	end
end
endmodule


module mux4to1_case (	out,
			sel,
 			in0, 
			in1, 
			in2,
			in3);
output	out			;
input	in0, in1, in2, in3	;
input	sel			;	

reg	out			;
always @(sel, in0, in1, in2, in3) begin
	case({sel, in0, in1, in2, in3})
	2'b00 : {out} = in0	;
	2'b01 : {out} = in2	;
	2'b10 : {out} = in1	;
	2'b11 : {out} = in3	;
	endcase

end
endmodule
