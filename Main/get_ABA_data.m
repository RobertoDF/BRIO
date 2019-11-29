function [delete_this_annotations,levels_2_keep,selected_area_id,...
    st,tv,av,colorxID_rgb,parent_ID,IDs,full_name,acronym,size_dots,plot_right_only]=get_ABA_data(type,exp_id)

%% get basic data from allen brain atlas 


if strcmp(type,'output') 
    ID_injection = getInjectionIDfromExperiment(exp_id);
end

size_dots=3000;

uuu=getAllenStructureList();

IDs=table2array(uuu(:,1));
colorxID=table2array(uuu(:,14));
acronym=table2array(uuu(:,4));
full_name=table2array(uuu(:,3));

parent_ID=table2array(uuu(:,9));

for ii=1:length(colorxID)
    str=char(colorxID(ii));    
colorxID_rgb(ii,:) =hex2rgb(str);
end

tv = readNPY('C:\Users\Roberto\Documents\allen_atlas\template_volume_10um.npy');
av = readNPY('C:\Users\Roberto\Documents\allen_atlas\annotation_volume_10um_by_index.npy'); % the number at each pixel labels the area, see note below
st = loadStructureTree('C:\Users\Roberto\Documents\allen_atlas\structure_tree_safe_2017.csv');
a=uuu.structure_id_path;
for i=1:numel(a)
    chr=char(a{i});
    k = strfind(chr,'/');
       for ii=1:length(k)-1
           st_path{i,ii}=str2num(chr(k(ii)+1:k(ii+1)-1));
       end
end

empties = cellfun('isempty',st_path);

st_path(empties) = {NaN};

%structures to keep,level 5 + isocortex descendents (1level) hip and rhp
levels_2_keep=uuu.id(uuu.st_level==5);
levels_2_keep(levels_2_keep==315)=[];

%st level+1=st_path

%isocortex
iso=unique([st_path{([st_path{:,6}]==315),7}])';
hip=1080;
rhp=822;
ent=909;
raphe=[165, 872, 206, 222, 230, 238, 679, 137 ,130, 197];

levels_2_keep=vertcat(levels_2_keep ,iso, hip, rhp, ent,raphe');

       slice_spacing = 5;
if strcmp(type,'input') 
    idx=ismember(st.id,levels_2_keep);
      % Prompt for which structures to select
      
       parsed_structures = unique(reshape(av(1:slice_spacing:end, ...
                1:slice_spacing:end,1:slice_spacing:end),[],1));
             plot_structures_parsed = listdlg('PromptString','Select a structure to plot:', ...
                'ListString',st.safe_name(parsed_structures),'ListSize',[520,500]);
            plot_structures_index = parsed_structures(plot_structures_parsed);
      
%       
%         plot_structures_index = listdlg('PromptString','Select seed structure:', ...
%             'ListString',st.safe_name(idx),'ListSize',[520,500]);
%         this_areas=st.index(idx);
%         plot_structures_index= this_areas(plot_structures_index);
else
plot_structures_index= st.index(st.id==ID_injection);
end




%annotation to delete
Idx = find(contains([uuu.color_hex_triplet],'CCCCCC'));
delete_this_annotations=uuu.id(Idx);%grey annotations
delete_this_annotations(end+1)=8; %grey annotations


idx=ismember(st.id,levels_2_keep);

for qq=1:numel(plot_structures_index)
fprintf('area selected: %s \n',st.name{st.index==plot_structures_index(qq)})
end

plot_right_only = convertCharsToStrings(questdlg('Would you like to plot source region only on one hemisphere?', ...
	'Dessert Menu', ...
	'Yes','No','No'));
    
    
%get descendents
id_selected=[];
index_descendents=[];


for qq=1:numel(plot_structures_index)
id_selected(qq)=st.id(st.index==plot_structures_index(qq));
end


if any(st.parent_structure_id==id_selected)
    index_descendents=st.id(st.parent_structure_id==id_selected);   
end

while  sum((ismember(st.parent_structure_id,index_descendents)))>numel(index_descendents)

    idx=ismember(st.parent_structure_id,index_descendents);
    index_descendents=vertcat(index_descendents, st.id(idx));

end   
    selected_area_id=[];
%     index_elected=uuu.atlas_id(uuu.atlas_id==)
selected_area_id=vertcat(index_descendents,id_selected);

idx=ismember(st.id,selected_area_id);
delete_this_annotations= vertcat(delete_this_annotations,st.id(idx)); %from injection area
delete_this_annotations= vertcat(delete_this_annotations,0); %from injection area

