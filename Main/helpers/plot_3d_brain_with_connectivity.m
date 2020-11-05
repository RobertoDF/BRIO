function fig=plot_3d_brain_with_connectivity(result,descendents_seed,av,st,plot_right_only,metric)



fig=figure('Position',[201          38        1737         911])
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




for qqq=1:numel(result)
    
    switch metric
        
        case 'projection_energy_normalized'
            
            size_dots=10;
            
            color =hex2rgb(result(qqq).hex);
            scatter3(result(qqq).max_voxel_x/10,result(qqq).max_voxel_z/10,result(qqq).max_voxel_y/10,...
                result(qqq).projection_energy_normalized*size_dots ...
                ,color,'filled')
            
        case 'projection_density_normalized'
            
            
            size_dots=10000;
            
            
            color =hex2rgb(result(qqq).hex);
            scatter3(result(qqq).max_voxel_x/10,result(qqq).max_voxel_z/10,result(qqq).max_voxel_y/10,...
                result(qqq).projection_density_normalized*size_dots ...
                ,color,'filled')
        case 'projection_intensity_normalized'
            
            size_dots=1;
            
            
            color =hex2rgb(result(qqq).hex);
            scatter3(result(qqq).max_voxel_x/10,result(qqq).max_voxel_z/10,result(qqq).max_voxel_y/10,...
                result(qqq). projection_intensity_normalized*size_dots ...
                ,color,'filled')
        case 'normalized_projection_volume'
            size_dots=600;
            color =hex2rgb(result(qqq).hex);
            scatter3(result(qqq).max_voxel_x/10,result(qqq).max_voxel_z/10,result(qqq).max_voxel_y/10,...
                result(qqq). normalized_projection_volume*size_dots ...
                ,color,'filled')
    end
    
end


%plot seed structure

% Add structure(s) to display
slice_spacing = 5;

for qqq = 1:numel(descendents_seed(:,1))
    
    curr_plot_structure=descendents_seed.graph_order(qqq);
    
    % If this label isn't used, don't plot
    if ~any(reshape(av( ...
            1:slice_spacing:end,1:slice_spacing:end,1:slice_spacing:end),[],1) == curr_plot_structure)
        disp(['"' st.safe_name{st.graph_order==curr_plot_structure} '" is not parsed in the atlas'])
    else
        disp(['"' st.safe_name{st.graph_order==curr_plot_structure} '" plotted successfully'])
        
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
        'FaceColor',[120/255 120/255 120/255],'EdgeColor','none','FaceAlpha',structure_alpha);
    %
    
end

%% scale cirles

switch metric
    
    case 'projection_energy_normalized'
        
        
        scatter3(1,1,1,200*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,150,20*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,200,2*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
    case 'projection_density_normalized'
        
        
        scatter3(1,1,1,0.2*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,150,0.02*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,200,0.002*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
    case 'projection_intensity_normalized'
        
        scatter3(1,1,1,2000*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,150,200*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,200,20*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
    case 'normalized_projection_volume'
        scatter3(1,1,1,7*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,150,0.7*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
        
        scatter3(1,1,200,0.07*size_dots, ...
            'MarkerFaceColor','w','MarkerEdgeColor','black')
end
