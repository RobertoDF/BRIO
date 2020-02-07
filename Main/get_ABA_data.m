function [descendents_seed,base_level,...
    st,tv,av,plot_right_only]=get_ABA_data(type,exp_id)

%% get basic data from allen brain atlas


if strcmp(type,'output')
    Id_injection = getInjectionIDfromExperiment(exp_id);
end



st=getAllenStructureList();



tv = readNPY('C:\Users\Roberto\Documents\allen_atlas\template_volume_10um.npy');
av = readNPY('C:\Users\Roberto\Documents\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below
% st = loadStructureTree('C:\Users\Roberto\Documents\allen_atlas\structure_tree_safe_2017.csv');


%structures to keep,level 5 + isocortex descendents (1level) hip and rhp
base_level=st.id(st.st_level<9);


%get seed area

if strcmp(type,'output')
    
    seed_area_id= st.id(st.id==Id_injection);
    
else
    
    
    % select among at least level 8 structures
    st = sortrows(st, 'safe_name');
    idx=listdlg('PromptString','Select a structure to plot:', ...
        'ListString',st.safe_name(st.depth<9),'ListSize',[520,500]);
    temp=st.id(st.depth<9);
    seed_area_id=temp(idx);
    
    
end


ancestors_seed=getAllenStructureList('ancestorsOf' ,seed_area_id);
%isolate level 8
ancestors_seed=ancestors_seed(ancestors_seed.st_level==8,:);

%annotation to delete
% Idx = find(contains([uuu.color_hex_triplet],'CCCCCC'));
% delete_this_annotations=uuu.id(Idx);%grey annotations
% delete_this_annotations(end+1)=8; %grey annotations


% plot_right_only = convertCharsToStrings(questdlg('Would you like to plot source region only on one hemisphere?', ...
% 	'Dessert Menu', ...
% 	'Yes','No','No'));
plot_right_only=1;

%get descendents
descendents_seed=getAllenStructureList('childrenOf' ,ancestors_seed.id);

fprintf('injection located in <strong> %s </strong> \n', char(ancestors_seed.name))
