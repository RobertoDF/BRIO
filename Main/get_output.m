function get_output(exp_id)
% if you want to combine two injections you have to manually combine the
% results in the next section and in this section you should  use this:
% [delete_this_annotations,levels_2_keep,selected_area,st,tv,av,...
%     colorxID_rgb,parent_ID,IDs,full_name,acronym,size_dots,plot_right_only]=get_ABA_data('input');

[delete_this_annotations,levels_2_keep,selected_area,st,tv,av,...
    colorxID_rgb,parent_ID,IDs,full_name,acronym,size_dots,plot_right_only]=get_ABA_data('output',exp_id);


%% OUTPUT

% download data from ABA

result = getProjectionDataFromExperiment(exp_id)

% you can combine multiple experiments do as follows:

% result = getProjectionDataFromExperiment(114472145)%0.35mm^3
% result2 = getProjectionDataFromExperiment(113226232)%0.55mm^3

% %normalize per injection volume

% inj_vol_1=0.35;
% inj_vol_2=0.55;
% ratio=1/(inj_vol_1/inj_vol_2);
% norm_projection_density=[result{1,1}.projection_density]*ratio;
% norm_projection_density=[norm_projection_density result2{1,1}.projection_density];
%  result {1} = [result{1} ,result2{1}];

%%

strenght_connection=[];
x=[result{1,1}.max_voxel_x]/10;
z=[result{1,1}.max_voxel_y]/10;
y=[result{1,1}.max_voxel_z]/10;
structure_ID=[result{1,1}.structure_id];


if exist ('norm_projection_density','var')
    
    strenght_connection=norm_projection_density*size_dots;
    
else
    
strenght_connection=([result{1,1}.projection_density])*size_dots; %sum of detected projection pixels / sum of all pixels in voxel

end

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
    
    if sum(idx)>1
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

