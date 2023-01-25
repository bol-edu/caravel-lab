module tb_seq_gcd;
        reg clk;
        reg rst_n;
        reg [31:0] a;
        reg [31:0] b;
        wire [31:0] gcd;
        wire done;
        reg load;
        event done_event;
        wire [3:0] tb_count_out;
		
	reg [31:0] aa [0:4];
	reg [31:0] bb [0:4];
	reg [31:0] eexp_gcd [0:4];
	reg [7:0] i;
		
        seq_gcd DUT(
                .clk(clk),
                .rst_n(rst_n),
                .load_i(load),
                .a_i(a),
                .b_i(b),
                .gcd_o(gcd),
                .done_o(done)
        );
        reg [31:0] exp_gcd;
        function [31:0] golden_GCD;
                input reg [31:0] A;
                input reg [31:0] B;
                reg [31:0] R;
                if (B != 0) begin
                        R = A % B;
                        begin : sv2v_autoblock_1
                                reg [31:0] sv2v_void;
                                sv2v_void = golden_GCD(B, R);
                        end
                end
                else
                        golden_GCD = A;
        endfunction
        initial begin
                $dumpfile("dump.vcd");
                $dumpvars(1, DUT);
        end
        initial begin		        
                clk = 1'b0;
                rst_n = 1'b1;
		load = 1'b0;
                a = 0;
                b = 0;                
                exp_gcd = 0;
				
		aa[0] = 10312050;
		bb[0] = 29460792;
		eexp_gcd[0] = 138;				
		aa[1] = 1993627629;
		bb[1] = 1177417612;
		eexp_gcd[1] = 7;
		aa[2] = 2097015289;
		bb[2] = 3812041926;
		eexp_gcd[2] = 1;
		aa[3] = 1924134885;
		bb[3] = 3151131255;
		eexp_gcd[3] = 135;
		aa[4] = 992211318;
		bb[4] = 512609597;
		eexp_gcd[4] = 1;
		i = 0;
				
                @(negedge clk)
                        ;
                @(negedge clk)
                        ;
                rst_n = 1'b0;
                @(negedge clk)
                        ;
                rst_n = 1'b1;
                @(negedge clk)
                        ;				
                repeat (10) begin
                        @(negedge clk)
                                ;
                        //a = $random;
                        //b = $random;
                        //exp_gcd = golden_GCD(a, b);                        
			a = aa[i];
			b = bb[i];
			exp_gcd = eexp_gcd[i];
                        load = 1;
                        @(negedge clk)
                                ;
                        load = 0;
                        @(done_event)
                                ;
                        if (gcd !== exp_gcd)
                                $error("\t\t Result is wrong GCD(%d,%d) -->: Expected = %d; Actual Result = %d", a, b, exp_gcd, gcd);
                        else
                                $display("\t\t Result is correct:  GCD(%d,%d) -->: Expected = %d; Actual Result = %d", a, b, exp_gcd, gcd);
			i = i + 1;
			if (i == 5) $stop;
                end				
                //$stop;
        end
        always begin
                #(2.5)
                   ;
                clk = ~clk;
        end
        always @(posedge clk)
                if (done) -> done_event;
endmodule
