
%% OUTPUT

%exp_id: vector of injections ids
%inj_vol: vector of injections volume. needed to normalize cross different injections

% download data from ABA
st=getAllenStructureList();
tv = readNPY('C:\Users\Roberto\Documents\allen_atlas\template_volume_10um.npy');
av = readNPY('C:\Users\Roberto\Documents\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below


[descendents_seed,plot_right_only]=get_injection_data(st,'output',exp_id(qqq));
output=getProjectionDataFromExperiment(exp_id)
    
    
for qqq=1:numel(exp_id)

    temp=output{qqq};
    
    %normalize by injection volume
    projection_energy_normalized=num2cell([temp.projection_energy].*inj_vol(qqq))';
    
    [temp.projection_energy_normalized]= projection_energy_normalized{:};
    
    result_temp{qqq}=temp;
    
end

result=[];
for qqq=1:numel(result_temp)
    result=[ result result_temp{qqq}]
end

fprintf('ABA query succesful')
%%
% get coordinate of injection
injection.x=mean([result([result.is_injection]==1).max_voxel_x]);
injection.y=mean([result([result.is_injection]==1).max_voxel_y]);
injection.z=mean([result([result.is_injection]==1).max_voxel_z]);
% http://help.brain-map.org/display/mouseconnectivity/API


%delete annotations in injection area
result([result.is_injection]==1)=[];

%delete annotations with zero signal
result([result.projection_density]==0)=[];


result= prepare_result(result,st,descendents_seed,injection);

% https://alleninstitute.github.io/AllenSDK/unionizes.html

%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,10)

% save as png but vectorized! use native matlab save

%% consolidate data in main regions

[summary,result]=BRIO_consolidate(result,st);
%% histogram

BRIO_hist(result,0);


%% histogram

BRIO_hist(summary,1);

%% pie

BRIO_pie(summary);

%% relation with distance

BRIO_distance(result,summary,st)