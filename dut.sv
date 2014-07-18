// -*- -----------------------------
// -*- this is the DUT
module top_block();
	wire r;
	sub_block sub_block_i1(r);
	sub_block sub_block_i2(r);
endmodule 

module sub_block(
        output clk);
endmodule