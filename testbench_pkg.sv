`include "uvm_macros.svh"
package testbench_pkg;

   import uvm_pkg::*;
   import cdns_vif_registry::*;

class testbench extends uvm_env;
   // -*- this is a container private virtual interface
   virtual clk_intf vif;
   
   // Good ole uvm automation
   `uvm_component_utils(testbench)

   // Constructor
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build();
      super.build(); 
      cdns_vif_registry::cdns_vif_db#(virtual clk_intf)::retrieve_vif(vif,this,"clk_intf_i.protocol");
   endfunction
   
   task run_phase(uvm_phase phase);     
      phase.raise_objection(this);
      #3;
      vif.clk <= 0;
      repeat(100) begin
         #10 vif.clk <= !vif.clk;
      end
      
      phase.drop_objection(this);
   endtask
endclass
endpackage
