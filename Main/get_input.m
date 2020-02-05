function get_input(input_table)

% go here:
% http://connectivity.brain-map.org/
% select a target structure and then download the results as CSV
% import projection search table
% rename as: input_table

  [descendents_seed,base_level,...
    st,tv,av,plot_right_only]=get_ABA_data('input');


%% INPUT
result=table();   

inject_coor_temp=table2array(input_table(:,15));

for ii=1:numel(inject_coor_temp)
    a=inject_coor_temp(ii);
    inject_coor(ii,:)=str2num(a);
end

inject_coor=inject_coor;
target_volume=table2array(input_table(:,12));%volume of projection signal in target structure in mm^3
inject_volume=table2array(input_table(:,8));


result.max_voxel_x=inject_coor(:,1);
result.max_voxel_y=inject_coor(:,2);
result.max_voxel_z=inject_coor(:,3);
result.hex=table2array(input_table(:,13));
result.structure_id=table2array(input_table(:,4));
result.normalized_projection_volume=(target_volume./inject_volume);


 result = table2struct( result);


result= prepare_result(result,st,descendents_seed);


%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,30)


%% histogram

BRIO_hist(result,0);


%% consolidate data in main regions


result_processed=BRIO_consolidate(result,st);


%% histogram

BRIO_hist(result_processed,1);
%% pie


BRIO_pie(result_processed);
 
