// -*- an interface for DUT communication
interface clk_intf(output  bit clk);
	
   // -*- mandatory code
   // all interface instances will register itself with ~ifname~
   // can moved into a macro
   import cdns_vif_registry::*;
   const string ifname = "protocol";
   function automatic void register();
      virtual 	clk_intf vif;
      vif = clk_intf;
      cdns_vif_registry::cdns_vif_db#(virtual clk_intf)::register_vif(vif,$sformatf("%m.%s",ifname));
   endfunction
    
   initial register();
   // -*- mandatory code ends
endinterface 
