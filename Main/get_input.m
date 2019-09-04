function get_input(input_table)

% go here:
% http://connectivity.brain-map.org/
% select a target structure and then download the results as CSV
% import projection search table as input_table

[delete_this_annotations,levels_2_keep,selected_area,st,tv,av,colorxID_rgb,...
    parent_ID,IDs,full_name,acronym,size_dots,plot_right_only]=get_ABA_data('input');

%% INPUT
   
inject_coor=table2array(input_table(:,15));
for ii=1:numel(inject_coor)
    a=inject_coor(ii);
    inject_coord(ii,:)=str2num(a);
end
inject_coord=inject_coord/10;
target_volume=table2array(input_table(:,12));%volume of projection signal in target structure in mm^3
inject_volume=table2array(input_table(:,8));
structure_ID=table2array(input_table(:,4));

% inject_coord(target_volume<0.001)=[];
% inject_volume(target_volume<0.001)=[];
% structure_ID(target_volume<0.001)=[];
% target_volume(target_volume<0.001)=[];

x=inject_coord(:,1);
y=inject_coord(:,3);
z=inject_coord(:,2);

strenght_connection=(target_volume./inject_volume);
strenght_connection=strenght_connection/max(strenght_connection)*size_dots;

[structure_ID,x,y,z,strenght_connection]= brain_areas_cleaner(x,y,z,strenght_connection,structure_ID,levels_2_keep,delete_this_annotations,IDs,parent_ID,selected_area);



%%

plot_3d_brain_with_connectivity(x,y,z,strenght_connection,selected_area,structure_ID,IDs,av,st,colorxID_rgb,plot_right_only)


%% histogram

[~,II]=sort(strenght_connection,'descend');
aaa=structure_ID(II)';
strenght_connection=strenght_connection(II);

b=unique(aaa);

for ii=1:numel(b)
    
    idx=ismember(aaa,b(ii));
    
    if any(idx)
        list(ii,1)=b(ii);
       list(ii,2)=mean(strenght_connection(idx));
    else
        list(ii,1)=b(ii);
         list(ii,2)=strenght_connection(idx);
    end
end

[~,II]=sort(list(:,2),'descend');
list=list(II,:);



list_cell=num2cell(list);

for ii=1:numel(list(:,1))
    list_cell(ii,3)=acronym(IDs==list(ii,1));
    list_cell(ii,4)=full_name(IDs==list(ii,1));
     list_cell{ii,5}=colorxID_rgb(IDs==list(ii,1),:);
end

hh=figure
h=bar(1:length(list),list(:,2))
h.FaceColor = 'flat';
h.CData =  cell2mat(list_cell(:,5));
h.EdgeColor ='none';
ax=gca;
xticks(1:length(list(:,1)))
 nColors = length(list(:,1));
cm = cell2mat(list_cell(:,5));

for i = 1:nColors
ax.XTickLabel{i} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
cm(i,:), list_cell{i,3});
end

 xtickangle(0)
 box off
 view([90 -270])
 makepretty(1)
set(hh, 'Position', [0 0 200 800])
set(gca,'yscale','log')
 
