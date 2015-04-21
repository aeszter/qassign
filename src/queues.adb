with SGE.Queues; use SGE.Queues;
with SGE.Host_Properties; use SGE.Host_Properties;
with Scheduler;

package body Queues is

   --------------------
   -- Find_Match_Now --
   --------------------

   function Find_Match_Now (J : Jobs.Job; Mark_As_Used : Boolean) return String is
      Props : Set_Of_Properties;
      Slots_To_Occupy : Natural;
      procedure Update_Slot_Count (Q : in out Queue);

      procedure Update_Slot_Count (Q : in out Queue) is
      begin
         Occupy_Slots (Q, Slots_To_Occupy);
      end Update_Slot_Count;

   begin
      Rewind;
      while not At_End loop
         Props := Get_Properties (Current);
         if J.Can_Run (Props) and then
           Get_Free_Slots (Current) >= J.Get_Minimum_Slots
         then
            if Mark_As_Used then
               Slots_To_Occupy := Integer'Min (J.Get_Maximum_Slots, Get_Free_Slots (Current));
               Update_Current (Update_Slot_Count'Access);
            end if;
            return Get_Name (Current);
         end if;
      end loop;
      raise Scheduler.Not_Possible;
   end Find_Match_Now;

end Queues;
