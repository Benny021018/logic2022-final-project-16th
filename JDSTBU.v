module JDSTBU(
	output [7:0] R, G, B,
	output reg [3:0] COMM,
	output reg [0:6] Score,
	//
	output reg [2:0] Health,
	//
	input CLK,
	input JD,ST,BU);
	
	parameter logic [7:0] EJD [7:0] = '{8'b01111110,
													8'b00111100,
													8'b10011001,
													8'b11000011,
													8'b11000011,
													8'b10011001,
													8'b00111100,
													8'b01111110};
													
	parameter logic [7:0] EST [7:0] = '{8'b00000000,
													8'b01111110,
													8'b01111110,
													8'b01111110,
													8'b01111110,
													8'b01111110,
													8'b01111110,
													8'b00000000};
													
	parameter logic [7:0] EBU [7:0] = '{8'b00000000,
													8'b00000000,
													8'b00000000,
													8'b00000000,
													8'b00000000,
													8'b00000000,
													8'b00000000,
													8'b00000000};
													
	parameter logic [7:0] END [7:0] = '{8'b01100110,
													8'b01100110,
													8'b01100110,
													8'b01100110,
													8'b01100110,
													8'b01100110,
													8'b01100110,
													8'b00000000};
	
	parameter logic [7:0] WAIT [7:0] = '{8'b11111111,
													8'b11111111,
													8'b11111111,
													8'b11100111,
													8'b11100111,
													8'b11111111,
													8'b11111111, 
													8'b11111111};

	//
   parameter H0 = 3'b000,H1 = 3'b100,H2 = 3'b110,H3 = 3'b111;
	parameter S0 = 7'b0000001,S1 = 7'b1001111,S2 = 7'b0010010,S3 = 7'b0000110;
   //
													
	CLK_one F1(CLK, CLK_1); CLK_two F2(CLK, CLK_2);
	int score;int health;bit [2:0] cnt;int guess; int cttime;
	
	initial
		begin
			cnt = 0;
			cttime = 0;
			guess = 0;
			score = 0;
			health = 3;
			G = 8'b11111111;
			B = 8'b11111111;
			R = 8'b11111111;
			COMM = 4'b1000;
			Score = S0;
			Health = H3;
		end
	
	always @(posedge CLK_1) 
		  begin
				if(cttime > 0)
					begin
						if(guess == 0)
							begin
								if(cnt>=7)
									cnt = 0;
								else
									cnt = cnt + 1;
									COMM = {1'b1,cnt};
									R = 	EJD[cnt];
							end
						else if(guess == 1)
							begin
								if(cnt>=7)
									cnt = 0;
								else
									cnt = cnt + 1;
									COMM = {1'b1,cnt};
									R = 	EST[cnt];
							end
						else
							begin
								if(cnt>=7)
									cnt = 0;
								else
									cnt = cnt + 1;
									COMM = {1'b1,cnt};
									R = 	EBU[cnt];
							end
					end
				else if(health <= 0 || score >= 3)
					begin
						if(cnt>=7)
							cnt = 0;
						else
							cnt = cnt + 1;
							COMM = {1'b1,cnt};
							R = 	END[cnt];
					end
				else
					begin
						if(cnt>=7)
							cnt = 0;
						else
							cnt = cnt + 1;
							COMM = {1'b1,cnt};
							R = 	WAIT[cnt];
					end
			end
			
	always @(posedge CLK_2) 
		  begin
				if(guess == 2)
					guess = 0;
				else
					guess = guess + 1;
					
				if(cttime > 0)
					cttime = cttime - 1;
					
				case({JD,ST,BU})
					3'b001:cttime = 1;
					3'b010:cttime = 1;
					3'b100:cttime = 1;
				endcase
				
				if(guess == 0)
					case({JD,ST,BU})
						3'b001:health = health - 1;
						3'b010:score = score + 1;
					endcase
				if(guess == 1)
					case({JD,ST,BU})
						3'b100:health = health - 1;
						3'b001:score = score + 1;
					endcase
				if(guess == 2)
					case({JD,ST,BU})
						3'b010:health = health - 1;
						3'b100:score = score + 1;
					endcase
					end
   always @(posedge CLK_2)
	   case(score)
		   0:Score <= S0;
			1:Score <= S1;
			2:Score <= S2;
			3:Score <= S3;
	   endcase
	
	always@(posedge CLK_2)
	   case(health)
		   0:Health <= H0;
			1:Health <= H1;
			2:Health <= H2;
			3:Health <= H3;
		endcase
endmodule
	
	
	module CLK_one(input CLK, output reg CLK_1); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 25000) 
				begin 
					Count <= 25'b0; 
					CLK_1 <= ~CLK_1; 
				end 
			else Count <= Count + 1'b1; 
		end 
endmodule


module CLK_two(input CLK, output reg CLK_2); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count >= 25000000) 
				begin 
					Count <= 25'b0; 
					CLK_2<= ~CLK_2; 
				end 
			else Count <= Count + 1'b1; 
		end 
endmodule

					