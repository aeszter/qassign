with Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

package body Logging is

   procedure Debug (Message : String) is
   begin
      Write (Level => 5, Message => Message);
   end Debug;

   procedure Error (Message : String) is
   begin
      Write (Level => 1, Message => Message);
   end Error;

   ----------
   -- Info --
   ----------

   procedure Info (Message : String) is
   begin
      Write (Level => 3, Message => Message);
   end Info;

   function Label (Level : Positive) return String is
   begin
      case Level is
         when 1 => return "Error";
         when 2 => return "Warn";
         when 3 => return "Info";
         when 4 => return "Reserved";
         when 5 => return "Debug";
         when others => return "Debug" & Ada.Strings.Fixed.Trim (Level'Img, Ada.Strings.Left);
      end case;
   end Label;

   procedure Open_File (Name : String) is
   begin
      Ada.Text_IO.Open (File => Log_File,
                        Mode => Append_File,
                        Name => Name);
   exception
      when Name_Error =>
         Ada.Text_IO.Create (File => Log_File,
                             Mode => Append_File,
                             Name => Name);
   end Open_File;

   procedure Put_Timestamp is
      procedure Put_With_Zero (N : Natural);
      procedure Put (Item : Character);

      procedure Put (Item : Character) is
      begin
         Ada.Text_IO.Put (File => Log_File, Item => Item);
      end Put;

      procedure Put_With_Zero (N : Natural) is
      begin
         if N < 10 then
            Put ('0');
         end if;
         Ada.Integer_Text_IO.Put (File => Log_File, Item => N, Width => 1);
      end Put_With_Zero;

      Now     : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      Year    : Ada.Calendar.Year_Number;
      Month   : Ada.Calendar.Month_Number;
      Day     : Ada.Calendar.Day_Number;
      Hour    : Ada.Calendar.Formatting.Hour_Number;
      Minute  : Ada.Calendar.Formatting.Minute_Number;
      Second  : Ada.Calendar.Formatting.Second_Number;
      Sub_Second : Ada.Calendar.Formatting.Second_Duration;

   begin
      Ada.Calendar.Formatting.Split (Now,
                                     Year       => Year,
                                     Month      => Month,
                                     Day        => Day,
                                     Hour       => Hour,
                                     Minute     => Minute,
                                     Second     => Second,
                                     Sub_Second => Sub_Second);
      Put_With_Zero (Day);
      Put ('-');
      Put_With_Zero (Month);
      Put ('-');
      Ada.Integer_Text_IO.Put (File => Log_File, Item => Year, Width => 4);
      Put ('T');
      Put_With_Zero (Hour);
      Put (':');
      Put_With_Zero (Minute);
      Put (':');
      Put_With_Zero (Second);
   end Put_Timestamp;

   procedure Set_Level (To : Natural) is
   begin
      Log_Level := To;
   end Set_Level;

   procedure Warning (Message : String) is
   begin
      Write (Level => 2, Message => Message);
   end Warning;

   procedure Write (Level : Natural; Message : String) is
   begin
      if Level <= Log_Level then
         Put_Timestamp;
         Ada.Text_IO.Put_Line (File => Log_File,
                               Item => " " & Label (Level) & " " & Message);
      end if;
   end Write;

end Logging;
