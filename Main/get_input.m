function get_input(input_table)

% go here:
% http://connectivity.brain-map.org/
% select a target structure and then download the results as CSV. 
%Select right hemisphere!!
% import projection search table
% rename as: input_table


% download data from ABA
st=getAllenStructureList();
tv = readNPY('Z:\Roberto\allen_atlas\template_volume_10um.npy');
av = readNPY('Z:\Roberto\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below

%temporary workaround!! Change manuallly line 32 in get_injection_data to have the right target structure
  [ancestor,descendents_seed,plot_right_only]=get_injection_data(st,'input',0);

  % only metric available for input
  
  metric='normalized_projection_volume';

%% INPUT
result=table();   

inject_coor_temp=table2array(input_table(:,15));

for ii=1:numel(inject_coor_temp)
    a=inject_coor_temp(ii);
    inject_coor(ii,:)=str2num(a);
end


target_volume=table2array(input_table(:,12));%volume of projection signal in target structure in mm^3
inject_volume=table2array(input_table(:,8));


result.max_voxel_x=inject_coor(:,1);
result.max_voxel_y=inject_coor(:,2);
result.max_voxel_z=inject_coor(:,3);
result.hex=table2array(input_table(:,13));
result.structure_id=table2array(input_table(:,4));
result.normalized_projection_volume=(target_volume./inject_volume);


 result = table2struct( result);
 
temp_idx=[];
 for q=1:numel(descendents_seed(:,1))
 temp=table2array(input_table(:,5))== char(table2array(descendents_seed(q,4)));
 temp_idx=[temp_idx temp];
 end
 
 
 temp_idx=any(temp_idx,2);
 source_coord.x=mean(inject_coor(temp_idx,1));
  source_coord.y=mean(inject_coor(temp_idx,2));
   source_coord.z=mean(inject_coor(temp_idx,3));
 
result= prepare_result(result,st,descendents_seed,source_coord);


%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,metric)

%% consolidate data in main regions

[consolidated_summary,result]=BRIO_consolidate(result,st);

%% histogram

BRIO_hist(result,0,metric);


%% histogram

BRIO_hist(consolidated_summary,1,metric);

%% pie

BRIO_pie(consolidated_summary,metric);

%% relation with distance

BRIO_distance(result,consolidated_summary,st,metric)