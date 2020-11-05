function BRIO_output
%% OUTPUT

%exp_id: vector of injections ids
%inj_vol: vector of injections volume. needed to normalize cross different injections

input = inputdlg({'Experiment ID','Injection Volume (mm^3)'},...
    'Input Data', [1 20; 1 20]);

exp_id=str2num(input{1});
inj_vol=str2num(input{2});

list = {'projection_energy_normalized','projection_density_normalized','projection_intensity_normalized',...
    'normalized_projection_volume'};
[idx,~] = listdlg('PromptString',"Metric to use",'ListString',list,'ListSize',[300,150]);

metric=char(list(idx))
%% Check selected seed structure

% download data from ABA
st=getAllenStructureList();
tv = readNPY('E:\Roberto\allen_atlas\template_volume_10um.npy');
av = readNPY('E:\Roberto\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below

%get injection area

%temporary workaround!! Change manuallly line 32 in get_injection_data to have the right target structure

for qqq=1:numel(exp_id)
    [ancestor,descendents_seed,plot_right_only]=get_injection_data(st,'output',exp_id(qqq));
    ancestors(qqq)=table2array(ancestor(1,1));
end



if exist('ancestors')
    
    ancestors(ancestors==ancestors(1))=0;
    if sum(ancestors)>1
        fprintf('Multiple injections in different areas!')
    else
        
    end
end


output=getProjectionDataFromExperiment(exp_id)


for qqq=1:numel(exp_id)
    
    temp=output{qqq};
    
    %normalize by injection volume
    projection_energy_normalized=num2cell([temp.projection_energy].*inj_vol(qqq))';
    projection_density_normalized=num2cell([temp.projection_density].*inj_vol(qqq))';
    projection_intensity_normalized=num2cell([temp.projection_intensity].*inj_vol(qqq))';
    
    [temp.projection_energy_normalized]= projection_energy_normalized{:};
    [temp.projection_density_normalized]=  projection_density_normalized{:};
    [temp.projection_intensity_normalized]= projection_intensity_normalized{:};
    
    result_temp{qqq}=temp;
    
end

result=[];
for qqq=1:numel(result_temp)
    result=[ result result_temp{qqq}]
end

fprintf('\n ABA query successful')
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
fprintf('Data ready')
%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,metric)

% save as png but vectorized! use native matlab save

%% consolidate data in main regions
%threshold on normalized projection energy to exclude weak projections that
%would bias the mean

threshold=0.1;

[consolidated_summary,result_cleaned]=BRIO_consolidate(result,st,threshold);

%% histogram

BRIO_hist(result_cleaned,0,metric);


%% histogram

BRIO_hist(consolidated_summary,1,metric);

%% pie

threshold=0.1;
BRIO_pie(consolidated_summary,metric,threshold);

%% relation with distance

BRIO_distance(result_cleaned,consolidated_summary,st,metric)