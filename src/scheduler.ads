with Jobs;

package Scheduler is
   Not_Possible : exception;
   procedure Init;
   procedure Run;
private
   procedure Schedule_One_Job (J : Jobs.Job);
end Scheduler;
