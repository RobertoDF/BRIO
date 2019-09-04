function [structure_ID,x,y,z,strenght_connection]= brain_areas_cleaner(x,y,z,strenght_connection,structure_ID,levels_2_keep,delete_this_annotations,IDs,parent_ID,selected_area)


for ii=1:numel(structure_ID)
   while ~any(ismember(levels_2_keep,structure_ID(ii)))
structure_ID(ii)=parent_ID(IDs==structure_ID(ii));
   end
end

  
%delete injection in the selected area right emisphere
  
todelete=ismember(structure_ID,selected_area)&z>600;

todelete2=ismember(structure_ID,delete_this_annotations);

structure_ID(strenght_connection==0|todelete|todelete2)=[];
x(strenght_connection==0|todelete|todelete2)=[];
y(strenght_connection==0|todelete|todelete2)=[];
z(strenght_connection==0|todelete|todelete2)=[];
strenght_connection(strenght_connection==0|todelete|todelete2)=[];