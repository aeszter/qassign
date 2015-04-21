package body Jobs is

   procedure Append_List (Nodes : SGE.Parser.Node_List) is
      use SGE.Parser;
      N : Node;
   begin
      for Index in 1 .. Length (Nodes) loop
         N := Item (Nodes, Index - 1);
         if Name (N) /= "#text" then
            List.Append (New_Job (Child_Nodes (N)));
         end if;
      end loop;
   end Append_List;

   function Can_Run (J : Job; Props : SGE.Host_Properties.Set_Of_Properties) return Boolean is
      pragma Unreferenced (J, Props);
   begin
      return False;
      pragma Compile_Time_Warning (True, "Unimplemented");
   end Can_Run;

   procedure Iterate (Process : not null access procedure (J : Job)) is
      use Job_Lists;

      procedure Wrapper (Position : Job_Lists.Cursor);

      procedure Wrapper (Position : Job_Lists.Cursor) is
      begin
         Process (Element (Position));
      end Wrapper;

   begin
      List.Iterate (Wrapper'Access);
   end Iterate;

end Jobs;
