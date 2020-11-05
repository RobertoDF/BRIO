function BRIO_input(projectionsearchresults)

% 1 go here:
% http://connectivity.brain-map.org/
% 2  select a target structure and then download the results as CSV. 
% 3 Select only right hemisphere!!
% 4 import projection search table in matlab (just drop it in workspace) and
% it should be converted in a table called projectionsearchresults
% 5 call this function


% download data from ABA
st=getAllenStructureList();
tv = readNPY('E:\Roberto\allen_atlas\template_volume_10um.npy');
av = readNPY('E:\Roberto\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below

%temporary workaround!! Change manuallly line 32 in get_injection_data to have the right target structure
  [ancestor,descendents_seed,plot_right_only]=get_injection_data(st,'input',0);

  % only metric available for input
  
  metric='normalized_projection_volume';

%% INPUT
result=table();   

inject_coor_temp=table2array(projectionsearchresults(:,15));

for ii=1:numel(inject_coor_temp)
    a=inject_coor_temp(ii);
    inject_coor(ii,:)=str2num(a);
end


target_volume=table2array(projectionsearchresults(:,12));%volume of projection signal in target structure in mm^3
inject_volume=table2array(projectionsearchresults(:,8));


result.max_voxel_x=inject_coor(:,1);
result.max_voxel_y=inject_coor(:,2);
result.max_voxel_z=inject_coor(:,3);
result.hex=table2array(projectionsearchresults(:,13));
result.structure_id=table2array(projectionsearchresults(:,4));
result.normalized_projection_volume=(target_volume./inject_volume);

result=result([result.normalized_projection_volume]>0.001,:);

result = table2struct( result);

temp_idx=[];
for q=1:numel(descendents_seed(:,1))
    temp=table2array(projectionsearchresults(:,5))== char(table2array(descendents_seed(q,4)));
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
% threshold is not use in this case, we already cleaned based on normalized
% projection volume
threshold=0.1;

[consolidated_summary,result]=BRIO_consolidate(result,st,threshold);

%% histogram

BRIO_hist(result,0,metric);


%% histogram

BRIO_hist(consolidated_summary,1,metric);

%% pie

threshold=0.1;
BRIO_pie(consolidated_summary,metric,threshold);

%% relation with distance

BRIO_distance(result,consolidated_summary,st,metric)