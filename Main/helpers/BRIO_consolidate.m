function result_processed=BRIO_consolidate(result,st)

result_processed=result;

    % reassign structure_id

for qqq=1:numel(result_processed)
    
    temp=getAllenStructureList('ancestorsOf' ,result_processed(qqq).structure_id);
    

     %DELETE imprecise annotations 
     
 
         if result_processed(qqq).depth<2
              result_processed(qqq).structure_id=nan;
         end
         
          
     % if the structure derive from : Cerebrum>>>> DELETE imprecise
     % annotations (I´ll do the same for each category)
     
    if any(temp.id==567)
        
         if result_processed(qqq).depth<4
              result_processed(qqq).structure_id=nan;
         end
         
    end

    %bring all to level 6
    if result(qqq).depth>6
        
        result_processed(qqq).structure_id=temp.id(temp.depth==6);
    end
    
    
     % if the structure derive from : Cortical plate>>>> DELETE imprecise
     % annotations (I´ll do the same for each category)
     
    if any(temp.id==695)
        
         if result_processed(qqq).depth<6
              result_processed(qqq).structure_id=nan;
         end
         
    end

    % if the structure derive from either: Hindbrain, Interbrain, Cerebral
    % Nuclei, Cortical subplate>>>> bring to level 4
    
    if any(temp.id==1065|temp.id==1129|temp.id==623|temp.id==703)
        
        result_processed(qqq).structure_id=temp.id(temp.depth==4);
        
         if result_processed(qqq).depth<4
              result_processed(qqq).structure_id=nan;
         end
      
    end
    
    % if the structure derive from : Olfactory areas>>>> bring to
    % level 5
    if any(temp.id==698)
        
        result_processed(qqq).structure_id=temp.id(temp.depth==5);
        
            if result_processed(qqq).depth<5
              result_processed(qqq).structure_id=nan;
         end
    end
    
      % if the structure derive from : Midbrain>>>> bring to
    % level 3
    if any(temp.id==313)
        
        result_processed(qqq).structure_id=temp.id(temp.depth==3);
        
          if result_processed(qqq).depth<3
              result_processed(qqq).structure_id=nan;
         end
        
    end
    
      % if the structure derive from : Cerebellum>>>> bring to
    % level 2
    if any(temp.id==512)
        
        result_processed(qqq).structure_id=temp.id(temp.depth==2);
        
        if result_processed(qqq).depth<2
              result_processed(qqq).structure_id=nan;
         end
    end
    
    
    % assign NaN if annotation is imprecise
    if isempty( result_processed(qqq).structure_id)==1
        result_processed(qqq).structure_id=nan;
    end
    
    
    if mod(qqq,10)==0
        fprintf('*')
    end
    
    if mod(qqq,100)==0
        fprintf('\n')
    end
end




% if the structure annotation is inprecise
%>>>> DELETE
%for some reasons nan are converted to zeros
result_processed([result_processed.structure_id]==0)=[];
      
      
%average projection density for points in the same structure

for qqq=1:numel(result_processed)
    
    if sum([result_processed.structure_id]==result_processed(qqq).structure_id)>1
        

        result_processed(qqq).normalized_projection_volume=mean([result_processed([result_processed.structure_id]...
          ==result_processed(qqq).structure_id).normalized_projection_volume]);
        
    end
    
    if mod(qqq,10)==0
        fprintf('*')
    end
    if mod(qqq,100)==0
        fprintf('\n')
    end
end

%delete doubles

[~,I ] = unique([result_processed.structure_id]);
result_processed=result_processed(I);

for qqq=1:numel(result_processed)
    
   result_processed(qqq).name=st.safe_name(st.id==  result_processed(qqq).structure_id);    
  
end