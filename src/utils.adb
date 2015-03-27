with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;

with POSIX.Process_Primitives;

with Logging;

package body Utils is

   procedure Check_Options is
   begin
      for Arg in 1 .. Argument_Count loop
         if Argument (Arg) = "-n" or else
           Argument (Arg) = "--no-action"
         then
            Action := False;
         elsif Argument (Arg) = "-l" or else
           Argument (Arg) = "--log-level"
         then
            Logging.Set_Level (Integer'Value (Argument (Arg + 1)));
         elsif Argument (Arg) = "-h" or else
           Argument (Arg) = "--help"
         then
            Ada.Text_IO.Put_Line ("Options may be given in full or with a single hyphen "
                                  & "and the first letter only");
            Ada.Text_IO.Put_Line ("--log-level n");
            Ada.Text_IO.Put_Line (" 0: no logging");
            Ada.Text_IO.Put_Line (" 1: errors");
            Ada.Text_IO.Put_Line (" 2: warnings");
            Ada.Text_IO.Put_Line (" 3: info");
            Ada.Text_IO.Put_Line (" 5 and up: debug");
            Ada.Text_IO.Put_Line ("--no-action only goes through the motions "
                                  & "without actually affecting any jobs");
            Ada.Text_IO.Put_Line ("--help shows this message, then terminates");
            POSIX.Process_Primitives.Exit_Process;
         end if;
      end loop;
   end Check_Options;
end Utils;
