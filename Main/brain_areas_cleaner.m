function result= brain_areas_cleaner(result,st,descendents_seed)


for qqq=1:numel(result)
    
  result(qqq).st_level=  st.st_level(st.id==result(qqq).structure_id) ;
  result(qqq).depth=st.depth(st.id==result(qqq).structure_id) ;
  result(qqq).hex=st.color_hex_triplet(st.id==result(qqq).structure_id);    
   result(qqq).name=st.safe_name(st.id==result(qqq).structure_id);    
  
end


%delete output points in the region of injection
  
to_delete=ismember([result.structure_id],descendents_seed.id)&[result.max_voxel_z]>400;

result(to_delete)=[]; 

