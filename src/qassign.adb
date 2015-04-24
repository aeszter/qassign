with Logging;
with Utils;
with Scheduler;

procedure Qassign is
begin
   Utils.Check_Options;
   Logging.Open_File ("/var/log/qassign.log");
   Logging.Info ("qassign " & Utils.Version & " starting");
   Scheduler.Init;
   Scheduler.Run;
   Logging.Info ("qassign " & Utils.Version & " terminating");
end Qassign;
