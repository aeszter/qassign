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
   begin
      if J.Get_Minimum_Slots <= SGE.Host_Properties.Get_Cores (Props) then
         return True;
      end if;
      return False;
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
