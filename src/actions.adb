with Ada.Exceptions; use Ada.Exceptions;
with SGE.Parser;
with SGE.Spread_Sheets;
with SGE.Taint; use SGE.Taint;
with Logging;

package body Actions is

   procedure Assign (J : Jobs.Job; Destination : String) is
      Output       : SGE.Spread_Sheets.Spread_Sheet;
      Exit_Status : Natural;
   begin
      Logging.Info (J.Get_ID & " assigned to " & Destination);
         SGE.Parser.Setup_No_XML (Command => Trust_As_Command ("qalter"),
                                  Subpath => Implicit_Trust ("/bin/linux-x64/"),
                                  Selector => Sanitise_Job_List (J.Get_ID)
                                  & Implicit_Trust (" -q ") & Sanitise (Destination)
                                  & Implicit_Trust (" -h S"),
                                  Output      => Output,
                                  Exit_Status => Exit_Status);
         Output.Rewind;
         if Output.At_Separator then
            Output.Next;
         end if;
         case Exit_Status is
            when 0 => null; -- OK
            when 1 =>
               declare
                  Message : constant String := Output.Current;
               begin
                     Logging.Info ("Exit Status 1, evaluate output (Bug #1849)");
                     Logging.Error ("#" & Message & "#");
               exception
                  when others =>
                     Logging.Error ("Unable to handle qalter exit status");
                     raise;
               end;
            when others =>
               Logging.Error ("qalter exited with status" & Exit_Status'Img
                               & ". This is a bug in qassign because it is "
                               & "unhandled in the Actions package.");
         end case;
   exception
      when E : SGE.Parser.Parser_Error =>
         Logging.Error ("Could not start assigned job" & J.Get_ID);
         Logging.Info ("#" & Exception_Message (E) & "#");
      when E : others =>
         Logging.Error ("Unknown error in Actions.Assign (" & J.Get_ID & "): ");
         Logging.Info (Exception_Message (E));
   end Assign;

end Actions;
