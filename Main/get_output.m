
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

 result_temp{qqq}=temp;
end

result=[];
for qqq=1:numel(result_temp)
    result=[ result result_temp{qqq}]
end

%%

result([result.is_injection]==1)=[];
result([result.projection_density]==0)=[]; 


result= prepare_result(result,st,descendents_seed);

% https://alleninstitute.github.io/AllenSDK/unionizes.html
%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,10)


%% histogram

BRIO_hist(result,0);


%% consolidate data in main regions


result_processed=BRIO_consolidate(result,st)


%% histogram

BRIO_hist(result_processed,1);


%% pie


BRIO_pie(result_processed);


