function [ancestors_seed,descendents_seed,plot_right_only]=get_injection_data(st,type,exp_id)


if strcmp(type,'output')
    Id_injection = getInjectionIDfromExperiment(exp_id);
end


%get seed area

if strcmp(type,'output')
    
    seed_area_id= st.id(st.id==Id_injection);
    
else
       
    % select among at least depth 9 structures
    st = sortrows(st, 'safe_name');
    idx=listdlg('PromptString','Select a structure to plot:', ...
        'ListString',st.safe_name(st.depth<9),'ListSize',[520,500]);
    temp=st.id(st.depth<9);
    seed_area_id=temp(idx);
    
    
end


ancestors_seed=getAllenStructureList('ancestorsOf' ,seed_area_id)

%choose depth of seed
ancestors_seed=ancestors_seed(ancestors_seed.depth==8,:);


% plot_right_only = convertCharsToStrings(questdlg('Would you like to plot source region only on one hemisphere?', ...
% 	'Dessert Menu', ...
% 	'Yes','No','No'));
plot_right_only='Yes';

%get descendents
descendents_seed=getAllenStructureList('childrenOf' ,ancestors_seed.id);

if strcmp(type,'output')
fprintf('injection located in <strong> %s </strong> \n', char(ancestors_seed.name))
else
    fprintf('target located in <strong> %s </strong> \n', char(ancestors_seed.name))
end