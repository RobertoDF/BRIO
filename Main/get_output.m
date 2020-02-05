function get_output(exp_id)
% if you want to combine two injections you have to manually combine the
% results in the next section and in this section you should  use this:


  [descendents_seed,base_level,...
    st,tv,av,plot_right_only]=get_ABA_data('output',exp_id);




%% OUTPUT

% download data from ABA

output=getProjectionDataFromExperiment(exp_id)
result=output{1};
% you can combine multiple experiments do as follows:

% result = getProjectionDataFromExperiment(114472145);%0.35mm^3
% result2 = getProjectionDataFromExperiment(113226232);%0.55mm^3

%normalize per injection volume
% 
% inj_vol_1=0.35;
% inj_vol_2=0.55;
% ratio=1/(inj_vol_1/inj_vol_2);
% norm_projection_density=[result{1,1}.projection_density]*ratio;
% norm_projection_density=[norm_projection_density result2{1,1}.projection_density];
%  result {1} = [result{1} ,result2{1}];

%%

result([result.is_injection]==1)=[];
result([result.projection_density]==0)=[]; 

% norm_projection_density when more than one exp
if exist ('norm_projection_density','var')
    
    result.strenght_connection=norm_projection_density*size_dots;
    
end

result= prepare_result(result,st,descendents_seed);

% https://alleninstitute.github.io/AllenSDK/unionizes.html
%%

plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,3)


%% histogram

BRIO_hist(result,0);


%% consolidate data in main regions


result_processed=BRIO_consolidate(result,st)


%% histogram

BRIO_hist(result_processed,1);


%% pie


BRIO_pie(result_processed);


