with Ada.Calendar; use Ada.Calendar;

package body Timing is

   function Result (T : Timer) return Duration is
   begin
      return T.Stopped - T. Started;
   end Result;

   function Result (T : Timer) return String is
   begin
      return Duration'Image (Result (T));
   end Result;

   -----------
   -- Start --
   -----------

   procedure Start (T : out Timer) is
   begin
      T.Started := Ada.Calendar.Clock;
   end Start;

   ----------
   -- Stop --
   ----------

   procedure Stop (T : in out Timer) is
   begin
      T.Stopped := Ada.Calendar.Clock;
   end Stop;

end Timing;
