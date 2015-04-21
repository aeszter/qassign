with Ada.Containers.Doubly_Linked_Lists;

with SGE.Jobs;
with SGE.Parser;
with SGE.Host_Properties;

package Jobs is
   type Job is new SGE.Jobs.Job with private;
   procedure Append_List (Nodes : SGE.Parser.Node_List);
   procedure Iterate (Process : not null access procedure (J : Job));
   function Can_Run (J : Job; Props : SGE.Host_Properties.Set_Of_Properties) return Boolean;

private
   type Job is new SGE.Jobs.Job with null record;
   package Job_Lists is
     new Ada.Containers.Doubly_Linked_Lists (Element_Type => Job, "=" => Same);

   List : Job_Lists.List;

end Jobs;
