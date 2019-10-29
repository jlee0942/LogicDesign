module tb_bnb;

wire 	q1,q2;
reg 	d;
reg	clk;

initial	clk=1'b0	;
always	#(50) clk=~clk	;


block	DUT01(	.q	(q1),
		.d	(d) ,
		.clk	(clk));

nonblock DUT02(	.q	(q2),
		.d	(d) ,
		.clk	(clk));

initial begin
#(0) 	d=1'b0;
#(50)	d=1'b1;
#(50)	d=1'b1;
#(50)	d=1'b0;
#(50)	d=1'b1;
#(50)	d=1'b0;
#(50) 	d=1'b1;
#(50)	d=1'b0;
#(50)	d=1'b1;
#(50)	d=1'b0;
#(50) 	d=1'b1;
#(50)	d=1'b0;
#(50)	d=1'b0;
#(50)	$finish;
end
endmodule
