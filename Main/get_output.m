
%% OUTPUT

%exp_id: vector of injections ids
%inj_vol: vector of injections volume. needed to normalize cross different injections


for qqq=1:numel(exp_id)
    
    [descendents_seed,base_level,...
        st,tv,av,plot_right_only]=get_ABA_data('output',exp_id(qqq));
    
    %%
    % download data from ABA
    
    output=getProjectionDataFromExperiment(exp_id(qqq))
    temp=output{1};
    
    projection_energy_normalized=num2cell([temp.projection_energy].*inj_vol(qqq))';
    
    %normalize by injection volume
    [temp.projection_energy_normalized]= projection_energy_normalized{:};
    
    % for www=1:numel(temp)
    %
    %    temp(www).distance=norm([ result(www).max_voxel_x/10,result(www).max_voxel_z/10,result(www).max_voxel_y/10]-coords(www,:));%z and y inverted!
    %
    % end
    %  result_temp.distance=
    
    result_temp{qqq}=temp;
    
end

result=[];
for qqq=1:numel(result_temp)
    result=[ result result_temp{qqq}]
end

fprintf('DONE!')
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
%% histogram

BRIO_hist(result,0);


%% consolidate data in main regions

[summary,result]=BRIO_consolidate(result,st);

%% histogram

BRIO_hist(summary,1);

%% pie

BRIO_pie(summary);

%% relation with distance

BRIO_distance(result,summary,st)