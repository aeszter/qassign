with SGE.Jobs;

package Scheduler is
   procedure Init;
   procedure Run;
private
   procedure Schedule_One_Job (J : SGE.Jobs.Job);
end Scheduler;
