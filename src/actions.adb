with Logging;

package body Actions is

   procedure Assign (J : Jobs.Job; Destination : String) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Assign unimplemented");
      Logging.Info ("Mock: " & J.Get_ID & " assigned to " & Destination);
   end Assign;

end Actions;
