/*
 #----------------------------------------------------------------------
 #   Copyright 2014 Cadence Design Systems, Inc.
 #   All Rights Reserved Worldwide
 #----------------------------------------------------------------------

 mailto: uwes@cadence.com

 name: an interface registry 
 
 it allows the following
 
 1. interface instances can register automatically themselves in a database with their full %m paths as key
 2. users can retrieve the vif instance if the know the right key
 3. the lookup key is constructed via getHDLContext(uvm_component) which queries the string attribute of the component and its parents nd a custom postfix.
 4. the retrieved vif can be checked automatically for existance and non-null
 
 */
`include "uvm_macros.svh"

package cdns_vif_registry;
   import uvm_pkg::*;	
   import cdns_string_utils::str_join;

class cdns_vif_db#(type T=int) extends uvm_config_db#(T);       
   // removes the "register" scope path component
   static local function string fixname(string name);
      string q[$];
      int    qi[$];
      uvm_split_string(name, ".", q);
      qi = q.find_last_index(s) with (s== "register");
      q.delete(qi[0]);
      return str_join(".",q);
   endfunction	
   
   // registers the ~vif~ under "vifs" with a fieldName <vifName>
   static function void register_vif(T vif, string vifName);
      string n = fixname(vifName);
      `uvm_info("VIF-SELF-REGISTER",$sformatf("vif %p registered with key=%s",vif,n),UVM_NONE)
      set(null,"vifs",n,vif);
   endfunction
   
   static function string getHDLContext(uvm_component cntxt);
      string q[$];
      while(cntxt!=null) begin
	 uvm_resource#(string) n = uvm_resource#(string)::get_by_name(cntxt.get_name(),"HDLContext",1);
	 if(n)
	   q.push_front(n.read());
	 cntxt=cntxt.get_parent();
      end
      return str_join(".",q);
   endfunction
   
   // retrieves a ~vif~ stored at <cntxt-path>.<path>
   // it will be validated when ~validated~ is set to 1 (non-null vif assigned)
   static function void retrieve_vif(ref T vif,input uvm_component cntxt,string path, bit validate=1);
      string n = getHDLContext(cntxt);
      string fn = {n,".",path};
      if(get(null,"vifs",fn,vif)) begin
	 if(vif==null && validate)  
	   `uvm_warning("VIF-NULL", $sformatf("vif is null retrieving component=%s HDLContext=%s name=%s",
					      cntxt.get_full_name(),n,path))
      end
      else
	if(validate) 
	  `uvm_warning("VIF-UNSET",$sformatf("vif not found for component=%s HDLContext=%s path=%s",
					     cntxt.get_full_name(),n,path))	
      
      `uvm_info("VIF-SETUP",$sformatf("using vif from HDLContext=%s and path=%s in component=%s",
				      n,path,cntxt.get_full_name()),UVM_MEDIUM)
   endfunction
   
   // you cannot make an instance by new'ing the class
   local function new();
   endfunction
endclass
endpackage
