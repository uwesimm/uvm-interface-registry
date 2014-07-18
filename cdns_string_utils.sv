/*
 #----------------------------------------------------------------------
 #   Copyright 2014 Cadence Design Systems, Inc.
 #   All Rights Reserved Worldwide
 #----------------------------------------------------------------------

 mailto: uwes@cadence.com

 helper package to provide addon string handling functions
 
 - string str_join(string del,string s[$])
 -
 
 */

package cdns_string_utils;
   // joins the queue of string ~s~ using the delimiter ~del~
   function automatic string str_join(string del=",", string s[$]);
      string r[$];
      foreach(s[idx])
        begin
           r.push_back(s[idx]); r.push_back(del);
        end
      if(r.size())
        void'(r.pop_back());

      str_join={>>{r}};
   endfunction	
endpackage
