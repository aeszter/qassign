with Jobs;

package Partitions is
function Find_Match_Now (J : Jobs.Job) return String;
   procedure Mark_As_Used;
   procedure Build_List;
end Partitions;
