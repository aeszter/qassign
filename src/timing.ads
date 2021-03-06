with Ada.Calendar;

package Timing is
   type Timer is private;
   procedure Start (T : out Timer);
   procedure Stop (T : in out Timer);
   function Result (T : Timer) return String;
   function Result (T : Timer) return Duration;
private
   type Timer is record
      Started, Stopped : Ada.Calendar.Time;
   end record;
end Timing;
