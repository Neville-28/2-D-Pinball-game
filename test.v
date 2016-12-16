
module test(clk, VGA_R, VGA_B, VGA_G, VGA_BLANK_N, VGA_SYNC_N , VGA_HS, VGA_VS, rst, Greset, VGA_CLK,Key3, Key2, Key1, Key0,);
output [7:0] VGA_R, VGA_B, VGA_G;    

output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, VGA_SYNC_N;

input clk, rst, Greset; 

wire CLK108; 

wire [30:0]X, Y;


wire wholeArea = ((X < 1280)&&(Y < 1024));
wire topScreen = ((Y <= 2)&&wholeArea);
wire bottomScreen = ((Y >= 1022)&&wholeArea);
wire rightScreen = (wholeArea && (X >= 1278));
wire leftSceen = (wholeArea && (X <= 2));
wire boarder = (wholeArea&&(leftSceen|rightScreen|topScreen|bottomScreen));

wire [7:0]countRef;
wire [31:0]countSample;


input  Key3, Key2, Key1, Key0;
wire button3, button2, button1, button0;

assign button3 = Key3;
assign button2 = Key2;
assign button1 = Key1;
assign button0 = Key0;


reg [31:0] finishX = 31'd0, finishY = 31'd1000;

//"block"
reg [31:0] blockX = 31'd0, blockY = 31'd150;

//"paddle"
reg [31:0] paddleX = 31'd590, paddleY = 31'd928;

//"block2"
reg[31:0] block2X=31'd0, block2Y =31'd150;
//"block3"
reg[31:0] block3X=31'd0, block3Y =31'd150;
reg[31:0] block4X=31'd0, block4Y =31'd150;

reg[31:0] block5X=31'd0, block5Y =31'd150;

reg[31:0] block6X=31'd0, block6Y =31'd150;

reg[31:0] block7X=31'd0, block7Y =31'd150;
reg[31:0] block8X=31'd0, block8Y =31'd150;




localparam Finish_L = 31'd0, Finish_R = Finish_L + 31'd0, Finish_T = 31'd0, Finish_B = Finish_T + 31'd0;
assign Finish =((X >= Finish_L + finishX)&&(X <= Finish_R + finishX)&&(Y >= Finish_T+ finishY)&&
(Y <= Finish_B+ finishY));

//////////////////////////////////////////////////////////////////

localparam block_L = 31'd0, block_R = block_L + 31'd75, block_T = 31'd0, block_B = block_T + 
31'd75;
localparam block2_L = 31'd0, block2_R = block2_L + 31'd80, block2_T = 31'd0, block2_B = block2_T + 
31'd70;
localparam block3_L = 31'd0, block3_R = block3_L + 31'd50, block3_T = 31'd0, block3_B = block3_T + 
31'd100;
localparam block4_L = 31'd0, block4_R = block4_L + 31'd30, block4_T = 31'd0, block4_B = block4_T + 
31'd30;
localparam block5_L = 31'd0, block5_R = block5_L + 31'd80, block5_T = 31'd0, block5_B = block5_T + 
31'd80;
localparam block6_L = 31'd0, block6_R = block6_L + 31'd50, block6_T = 31'd0, block6_B = block6_T + 
31'd70;
localparam block7_L = 31'd0, block7_R = block7_L + 31'd50, block7_T = 31'd0, block7_B = block7_T + 
31'd20;
localparam block8_L = 31'd0, block8_R = block8_L + 31'd10, block8_T = 31'd0, block8_B = block8_T + 
31'd60;
assign block =((X >= block_L + blockX)&&(X <= block_R + blockX)&&(Y >= block_T+ blockY)&&
(Y <= block_B + blockY));
assign block2 =((X >= block2_L + block2X)&&(X <= block2_R + block2X)&&(Y >= block2_T+ block2Y)&&
(Y <= block2_B + block2Y));
assign block3 =((X >= block3_L + block3X)&&(X <= block3_R + block3X)&&(Y >= block3_T+ block3Y)&&
(Y <= block3_B + block3Y));
assign block4 =((X >= block4_L + block4X)&&(X <= block4_R + block4X)&&(Y >= block4_T+ block4Y)&&
(Y <= block4_B + block4Y));
assign block5 =((X >= block5_L + block5X)&&(X <= block5_R + block5X)&&(Y >= block5_T+ block5Y)&&
(Y <= block5_B + block5Y));
assign block6 =((X >= block6_L + block6X)&&(X <= block6_R + block6X)&&(Y >= block6_T+ block6Y)&&
(Y <= block6_B + block6Y));
assign block7 =((X >= block7_L + block7X)&&(X <= block7_R + block7X)&&(Y >= block7_T+ block7Y)&&
(Y <= block7_B + block7Y));
assign block8 =((X >= block8_L + block8X)&&(X <= block8_R + block8X)&&(Y >= block8_T+ block8Y)&&
(Y <= block8_B + block8Y));
/////////////////////  paddle //////////////////////////////////////

localparam paddle_L = 31'd0, paddle_R = paddle_L + 31'd150, paddle_T = 31'd0, paddle_B = paddle_T + 31'd15;
assign paddle =((X >= paddle_L + paddleX)&&(X <= paddle_R + paddleX)&&(Y >= paddle_T+ paddleY)&&(Y <= paddle_B + paddleY));


countingRefresh(X, Y, clk, countRef );
clock108(rst, clk, CLK_108, locked);

wire hblank, vblank, clkLine, blank;

//Sync the display
H_SYNC(CLK_108, VGA_HS, hblank, clkLine, X);
V_SYNC(clkLine, VGA_VS, vblank, Y);


reg box1, box2, box3;
	
always@(*)
begin
	if(Finish) begin
		box1 = 1'b1;
		box2 = 1'b0;
		box3 = 1'b0;
		end
	else if(block) begin
		box1 = 1'b0;
		box2 = 1'b1;
		box3 = 1'b0;
		end
	else if(block2) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b1;
		end
	else if(block3) begin
		box1 = 1'b1;
		box2 = 1'b0;
		box3 = 1'b0;
		end
	else if(block4) begin
		box1 = 1'b1;
		box2 = 1'b0;
		box3 = 1'b0;
		end
	else if(block5) begin
		box1 = 1'b0;
		box2 = 1'b1;
		box3 = 1'b0;
		end
	else if(block6) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b1;
		end
	else if(block7) begin
		box1 = 1'b1;
		box2 = 1'b0;
		box3 = 1'b0;
		end
	else if(block8) begin
		box1 = 1'b0;
		box2 = 1'b1;
		box3 = 1'b0;
		end
	else if(paddle) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b1;
		end
	
		
	else begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		end
	end 
				
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg temp;

reg[31:0]counter;

reg [2:0]speed2 = 2'd1; 

always@(posedge clk or negedge Greset)

	if (Greset==1'b0) begin
		paddleX <= 32'd0;
		paddleY <= 32'd928;
		blockX <= 32'd0;
		blockY <= 32'd0;
		block2X <=32'd 200;
		block2Y<=32'd0;
		block3X <=32'd 400;
		block3Y<=32'd0;
		block4X <=32'd 550;
		block4Y<=32'd0;
		block5X <=32'd 700;
		block5Y<=32'd0;
		block6X <=32'd 900;
		block6Y<=32'd0;
		block7X <=32'd 1050;
		block7Y<=32'd0;
		block8X <=32'd 1100;
		block8Y<=32'd0;
		counter <=0;
		end
	else
	begin
		if(counter >= 32'd100010)
			counter <= 0;
		else
			begin 
			counter <= counter + 1;
			end
			
			if ((paddle)&&(block| Finish|block2|block3|block4|block5|block6|block7))
				begin
					paddleX <= 32'd590;
					paddleY <= 32'd924;
					
				end
			else
				begin
			if (paddleX <= 32'd5)
				paddleX <= 32'd6;
			else
				temp <= temp;
			if (paddleX >= 32'd1100)
				paddleX <= 32'd1099;
			else
				temp <= temp;
			if (paddleY >= 32'd948)
				paddleY <= 32'd947;
			else
				temp <= temp;
		
			if (button0 == 1'b0 && counter == 32'd100000)//
				paddleX <= paddleX + 32'd03;						
			else
				temp <= temp;
					
			if (button1 == 1'b0 && counter == 32'd100000)//
				paddleX <= paddleX - 32'd03;						
			else
				temp <= temp;
					
////////////////////////////////////////////////////////////////////////////			
			
			if(blockY >= 32'd1020) begin
				blockY <= blockY - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			
				blockY <= blockY +4;
				end
			else 
				begin
				temp <= temp;
				
				speed2 <= speed2 + 1'd1;
				end
			end
////////////////////////////////////////////////////////////////////////////////////////////////
			if(block2Y >= 32'd1020) begin
				block2Y <= block2Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block2Y <= block2Y + 2;
				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
//////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////
			if(block3Y >= 32'd1020) begin
				block3Y <= block3Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block3Y <= block3Y + 5;
				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
/////////////////////////////////////////////////////////////////////////////////////
if(block4Y >= 32'd1020) begin
				block4Y <= block4Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block4Y <= block4Y + 3;

				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
if(block5Y >= 32'd1020) begin
				block5Y <= block5Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block5Y <= block5Y + 9;
				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
/////////////////////////////////////////////////////////////////////////////////////
if(block6Y >= 32'd1020) begin
				block6Y <= block6Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block6Y <= block6Y + 4;

				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
/////////////////////////////////////////////////////////////////////////////////////
if(block7Y >= 32'd1020) begin
				block7Y <= block7Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block7Y <= block7Y + 5;

				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
/////////////////////////////////////////////////////////////////////////////////////
if(block8Y >= 32'd1020) begin
				block8Y <= block8Y - 1020; 
				end
			else 
				begin
					temp <= temp;
				end	
			if(counter == 32'd20000 && speed2 == 3'd7)
				begin
			//	block2X <= block2X + 1;
			
				block8Y <= block8Y + 10;
				end
			else 
				begin
				temp <= temp;
				speed2 <= speed2 + 1'd1;
				end
	end	



color(clk, VGA_R, VGA_B, VGA_G, box1, box2, box3);

assign VGA_CLK = CLK_108;
assign VGA_BLANK_N = VGA_VS&VGA_HS;
assign VGA_SYNC_N = 1'b0;
endmodule


module countingRefresh(X, Y, clk, count);
input [31:0]X, Y;
input clk;
output [7:0]count;
reg[7:0]count;
always@(posedge clk)
begin
	if(X==0 &&Y==0)
		count<=count+1;
	else if(count==7'd20)
		count<=0;
	else
		count<=count;
end

endmodule

module color(clk, red, blue, green, box1, box2, box3);

input clk, box1, box2, box3;

output [7:0] red, blue, green;
reg[7:0] red, green, blue;

always@(*)
begin
	if(box1) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box2) begin
		red = 8'd255;
		blue = 8'd100;
		green = 8'd000;
		end
	else if(box3) begin
		red = 8'd000;
		blue = 8'd000;
		green = 8'd255;
		end
	else begin
		red = 8'd0;
		blue = 8'd0;
		green = 8'd0;
		end
	end
	
endmodule

module H_SYNC(clk, hout, bout, newLine, Xcount);

input clk;
output hout, bout, newLine;
output [31:0] Xcount;
	
reg [31:0] count = 32'd0;
reg hsync, blank, new1;

always @(posedge clk) 
begin
	if (count <  1688)
		count <= Xcount + 1;
	else 
      count <= 0;
   end 

always @(*) 
begin
	if (count == 0)
		new1 = 1;
	else
		new1 = 0;
   end 

always @(*) 
begin
	if (count > 1279) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1328)
		hsync = 1;
   else if (count > 1327 && count < 1440)
		hsync = 0;
   else    
		hsync = 1;
	end

assign Xcount=count;
assign hout = hsync;
assign bout = blank;
assign newLine = new1;

endmodule


module V_SYNC(clk, vout, bout, Ycount);

input clk;
output vout, bout;
output [31:0]Ycount; 
	  
reg [31:0] count = 32'd0;
reg vsync, blank;

always @(posedge clk) 
begin
	if (count <  1066)
		count <= Ycount + 1;
   else 
            count <= 0;
   end 

always @(*) 
begin
	if (count < 1024) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1025)
		vsync = 1;
	else if (count > 1024 && count < 1028)
		vsync = 0;
	else    
		vsync = 1;
	end

assign Ycount=count;
assign vout = vsync;
assign bout = blank;

endmodule

//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module clock108 (areset, inclk0, c0, locked);

input     areset;
input     inclk0;
output    c0;
output    locked;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_off
`endif

tri0      areset;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_on
`endif

wire [0:0] sub_wire2 = 1'h0;
wire [4:0] sub_wire3;
wire  sub_wire5;
wire  sub_wire0 = inclk0;
wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
wire [0:0] sub_wire4 = sub_wire3[0:0];
wire  c0 = sub_wire4;
wire  locked = sub_wire5;
	 
altpll  altpll_component (
            .areset (areset),
            .inclk (sub_wire1),
            .clk (sub_wire3),
            .locked (sub_wire5),
            .activeclock (),
            .clkbad (),
            .clkena ({6{1'b1}}),
            .clkloss (),
            .clkswitch (1'b0),
            .configupdate (1'b0),
            .enable0 (),
            .enable1 (),
            .extclk (),
            .extclkena ({4{1'b1}}),
            .fbin (1'b1),
            .fbmimicbidir (),
            .fbout (),
            .fref (),
            .icdrclk (),
            .pfdena (1'b1),
            .phasecounterselect ({4{1'b1}}),
            .phasedone (),
            .phasestep (1'b1),
            .phaseupdown (1'b1),
            .pllena (1'b1),
            .scanaclr (1'b0),
            .scanclk (1'b0),
            .scanclkena (1'b1),
            .scandata (1'b0),
            .scandataout (),
            .scandone (),
            .scanread (1'b0),
            .scanwrite (1'b0),
            .sclkout0 (),
            .sclkout1 (),
            .vcooverrange (),
            .vcounderrange ());
defparam
    altpll_component.bandwidth_type = "AUTO",
    altpll_component.clk0_divide_by = 25,
    altpll_component.clk0_duty_cycle = 50,
    altpll_component.clk0_multiply_by = 54,
    altpll_component.clk0_phase_shift = "0",
    altpll_component.compensate_clock = "CLK0",
    altpll_component.inclk0_input_frequency = 20000,
    altpll_component.intended_device_family = "Cyclone IV E",
    altpll_component.lpm_hint = "CBX_MODULE_PREFIX=clock108",
    altpll_component.lpm_type = "altpll",
    altpll_component.operation_mode = "NORMAL",
    altpll_component.pll_type = "AUTO",
    altpll_component.port_activeclock = "PORT_UNUSED",
    altpll_component.port_areset = "PORT_USED",
    altpll_component.port_clkbad0 = "PORT_UNUSED",
    altpll_component.port_clkbad1 = "PORT_UNUSED",
    altpll_component.port_clkloss = "PORT_UNUSED",
    altpll_component.port_clkswitch = "PORT_UNUSED",
    altpll_component.port_configupdate = "PORT_UNUSED",
    altpll_component.port_fbin = "PORT_UNUSED",
    altpll_component.port_inclk0 = "PORT_USED",
    altpll_component.port_inclk1 = "PORT_UNUSED",
    altpll_component.port_locked = "PORT_USED",
    altpll_component.port_pfdena = "PORT_UNUSED",
    altpll_component.port_phasecounterselect = "PORT_UNUSED",
    altpll_component.port_phasedone = "PORT_UNUSED",
    altpll_component.port_phasestep = "PORT_UNUSED",
    altpll_component.port_phaseupdown = "PORT_UNUSED",
    altpll_component.port_pllena = "PORT_UNUSED",
    altpll_component.port_scanaclr = "PORT_UNUSED",
    altpll_component.port_scanclk = "PORT_UNUSED",
    altpll_component.port_scanclkena = "PORT_UNUSED",
    altpll_component.port_scandata = "PORT_UNUSED",
    altpll_component.port_scandataout = "PORT_UNUSED",
    altpll_component.port_scandone = "PORT_UNUSED",
    altpll_component.port_scanread = "PORT_UNUSED",
    altpll_component.port_scanwrite = "PORT_UNUSED",
    altpll_component.port_clk0 = "PORT_USED",
    altpll_component.port_clk1 = "PORT_UNUSED",
    altpll_component.port_clk2 = "PORT_UNUSED",
    altpll_component.port_clk3 = "PORT_UNUSED",
    altpll_component.port_clk4 = "PORT_UNUSED",
    altpll_component.port_clk5 = "PORT_UNUSED",
    altpll_component.port_clkena0 = "PORT_UNUSED",
    altpll_component.port_clkena1 = "PORT_UNUSED",
    altpll_component.port_clkena2 = "PORT_UNUSED",
    altpll_component.port_clkena3 = "PORT_UNUSED",
    altpll_component.port_clkena4 = "PORT_UNUSED",
    altpll_component.port_clkena5 = "PORT_UNUSED",
    altpll_component.port_extclk0 = "PORT_UNUSED",
    altpll_component.port_extclk1 = "PORT_UNUSED",
    altpll_component.port_extclk2 = "PORT_UNUSED",
    altpll_component.port_extclk3 = "PORT_UNUSED",
    altpll_component.self_reset_on_loss_lock = "OFF",
    altpll_component.width_clock = 5;

endmodule