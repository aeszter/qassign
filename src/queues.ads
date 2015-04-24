with Jobs;

package Queues is
   function Find_Match_Now (J : Jobs.Job; Mark_As_Used : Boolean) return String;
end Queues;
