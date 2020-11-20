//1ll1lll1111ll1ll1l11ll111ll1ll1l11l11ll1lll1111ll1ll1l11ll111ll1ll1l11l1
//
//     
//     Your count sequence is: 708652647541295789 Note that the sequence wraps around at both ends.
//     
//
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
 
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module CounterSkipReverse 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
//
//   Sequential module to produce oState changes on each Clk posedge using the above count sequence.
//
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module CounterSkipReverse 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
module CounterSkipReverse(iClk, iRst, iSkip, iRev, oState);
   input iClk, iRst, iSkip, iRev;
   output [4:0] oState;
   //declare internal wires and reg types here:
	reg [4:0] oState;
	reg [4:0] oState_reg = 5'b0;
	
	always @(posedge iClk or posedge iRst)
		begin
			if (iRst)
				begin
					oState<=5'b0;
					oState_reg<=oState_reg;
				end
			else
				begin
					case({iSkip,iRev})
						2'b11:
							begin
								oState<=oState_reg;
								if (oState_reg==5'b10001)
									begin
										oState_reg<=5'b1;
									end
								else if (oState_reg==5'b00000)
									begin
										oState_reg<=5'b10;
									end 
								else if (oState_reg==5'b10000)
									begin
										oState_reg<=5'b0;
									end	
								else
									begin
										oState_reg<=oState_reg+5'b10;
									end
							end
						2'b10:
							begin
								oState<=oState_reg;
								if (oState_reg==5'b10000)
									begin
										oState_reg<=5'b1;
									end
								else if (oState_reg==5'b10001)
									begin
										oState_reg<=5'b10;
									end
								else if (oState_reg==5'b1111)
									begin
										oState_reg<=5'b0;
									end	
								else
									begin
										oState_reg<=oState_reg+5'b11;
									end
							end
						2'b01:
							begin
								oState<=oState_reg;
								if (oState_reg==5'b0)
									begin
										oState_reg<=5'b10001;
									end
								else
									begin
										oState_reg<=oState_reg-5'b1;
									end
							end
						2'b00:
							begin
								oState<=oState_reg;
								if (oState_reg==5'b10001)
									begin
										oState_reg<=5'b0;
									end
								else
									begin
										oState_reg<=oState_reg+5'b1;
									end
							end
					endcase
				end
		end
 
 
endmodule //1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 CounterSkipReverse 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 
 
 
 
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module StateToCountSequence 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
//
//    Combinational module to map iState to a 4 bit BCD output
//
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module StateToCountSequence 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
module StateToCountSequence(iState, oV);
	//declare the input and output 
	input [4:0] iState;
	output [3:0] oV;
 
  
	//declare any internal wire and reg types here.
	reg [3:0] mem_array [17:0];
	wire [3:0] oV;
	
	initial 
	begin : INIT	
		mem_array[5'd0] = 4'd3;
		mem_array[5'd1] = 4'd0;
		mem_array[5'd2] = 4'd7;
		mem_array[5'd3] = 4'd6;
		mem_array[5'd4] = 4'd6;
		mem_array[5'd5] = 4'd2;
		mem_array[5'd6] = 4'd1;
		mem_array[5'd7] = 4'd4;
		mem_array[5'd8] = 4'd4;
		mem_array[5'd9] = 4'd5;
		mem_array[5'd10] = 4'd4;
		mem_array[5'd11] = 4'd1;
		mem_array[5'd12] = 4'd2;
		mem_array[5'd13] = 4'd9;
		mem_array[5'd14] = 4'd6;
		mem_array[5'd15] = 4'd7;
		mem_array[5'd16] = 4'd7;
		mem_array[5'd17] = 4'd3;
		
	end 
	
	assign oV=mem_array[iState];
  
  
	//Have you checked for inferred latches in this module?
endmodule //1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 StateToCountSequence 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 
 
 
 
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module CompleteCounter 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
//
//   Instantiates previous modules for complete design
//
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module CompleteCounter 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
module CompleteCounter(iClk, iRst, iSkip, iRev, oV, oState);
	input iClk, iRst, iSkip, iRev;
	output [3:0] oV;
	//declare oState next line
	output wire [4:0] oState;
 
 
	CounterSkipReverse cntr(.iClk(iClk), .iRst(iRst), .iSkip(iSkip), .iRev(iRev), .oState(oState));
	StateToCountSequence statemap(.iState(oState), .oV(oV));
endmodule //1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 CompleteCounter 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
 
 
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module AssignmentTestBench 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
//
//   This testbench needs to check all possible transitions in your counter design.
//   It should be written using an independent approach to the synthesisable code above
//
//1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 Module AssignmentTestBench 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1
 
module AssignmentTestBench;
 
   //declare internal signals and instantiate module CompleteCounter.
 
   //generate test sequences for all state transitions
   reg iClk;
	reg iRst;
	reg iSkip;
	reg iRev;
	wire [3:0] oV;
	wire [4:0] oState;
	
	CompleteCounter tbCompleteCounter(.iClk(iClk), .iRst(iRst), .iSkip(iSkip), .iRev(iRev), .oV(oV), .oState(oState));
	
	initial begin 
		iClk=0;
		forever #5 iClk=~iClk;
	end
	initial begin
		iSkip=1'b0;
		iRev=1'b0;
		#215;
		iSkip=1'b1;
		#10;
		iSkip=1'b0;
		#50;
		iRev=1'b1;
		#10;
		iRev=1'b0;
		#50;
		iRev=1'b1;
		iSkip=1'b1;
		#10;
		iRev=1'b0;
		iSkip=1'b0;
	end
	
endmodule //1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 AssignmentTestBench 1ll1lll1111ll1ll1l11ll111ll1ll1l11l1 
