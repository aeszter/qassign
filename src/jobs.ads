with SGE.Jobs;

package Jobs is
   type Job is private;
   function Get_ID (J : Job) return String;
private
type Job is new SGE.Jobs.Job with null record;
end Jobs;
