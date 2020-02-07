function result= prepare_result(result,st,descendents_seed,injection)
% get rid of annotation in injection region and not in grey matter


for qqq=1:numel(result)
    
    result(qqq).st_level=  st.st_level(st.id==result(qqq).structure_id) ;
    result(qqq).depth=st.depth(st.id==result(qqq).structure_id) ;
    result(qqq).hex=st.color_hex_triplet(st.id==result(qqq).structure_id);
    result(qqq).name=st.safe_name(st.id==result(qqq).structure_id);
    result(qqq).distance=norm([result(qqq).max_voxel_x result(qqq).max_voxel_y result(qqq).max_voxel_z]...
        - [injection.x injection.y injection.z]);
    
    %add  consolidated structure id field
    result(qqq).consolidated_structure_id =result(qqq).structure_id;
    
    result(qqq).consolidated_structure_id_general =result(qqq).structure_id;
end


%delete output points in the region of injection

to_delete=ismember([result.structure_id],descendents_seed.id)&[result.max_voxel_z]>400;

result(to_delete)=[];


fprintf('\n')

for qqq=1:numel(result)
    
    temp=getAllenStructureList('ancestorsOf' ,result(qqq).structure_id);
    
    % if the structure derive from either: fiber tracts, ventricular system, grooves or retina
    %>>>> assign structure_id=997
    
    if any(temp.id==1009|temp.id==73|temp.id==1024|temp.id==304325711)
        
        result(qqq).structure_id=997;% root
        
    end
    
    
    if mod(qqq,10)==0
        fprintf('*')
    end
    
    if mod(qqq,100)==0
        fprintf('\n')
    end
end

result([result.structure_id]==997)=[];
fprintf('\n DONE preparing results!')