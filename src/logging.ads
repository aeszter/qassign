with Ada.Text_IO;

package Logging is
   procedure Info (Message : String);
   procedure Warning (Message : String);
   procedure Error (Message : String);
   procedure Debug (Message : String);

   procedure Open_File (Name : String);
   procedure Set_Level (To : Natural);
private
   Log_Level : Natural := 2;
   Log_File : Ada.Text_IO.File_Type;
   procedure Write (Level : Natural; Message : String);
   function Label (Level : Positive) return String;
   procedure Put_Timestamp;

end Logging;
