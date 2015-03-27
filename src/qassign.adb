with Logging;
with Utils;

procedure Qassign is
begin
   Utils.Check_Options;
   Logging.Open_File ("/var/log/qassign.log");
   Logging.Info ("Hello world!");
end Qassign;
