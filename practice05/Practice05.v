module nonblock(	q,
			d,
			clk);

output		q;
input		d;
input		clk;

reg n1,q;

always @(posedge clk)begin
	n1<=d;
	q<= n1;
end
endmodule

module block(    q,
		 d,
		 clk);

output		q;
input		d;
input		clk;

reg n1, q;

always @(posedge clk)begin
	n1=d;
	q=n1; 
end
endmodule
