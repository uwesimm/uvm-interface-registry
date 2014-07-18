
// -*- binds an instance of the clk_intf into sub_block
// bind signals by name
bind sub_block clk_intf clk_intf_i(.*);
// by instance
//bind top_block.sub_block_i1 clk_intf clk_intf_i(.*);
//bind top_block.sub_block_i2 clk_intf clk_intf_i(.*);

// -*- just TB handling
module tb;
    import testbench_pkg::*;
    import uvm_pkg::*;
    
    initial begin
       testbench tb1 = new("tb1",null);
       testbench tb2 = new("tb2",null);
	    
       // tell the TB component that its hdl paths are inside sub_block_i
       uvm_config_db#(string)::set(uvm_root::get(),"","HDLContext","top_block");
       uvm_config_db#(string)::set(tb1,"","HDLContext","sub_block_i1");
       uvm_config_db#(string)::set(tb2,"","HDLContext","sub_block_i2");

       run_test();
    end
endmodule
