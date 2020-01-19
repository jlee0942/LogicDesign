module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0:	o_seg = 7'b111_1110; 
 		4'd1:	o_seg = 7'b011_0000; 
 		4'd2:	o_seg = 7'b110_1101; 
 		4'd3:	o_seg = 7'b111_1001; 
 		4'd4:	o_seg = 7'b011_0011; 
 		4'd5:	o_seg = 7'b101_1011; 
 		4'd6:	o_seg = 7'b101_1111; 
 		4'd7:	o_seg = 7'b111_0000; 
 		4'd8:	o_seg = 7'b111_1111; 
 		4'd9:	o_seg = 7'b111_0011; 
		default:o_seg = 7'b000_0000; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
			o_left,
			o_right,
			i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
			o_seg,
			o_seg_dp,
			o_seg_enb,
			i_six_digit_seg,
			i_six_dp,
			clk,
			rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(
			.o_gen_clk	( gen_clk	),
			.i_nco_num	( 32'd5000	),
			.clk		( clk		),
			.rst_n		( rst_n		));


reg	[3:0]	cnt_common_node	;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

reg	[5:0]	o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_enb = 6'b111110;
		4'd1:	o_seg_enb = 6'b111101;
		4'd2:	o_seg_enb = 6'b111011;
		4'd3:	o_seg_enb = 6'b110111;
		4'd4:	o_seg_enb = 6'b101111;
		4'd5:	o_seg_enb = 6'b011111;
		default:o_seg_enb = 6'b111111;
	endcase
end

reg		o_seg_dp		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_dp = i_six_dp[0];
		4'd1:	o_seg_dp = i_six_dp[1];
		4'd2:	o_seg_dp = i_six_dp[2];
		4'd3:	o_seg_dp = i_six_dp[3];
		4'd4:	o_seg_dp = i_six_dp[4];
		4'd5:	o_seg_dp = i_six_dp[5];
		default:o_seg_dp = 1'b0;
	endcase
end

reg	[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg = i_six_digit_seg[6:0];
		4'd1:	o_seg = i_six_digit_seg[13:7];
		4'd2:	o_seg = i_six_digit_seg[20:14];
		4'd3:	o_seg = i_six_digit_seg[27:21];
		4'd4:	o_seg = i_six_digit_seg[34:28];
		4'd5:	o_seg = i_six_digit_seg[41:35];
		default:o_seg = 7'b111_1110; // 0 display
	endcase
end

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		o_max_hit		;

input	[5:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

module 	hms_re_cnt (
		o_hms_re_cnt,
		o_min_re_hit,
		clk,
		rst_n);

output	[5:0]	o_hms_re_cnt		;
output		o_min_re_hit		;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_re_cnt		;
reg		o_min_re_hit		;


always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_re_cnt <= 6'd0;
		o_min_re_hit <= 1'b0;
		
	end else begin
		if(o_hms_re_cnt <= 1'b0) begin
			o_hms_re_cnt <=6'd59;
			o_min_re_hit <= 1'b1;
		
		end else begin
			o_hms_re_cnt <= o_hms_re_cnt - 1'b1;
			o_min_re_hit <= 1'b0;
			
		end
	end
end

endmodule
			

module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Blink
//	--------------------------------------------------

module mux(	out,
			in0,
			in1,
			sel);

output	out			;
input	in0			;
input	in1			;
input	sel			;	

reg	out			;

always @(in0, in1, sel) begin
	if(sel==1'b1) begin
	   out = in1	;
	end else begin
	   out = in0	;
	end
end
endmodule


module detBlink(		o_blink,
			i_en_mblink,
			i_en_pblink,
			i_sign,	
			clk,
			rst_n);

output[6:0]	o_blink	;
input			i_en_mblink	;
input			i_en_pblink	;	

input	[6:0]	i_sign		;
input			clk		;
input			rst_n		;
	
reg	 	detClk	;
always @(i_en_mblink, i_en_pblink) begin
	case({i_en_mblink, i_en_pblink})
	 	2'b11 : {detClk} = 1'b1;
		default : {detClk} =1'b0;
	endcase
end


wire		clk_2hz		;
nco		u_Bnco(	
			.o_gen_clk	(clk_2hz		),
			.i_nco_num	(32'd25000000	),
			.clk		(clk		),
			.rst_n		(rst_n		));

wire	 detBlink		;
mux		u_mux1(	.out		(detBlink	),
						.in0		(1'b0	),
						.in1		(clk_2hz	),
						.sel		(detClk	));	

reg	[6:0]	o_blink		;
always @(*) begin
	if(detBlink==1'b0) begin
		o_blink <= i_sign		;
	end else begin
		o_blink	<= 7'd0		;
	end
end
endmodule


//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
			o_mode,
			o_position,
			o_state,
			o_alarm_en,
			o_sec_clk,
			o_min_clk,
			o_hour_clk,
			o_alarm_sec_clk,
			o_alarm_min_clk,
			o_alarm_hour_clk,
			o_stop_sec_clk,	
			o_stop_min_clk,	
			o_stop_hour_clk	,	
			o_timer_sec_clk,
			o_timer_min_clk,
			o_timer_hour_clk,
			o_en_mblink,
			o_en_psblink,	
			o_en_pmblink,	
			o_en_phblink,
			i_max_hit_sec,
			i_max_hit_min,
			i_max_hit_hour,
			i_min_hit_sec,
			i_min_hit_min,
			i_min_hit_hour,
			i_sw0,
			i_sw1,
			i_sw2,
			i_sw3,
			i_sw4,
			i_sw5,
			clk,
			stop_rst_n,
			rst_n);

output	[5:0]	o_mode			;
output	[5:0]	o_position		;
output	       o_state			;
output		o_alarm_en		;
output		stop_rst_n		;

output		o_sec_clk		;
output		o_min_clk		;
output		o_hour_clk		;

output 		o_stop_sec_clk		;
output		o_stop_min_clk		;
output		o_stop_hour_clk		;


output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hour_clk	;

output		o_timer_sec_clk		;
output		o_timer_min_clk		;
output		o_timer_hour_clk		;

output		o_en_mblink		;
output		o_en_psblink		;	
output		o_en_pmblink		;	
output		o_en_phblink		;


input		i_max_hit_sec		;
input		i_max_hit_min		;
input		i_max_hit_hour		;
input		i_min_hit_sec		;
input		i_min_hit_min		;
input		i_min_hit_hour		;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;
input		i_sw4			;
input		i_sw5			;

input		clk			;
input		rst_n			;

parameter	MODE_CLOCK	= 6'b0000_00	;
parameter	MODE_SETUP	= 6'b0000_01	;
parameter	MODE_ALARM	= 6'b0000_10	;
parameter	MODE_STOPWATCH= 6'b0000_11	;
parameter	MODE_TIMER_SETUP = 6'b0001_00	;
parameter	MODE_TIMER_COUNTDOWN = 6'b0001_01;

parameter	POS_SEC		= 6'b0000_00	;
parameter	POS_MIN		= 6'b0000_01	;
parameter	POS_HOUR	= 6'b0000_10	;

parameter	STOP		= 1'b0	;
parameter 	COUNT_UP	= 1'b1	;

wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));

wire		sw4		;
debounce	u4_debounce(
		.o_sw		( sw4	),
		.i_sw		( i_sw4		),
		.clk		( clk_100hz	));

wire		sw5		;
debounce	u5_debounce(
		.o_sw		( sw5	),
		.i_sw		( i_sw5	),
		.clk		( clk_100hz	));



reg	[5:0]	o_mode			;
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
	end else begin
		if(o_mode >= MODE_TIMER_COUNTDOWN) begin
			o_mode <= MODE_CLOCK;
		end else begin
			o_mode <= o_mode + 1'b1;
		end
	end
end


reg	[5:0]	o_position	;
reg		o_state;
always @(posedge sw1 or negedge rst_n) begin

if(rst_n==1'b0) begin

	o_position <= POS_SEC;
	
	end else begin 
	
	if( o_position >= POS_HOUR) begin
		o_position <= POS_SEC;
		
	end else begin
		o_position <= o_position + 1'b1;
	end

	end

end


reg	stop_rst_n;

always @(posedge sw5 or negedge rst_n) begin
	
	if(rst_n ==1'b0) begin
	stop_rst_n <= 1'b1;

	end else begin 
	stop_rst_n <= ~stop_rst_n;
end 

end 

always @(posedge sw4 or negedge rst_n) begin

	if(rst_n==1'b0) begin 
	o_state <= STOP;

	end else begin //rst_n==1'b1

	o_state <= ~o_state;

	end
end 

reg		o_alarm_en		;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd5000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_sec_clk			;
reg		o_min_clk		;
reg		o_hour_clk		;
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg		o_alarm_hour_clk		;
reg		o_stop_sec_clk		;
reg		o_stop_min_clk		;
reg		o_stop_hour_clk		;
reg		o_timer_hour_clk		;
reg		o_timer_min_clk		;
reg		o_timer_sec_clk		;
reg		o_en_mblink		;
reg		o_en_psblink		;	
reg		o_en_pmblink		;	
reg		o_en_phblink		;

always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
			o_timer_hour_clk= 1'b0;
			o_en_mblink	=1'b0;
			o_en_psblink=1'b0	;	
			o_en_pmblink=1'b0	;	
			o_en_phblink=1'b0	;
		end
	
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = ~sw2 ;
					o_min_clk = 1'b0;
					o_hour_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink =1'b1;
					o_en_psblink=1'b1	;	
					o_en_pmblink=1'b0	;	
					o_en_phblink=1'b0	;		
				end
				POS_MIN : begin
					o_sec_clk = 1'b0;
					o_min_clk = ~sw2 ;
					o_hour_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b1;
					o_en_psblink=1'b0	;	
					o_en_pmblink=1'b1	;	
					o_en_phblink=1'b0	;
				end
				POS_HOUR : begin
					o_sec_clk = 1'b0;
					o_min_clk = 1'b0;
					o_hour_clk = ~sw2 ;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b1;
					o_en_psblink=1'b0	;	
					o_en_pmblink=1'b0	;	
					o_en_phblink=1'b1	;
				end
			endcase
		end
			
		MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = ~sw2;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b1;
					o_en_psblink=1'b1	;	
					o_en_pmblink=1'b0	;	
					o_en_phblink=1'b0	;
				end
				POS_MIN : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = ~sw2;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;		
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b1;
					o_en_psblink=1'b0	;	
					o_en_pmblink=1'b1	;	
					o_en_phblink=1'b0	;


				end
				POS_HOUR : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = ~sw2;
					o_stop_sec_clk	= 1'b0;
					o_stop_min_clk	= 1'b0;
					o_stop_hour_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b1;
					o_en_psblink=1'b0	;	
					o_en_pmblink=1'b0	;	
					o_en_phblink=1'b1	;
				end
			endcase
			
		end
		
		MODE_TIMER_SETUP : begin  //set_timer 

			case(o_position)

			POS_SEC : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_hour_clk = 1'b0;
			o_timer_min_clk =  1'b0;
			o_timer_sec_clk = ~sw2;
			o_en_mblink	=1'b1;
			o_en_psblink=1'b1	;	
			o_en_pmblink=1'b0	;	
			o_en_phblink=1'b0	;
			end
			
			POS_MIN : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_hour_clk = 1'b0;
			o_timer_min_clk =  ~sw2;
			o_timer_sec_clk =  1'b0;
			o_en_mblink	=1'b1;
			o_en_psblink=1'b0		;	
			o_en_pmblink=1'b1	;	
			o_en_phblink=1'b0		;
			end

			POS_HOUR : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_hour_clk = ~sw2;
			o_timer_min_clk =  1'b0;
			o_timer_sec_clk =  1'b0;
			o_en_mblink	=1'b1;
			o_en_psblink=1'b0	;	
			o_en_pmblink=1'b0	;	
			o_en_phblink=1'b1	;
			end
			endcase
		end 
			
			MODE_TIMER_COUNTDOWN : begin
			
				o_sec_clk = clk_1hz;
				o_min_clk = i_max_hit_sec;	
				o_hour_clk = i_max_hit_min;
				o_alarm_sec_clk = 1'b0;
				o_alarm_min_clk = 1'b0;
				o_alarm_hour_clk = 1'b0;
				o_stop_sec_clk	= 1'b0;
				o_stop_min_clk	= 1'b0;
				o_stop_hour_clk = 1'b0;
				o_timer_hour_clk = 1'b0;
				o_timer_min_clk =  i_min_hit_sec;
				o_timer_sec_clk =  clk_1hz;
				o_en_mblink	=1'b0;
				o_en_psblink=1'b0		;	
				o_en_pmblink=1'b0	;	
				o_en_phblink=1'b0		;
			end
		
			MODE_STOPWATCH : begin
				case(o_state)
					
				COUNT_UP : begin //count_up 
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk= i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_stop_sec_clk	=  clk_1hz;
					o_stop_min_clk	=  i_max_hit_sec;
					o_stop_hour_clk =  i_max_hit_min;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
					o_timer_hour_clk= 1'b0;
					o_en_mblink	=1'b0;
					o_en_psblink=1'b0	;	
					o_en_pmblink=1'b0	;	
					o_en_phblink=1'b0	;
				
				end
			
			STOP : begin //stop
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
			o_timer_hour_clk= 1'b0;
			o_en_mblink	=1'b1;
			o_en_psblink=1'b1	;	
			o_en_pmblink=1'b1	;	
			o_en_phblink=1'b1;
			end
			endcase
	end
	default : begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hour_clk = 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_stop_sec_clk	= 1'b0;
			o_stop_min_clk	= 1'b0;
			o_stop_hour_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
			o_timer_hour_clk= 1'b0;
			o_en_mblink	=1'b0;
			o_en_psblink=1'b0	;	
			o_en_pmblink=1'b0	;	
			o_en_phblink=1'b0;
			end
endcase

end
endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hourminsec(	
		o_sec,
		o_min,
		o_hour,
		o_max_hit_sec,
		o_max_hit_min,
		o_max_hit_hour,
		o_min_hit_sec,
		o_min_hit_min,
		o_min_hit_hour,
		o_alarm,
		i_mode,
		i_position,
		i_state,
		i_sec_clk,
		i_min_clk,
		i_hour_clk,
		i_stop_sec_clk,
		i_stop_min_clk,
		i_stop_hour_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hour_clk,
		i_timer_sec_clk,
		i_timer_min_clk,
		i_timer_hour_clk,
		i_alarm_en,
		stop_rst_n,
		clk,
		rst_n);

output	[5:0]	o_sec		;
output	[5:0]	o_min		;
output	[5:0]	o_hour		;

output		o_max_hit_sec	;
output		o_max_hit_min	;
output		o_max_hit_hour	;
output		o_min_hit_sec	;
output		o_min_hit_min	;
output		o_min_hit_hour	;

output		o_alarm		;

input	[5:0]	i_mode		;
input	[5:0]	i_position	;
input		i_state;
input		i_sec_clk	;
input		i_min_clk	;
input		i_hour_clk	;
input 		i_timer_sec_clk	;
input 		i_timer_min_clk ;
input 		i_timer_hour_clk;

input		i_stop_sec_clk	;
input		i_stop_min_clk	;
input		i_stop_hour_clk ;
input		stop_rst_n	;
input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hour_clk;
input		i_alarm_en	;

input		clk		;
input		rst_n		;


parameter	MODE_CLOCK	= 6'b0000_00	;
parameter	MODE_SETUP	= 6'b0000_01	;
parameter	MODE_ALARM	= 6'b0000_10	;
parameter	MODE_STOPWATCH	= 6'b0000_11	;
parameter	MODE_TIMER_SETUP= 6'b0001_00	;
parameter	MODE_TIMER_COUNTDOWN = 6'b0001_01;

parameter	POS_SEC		= 6'b0000_00	;
parameter	POS_MIN		= 6'b0000_01	;
parameter	POS_HOUR	= 6'b0000_10	;

parameter	COUNT_UP	= 1'b1	;
parameter	STOP		= 1'b0  ;


//	MODE_CLOCK
wire	[5:0]	sec		;
wire		max_hit_sec	;
hms_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec			),
		.o_max_hit	( max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	min		;
wire		max_hit_min	;
hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min			),
		.o_max_hit	( max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	hour		;
wire		max_hit_hour	;
hms_cnt		u_hms_cnt_hour(
		.o_hms_cnt	( hour			),
		.o_max_hit	( max_hit_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_hour_clk		),
		.rst_n		( rst_n			));


wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),	
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hour	;
hms_cnt		u_hms_cnt_alarm_hour(
		.o_hms_cnt	( alarm_hour		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd23		),
		.clk		( i_alarm_hour_clk	),
		.rst_n		( rst_n			));

wire 	[5:0]	stop_sec	;
wire 	[5:0]	stop_min	;
wire 	[5:0]	stop_hour	;
wire	stop_rst_n	;

hms_cnt		u_hms_cnt_stop_sec (
		.o_hms_cnt	( stop_sec		),
		.o_max_hit	( max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_stop_sec_clk	),
		.rst_n		( stop_rst_n		));



hms_cnt		u_hms_cnt_stop_min (
		.o_hms_cnt	( stop_min		),
		.o_max_hit	( max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_stop_min_clk	),
		.rst_n		( stop_rst_n		));



hms_cnt		u_hms_cnt_stop_hour (
		.o_hms_cnt	( stop_hour		),
		.o_max_hit	( max_hit_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_stop_hour_clk	),
		.rst_n		( stop_rst_n		));


wire  [5:0]	timer_sec	;
wire	[5:0]	timer_min	;
wire	[5:0]	timer_hour	;


hms_re_cnt 	u_hms_re_cnt_sec (
		.o_hms_re_cnt	( timer_sec),
		.o_min_re_hit	( min_hit_sec		),
		
		.clk		( i_timer_sec_clk	),
		.rst_n		( rst_n			));

hms_re_cnt 	u_hms_re_cnt_min (
		.o_hms_re_cnt	( timer_min),
		.o_min_re_hit	( min_hit_min		),
		
		.clk		( i_timer_min_clk	),
		.rst_n		( rst_n			));

hms_re_cnt 	u_hms_re_cnt_hour (
		.o_hms_re_cnt	( timer_hour),
		.o_min_re_hit	( min_hit_hour		),
	
		.clk		( i_timer_hour_clk	),
		.rst_n		( rst_n			));


reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
reg	[5:0]	o_hour		;



always @ (*) begin
	case(i_mode)
		MODE_CLOCK: 	begin
			o_sec	= sec;
			o_min	= min;
			o_hour= hour;
		end

		MODE_SETUP:	begin

			o_sec	= sec;
			o_min	= min;
			o_hour	= hour; 
		end

		
		MODE_ALARM:	begin

			o_sec	= alarm_sec;
			o_min	= alarm_min;
			o_hour	= alarm_hour;
		end
		
		MODE_STOPWATCH : begin

			o_sec	= stop_sec;
			o_min	= stop_min;
			o_hour  = stop_hour;
	
		end 

		MODE_TIMER_SETUP: begin
			o_sec	= timer_sec;
			o_min	= timer_min;
			o_hour  = timer_hour;

		end 

		MODE_TIMER_COUNTDOWN: begin
			o_sec	= timer_sec;
			o_min	= timer_min;
			o_hour  = timer_hour;
	
		end
		 	
	endcase
end



reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm <= 1'b0;
	end else begin
		if( (sec == alarm_sec) && (min == alarm_min) && (hour == alarm_hour)) begin
			o_alarm <= 1'b1 & i_alarm_en;
		end else begin
			o_alarm <= o_alarm & i_alarm_en;
		end
	end
end

endmodule

module	buzz(
		o_buzz,
		i_buzz_en,
		clk,
		rst_n);

output		o_buzz		;

input		i_buzz_en	;
input		clk		;
input		rst_n		;

parameter   C = 95565.75/6 ;
parameter   D = 85132.47/6 ;
parameter   E = 75842.61/6 ;
parameter   F = 71586.06/6 ;
parameter   G = 63777.14/6 ;
parameter   Q = 1000/4;

wire      clk_bit      ;
nco   u_nco_bit(   
      .o_gen_clk   ( clk_bit   ),
      .i_nco_num   ( 12500000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

reg   [5:0]   cnt      ;
always @ (posedge clk_bit or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      cnt <= 6'd0;
   end else begin
      if(cnt >= 6'd56) begin
         cnt <= 6'd0;
      end else begin
         cnt <= cnt + 1'd1;
      end
   end
end



reg   [31:0]   nco_num      ;
always @ (*) begin
   case(cnt)
      6'd00: nco_num = E   ;
      6'd01: nco_num = Q   ;
      6'd02: nco_num = E   ;
      6'd03: nco_num = Q   ;
      6'd04: nco_num = E   ;
      6'd05: nco_num = E   ;
      6'd06: nco_num = Q   ;
      6'd07: nco_num = E   ;
      6'd08: nco_num = Q   ;
      6'd09: nco_num = E   ;
      6'd10: nco_num = Q   ;
      6'd11: nco_num = E   ;
      6'd12: nco_num = E   ;
      6'd13: nco_num = Q   ;
      6'd14: nco_num = E   ;
      6'd15: nco_num = Q   ;
      6'd16: nco_num = G   ;
      6'd17: nco_num = Q   ;
      6'd18: nco_num = C   ;
      6'd19: nco_num = Q   ;
      6'd20: nco_num = D   ;
      6'd21: nco_num = Q   ;
      6'd22: nco_num = E   ;
      6'd23: nco_num = E   ;
      6'd24: nco_num = E   ;
      6'd25: nco_num = E   ;
      6'd26: nco_num = Q   ;
      6'd27: nco_num = Q   ;
      6'd28: nco_num = F   ;
      6'd29: nco_num = Q   ;
      6'd30: nco_num = F   ;
      6'd31: nco_num = Q   ;
      6'd32: nco_num = F   ;
      6'd33: nco_num = Q   ;
      6'd34: nco_num = F   ;
      6'd35: nco_num = Q   ;
      6'd36: nco_num = F   ;
      6'd37: nco_num = Q   ;
      6'd38: nco_num = E   ;
      6'd39: nco_num = Q   ;
      6'd40: nco_num = E   ;
      6'd41: nco_num = Q   ;
      6'd42: nco_num = E   ;
      6'd43: nco_num = Q   ;
      6'd44: nco_num = E   ;
      6'd45: nco_num = Q   ;
      6'd46: nco_num = D   ;
      6'd47: nco_num = Q   ;
      6'd48: nco_num = D   ;
      6'd49: nco_num = Q   ;
      6'd50: nco_num = E   ;
      6'd51: nco_num = Q   ;
      6'd52: nco_num = D   ;
      6'd53: nco_num = D   ;
      6'd54: nco_num = Q   ;
      6'd55: nco_num = G   ;
      6'd56: nco_num = G   ;
   endcase
end

wire      buzz      ;
nco   u_nco_buzz(   
      .o_gen_clk   ( buzz      ),
      .i_nco_num   ( nco_num   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

assign      o_buzz = buzz & i_buzz_en;

endmodule 

module	top(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw4,
		i_sw5,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		i_sw4		;
input		i_sw5		;
input		clk		;
input		rst_n		;

wire	[5:0]	mode		;
wire	[5:0]	position	;
wire		   state	;
wire		alarm_en	;
wire		alarm_sec_clk	;
wire		alarm_min_clk	;
wire		alarm_hour_clk	;
wire		stop_sec_clk	;
wire		stop_min_clk	;
wire		stop_hour_clk	;
wire		timer_sec_clk	;
wire		timer_min_clk	;
wire		timer_hour_clk	;
wire		en_mblink	;
wire		en_psblink	;
wire		en_pmblink	;
wire		en_phblink	;

wire		min_clk	;
wire		sec_clk	;
wire		hour_clk	;
wire		max_hit_sec	;
wire		max_hit_min	;
wire		max_hit_hour	;
wire		min_hit_hour	;
wire		min_hit_min	;
wire		min_hit_sec	;
wire		stop_rst_n	;

controller	u_controller(
				.o_mode			(mode			),
				.o_position		(position		),
				.o_state		(state),
				.o_alarm_en		(alarm_en		),
				.o_sec_clk		(sec_clk		),
				.o_min_clk		(min_clk		),
				.o_hour_clk		(hour_clk		),
				.o_alarm_sec_clk	(alarm_sec_clk		),
				.o_alarm_min_clk	(alarm_min_clk		),
				.o_alarm_hour_clk	(alarm_hour_clk		),
				.o_stop_sec_clk		(stop_sec_clk		),
				.o_stop_min_clk		(stop_min_clk		),
				.o_stop_hour_clk	(stop_hour_clk		),
				.o_timer_sec_clk	(timer_sec_clk		),
				.o_timer_min_clk	(timer_min_clk		),
				.o_timer_hour_clk	(timer_hour_clk		),
				.o_en_mblink		(en_mblink	),
				.o_en_psblink		(en_psblink	),
				.o_en_pmblink		(en_pmblink	),
				.o_en_phblink		(en_phblink	),
				.stop_rst_n		(stop_rst_n		),
				.i_max_hit_sec		(max_hit_sec		),
				.i_max_hit_min		(max_hit_min		),
				.i_max_hit_hour		(max_hit_hour		),
				.i_min_hit_sec		(min_hit_sec		),
				.i_min_hit_min		(min_hit_min		),
				.i_min_hit_hour		(min_hit_hour		),
				.i_sw0			(i_sw0			),
				.i_sw1			(i_sw1			),
				.i_sw2			(i_sw2			),
				.i_sw4			(i_sw4			),
				.i_sw3			(i_sw3			),
				.i_sw5			(i_sw5			),
				.clk			(clk			),
				.rst_n			(rst_n			));

wire	[5:0]	sec	;
wire	[5:0]	min	;
wire	[5:0]	hour	;
wire		alarm	;
hourminsec		u_hourminsec(	
				.o_sec			(sec		),
				.o_min			(min		),
				.o_hour			(hour		),
				.o_max_hit_sec		(max_hit_sec	),
				.o_max_hit_min		(max_hit_min	),
				.o_max_hit_hour		(max_hit_hour	),
				.o_min_hit_sec		(min_hit_sec	),
				.o_min_hit_min		(min_hit_min	),
				.o_min_hit_hour		(min_hit_hour	),
				.o_alarm		(alarm		),
				.i_mode			(mode		),
				.i_position		(position	),
				.i_state			(state),
				.i_sec_clk		(sec_clk	),
				.i_min_clk		(min_clk	),
				.i_hour_clk		(hour_clk	),
				.i_timer_sec_clk	(timer_sec_clk	),
				.i_timer_min_clk	(timer_min_clk	),
				.i_timer_hour_clk	(timer_hour_clk	),
				.i_stop_sec_clk		(stop_sec_clk	),
				.i_stop_min_clk		(stop_min_clk	),
				.i_stop_hour_clk	(stop_hour_clk	),
				.stop_rst_n		(stop_rst_n	),
				.i_alarm_sec_clk	(alarm_sec_clk	),
				.i_alarm_min_clk	(alarm_min_clk	),
				.i_alarm_hour_clk	(alarm_hour_clk	),
				.i_alarm_en		(alarm_en	),
				.clk			(clk		),
				.rst_n			(rst_n		));

wire	[3:0]	sec10	;
wire	[3:0]	sec0	;
double_fig_sep		u0_double_fig_sep(
						.o_left		(sec10	),
						.o_right	(sec0	),
						.i_double_fig	(sec	));
wire	[3:0]	min10	;
wire	[3:0]	min0	;
double_fig_sep		u1_double_fig_sep(
						.o_left		(min10	),
						.o_right	(min0	),
						.i_double_fig	(min	));
wire	[3:0]	hour10	;
wire	[3:0]	hour0	;
double_fig_sep		u2_double_fig_sep(
						.o_left		(hour10	),
						.o_right	(hour0	),
						.i_double_fig	(hour	));
wire	[6:0] 	seg_sec10	;
fnd_dec		u0_fnd_dec(
				.o_seg	(seg_sec10	),
				.i_num	(sec10		));
wire	[6:0] 	seg_sec0	;
fnd_dec		u1_fnd_dec(
				.o_seg	(seg_sec0	),
				.i_num	(sec0		));
wire	[6:0] 	seg_min10	;
fnd_dec		u2_fnd_dec(
				.o_seg	(seg_min10	),
				.i_num	(min10		));
wire	[6:0] 	seg_min0	;
fnd_dec		u3_fnd_dec(
				.o_seg	(seg_min0	),
				.i_num	(min0		));
wire	[6:0] 	seg_hour10	;
fnd_dec		u4_fnd_dec(
				.o_seg	(seg_hour10	),
				.i_num	(hour10		));
wire	[6:0] 	seg_hour0	;
fnd_dec		u5_fnd_dec(
				.o_seg	(seg_hour0	),
				.i_num	(hour0		));

wire	[6:0]	seg_bsec0		;
detBlink		u_detBlinksec0(		.o_blink		(seg_bsec0		),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_psblink	),
					.i_sign		(seg_sec0		),	
					.clk		(clk		),
					.rst_n		(rst_n		));
wire	[6:0]	seg_bsec10		;
detBlink		u_detBlinksec10(		.o_blink		(seg_bsec10		),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_psblink),
					.i_sign		(seg_sec10	),	
					.clk		(clk		),
					.rst_n		(rst_n		));
wire	[6:0]	seg_bmin0		;
detBlink		u_detBlinkmin0(		.o_blink		(seg_bmin0		),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_pmblink),
					.i_sign		(seg_min0	),	
					.clk		(clk		),
					.rst_n		(rst_n		));

wire	[6:0]	seg_bmin10		;
detBlink		u_detBlinkmin10(		.o_blink		(seg_bmin10	),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_pmblink),
					.i_sign		(seg_min10	),	
					.clk		(clk		),
					.rst_n		(rst_n		));

wire	[6:0]	seg_bhour0		;
detBlink		u_detBlinkhr0(		.o_blink		(seg_bhour0		),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_phblink),
					.i_sign		(seg_hour0	),	
					.clk		(clk		),
					.rst_n		(rst_n		));

wire	[6:0]	seg_bhour10		;
detBlink		u_detBlinkhr10(		.o_blink		(seg_bhour10		),
					.i_en_mblink	(en_mblink	),
					.i_en_pblink	(en_phblink),
					.i_sign		(seg_hour10	),	
					.clk		(clk		),
					.rst_n		(rst_n		));

wire	[41:0]	six_digit_seg;
assign		six_digit_seg = { seg_bhour10, seg_bhour0, seg_bmin10, seg_bmin0, seg_bsec10, seg_bsec0 };
led_disp	u_led_disp(
				.o_seg			(o_seg		),
				.o_seg_dp		(o_seg_dp	),
				.o_seg_enb		(o_seg_enb	),
				.i_six_digit_seg	(six_digit_seg	),
				.i_six_dp		(mode		),
				.clk			(clk		),
				.rst_n			(rst_n		));
wire	o_alarm	;
buzz	u_buzz(
		.o_buzz		(o_alarm	),
		.i_buzz_en	(alarm		),
		.clk		(clk		),
		.rst_n		(rst_n		));

endmodule

