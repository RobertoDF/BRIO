function plot_3d_brain_with_connectivity(x,y,z,strenght_connection,selected_area,structure_ID,IDs,av,st,colorxID_rgb, plot_right_only)

idx=ismember(st.id,selected_area);
%use it to plot 3d
selected_area_indexes=st.index(idx);


%delete areas that are indexed back to 0
x(structure_ID==0)=[];
y(structure_ID==0)=[];
z(structure_ID==0)=[];
strenght_connection(structure_ID==0)=[];
structure_ID(structure_ID==0)=[];

figure
bregma = allenCCFbregma();
isBrain = av>1; % >0 for original av, >1 for by_index
gridIn3D(double(isBrain), 0.5, 50, bregma);
axis vis3d
set(gca, 'ZDir', 'reverse')
axis equal
axis off
  view([-120    -220]);
set(gcf,'color','w');
hold on

for ii=1:numel(x)
    scatter3(x(ii),y(ii),z(ii),strenght_connection(ii) ...
        ,colorxID_rgb(IDs==structure_ID(ii),:),'filled')
end

%plot seed structure

 % Add structure(s) to display
        slice_spacing = 5;


        for ii = 1:numel(selected_area_indexes)
            
            curr_plot_structure=selected_area_indexes(ii);
            % If this label isn't used, don't plot
            if ~any(reshape(av( ...
                    1:slice_spacing:end,1:slice_spacing:end,1:slice_spacing:end),[],1) == curr_plot_structure)
                    disp(['"' st.safe_name{st.index==curr_plot_structure} '" is not parsed in the atlas'])
            else 
                 disp(['"' st.safe_name{st.index==curr_plot_structure} '" plotted successfully'])
              
            end

   
%             plot_structure_color = hex2dec(reshape(st.color_hex_triplet{curr_plot_structure},3,[]))./255;
            
            this=permute(av(1:slice_spacing:end, ...
            1:slice_spacing:end,1:slice_spacing:end) == curr_plot_structure,[3,1,2]);
        
        %only one side
        if plot_right_only == 'Yes'
         this(1:114,:,:)=0;
        end
            structure_3d = isosurface(this,0);

%         structure_alpha = 0.2;
%             gui_data.handles.structure_patch(end+1) = patch('Vertices',structure_3d.vertices*slice_spacing, ...
%                 'Faces',structure_3d.faces, ...
%                 'FaceColor',[0 0 0],'EdgeColor','none','FaceAlpha',structure_alpha);
         
%         
            structure_alpha = 0.2;
            patch('Vertices',structure_3d.vertices*slice_spacing, ...
                'Faces',structure_3d.faces, ...
                'FaceColor',[80/255 80/255 80/255],'EdgeColor','none','FaceAlpha',structure_alpha);
%             

        end
