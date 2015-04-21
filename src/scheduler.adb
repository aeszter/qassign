with Actions;
with Jobs; use Jobs;
with Logging;
with Timing; use Timing;
with Queues;

with SGE.Parser;
with SGE.Queues;
with SGE.Taint; use SGE.Taint;

package body Scheduler is
   Resource_Selector : constant Trusted_String := Implicit_Trust ("-F h_rt,eth,ib,ibs,ssd,gpu,mem_total,num_proc,cm,gm,q,slots");

   procedure Init is
      SGE_Out : SGE.Parser.Tree;
      Init_Time : Timer;
   begin
      Start (Init_Time);
      SGE_Out := SGE.Parser.Setup (Selector => Resource_Selector, Command => Cmd_Qstat);

      SGE.Queues.Append_List (SGE.Parser.Get_Elements_By_Tag_Name (SGE_Out, "Queue-List"));
      SGE.Queues.Sort_By_Sequence;
      SGE.Parser.Free;
      Stop (Init_Time);
      Logging.Info ("Init took " & Result (Init_Time));
   end Init;

   procedure Run is
      SGE_Out : SGE.Parser.Tree;
      Scheduler_Time, Read_Time : Timer;
   begin
      --  loop
      Start (Scheduler_Time);
      Start (Read_Time);
      SGE_Out := SGE.Parser.Setup (Selector => Implicit_Trust ("-u * -s p"), Command => Cmd_Qstat);

      Jobs.Append_List (SGE.Parser.Get_Job_Nodes_From_Qstat_U (SGE_Out));
      SGE.Parser.Free;
      Stop (Read_Time);
      Logging.Info ("Job reading took " & Result (Read_Time));
      Jobs.Iterate (Schedule_One_Job'Access);

      Stop (Scheduler_Time);
      Logging.Info ("Scheduler run took " & Result (Scheduler_Time));
      --  end loop
   end Run;

   procedure Schedule_One_Job (J : Jobs.Job) is
      Time : Timer;
   begin
      Start (Time);
      declare
         Destination : constant String := Queues.Find_Match_Now (J, True);
      begin
         Actions.Assign (J, Destination);
      exception
         when Not_Possible =>
            Logging.Debug (Get_ID (J) & ": cannot run");
      end;
      Stop (Time);
      if Result (Time) < 1.0 then
         Logging.Debug (Get_ID (J) & " took " & Result (Time));
      elsif Result (Time) < 60.0 then
         Logging.Info (Get_ID (J) & " took " & Result (Time));
      else
         Logging.Warning (Get_ID (J) & " took " & Result (Time));
      end if;
   end Schedule_One_Job;

end Scheduler;
