function [summary,result]=BRIO_consolidate(result,st)
% in result_processed structure_id is

% reassign structure_id

for qqq=1:numel(result)
    
    temp=getAllenStructureList('ancestorsOf' ,result(qqq).structure_id);
    
    
    %DELETE imprecise annotations
    
    if result(qqq).depth<3
        result(qqq).structure_id=0;
        result(qqq).consolidated_structure_id=0;%assign zero as no stucture_id==0
        
    end
    
    
    % if the structure derive from : Cerebrum>>>> DELETE imprecise
    % annotations (I´ll do the same for each category)
    
    if any(temp.id==567)
        
        if result(qqq).depth<4
            result(qqq).structure_id=0;
            result(qqq).consolidated_structure_id=0;
            result(qqq).consolidated_structure_id_general =0;
        end
        
    end
    
    %bring all to level 6
    if result(qqq).depth>6
        
        result(qqq).consolidated_structure_id=temp.id(temp.depth==6);
        result(qqq).consolidated_structure_id_general=temp.id(temp.depth==6);
        
    end
    
    
    % if the structure derive from : Cortical plate>>>> DELETE imprecise
    % annotations (I´ll do the same for each category)
    
    if any(temp.id==695)
        
        if result(qqq).depth<6
            result(qqq).structure_id=0;
            result(qqq).consolidated_structure_id=0;
            result(qqq).consolidated_structure_id_general =0;
        end
        
    end
    
    % if the structure derive from : Cerebral cortex>>>> bring to level 4
    
    if any(temp.id==688)
        
        result(qqq).consolidated_structure_id_general=temp.id(temp.depth==4);
        
    end
    
    
    
    % if the structure derive from either: Hindbrain, Interbrain, Cerebral
    % Nuclei, Cortical subplate>>>> bring to level 4 and 3
    
    if any(temp.id==1065|temp.id==1129|temp.id==623|temp.id==703)
        
        result(qqq).consolidated_structure_id=temp.id(temp.depth==4);
        result(qqq).consolidated_structure_id_general =temp.id(temp.depth==3);
        
        if result(qqq).depth<4
            result(qqq).structure_id=0;
            result(qqq).consolidated_structure_id=0;
            result(qqq).consolidated_structure_id_general =0;
        end
        
    end
    
    % if the structure derive from either: Hindbrain, Interbrain, Cerebral
    % Nuclei, Cortical subplate>>>> bring to level 4
    
    if any(temp.id==703)
        
        
        result(qqq).consolidated_structure_id_general =temp.id(temp.depth==4);
        
        
    end
    
    
    % if the structure derive from : Olfactory areas>>>> bring to
    % level 5
    if any(temp.id==698)
        
        result(qqq).consolidated_structure_id=temp.id(temp.depth==5);
        
        
    end
    
    % if the structure derive from : Midbrain>>>> bring to
    % level 3
    if any(temp.id==313)
        
        result(qqq).consolidated_structure_id=temp.id(temp.depth==3);
        result(qqq).consolidated_structure_id_general =temp.id(temp.depth==3);
        
        
        if result(qqq).depth<3
            result(qqq).structure_id=0;
            result(qqq).consolidated_structure_id=0;
            result(qqq).consolidated_structure_id_general =0;
        end
        
    end
    
    % if the structure derive from : Cerebellum>>>> bring to
    % level 2
    if any(temp.id==512)
        
        result(qqq).consolidated_structure_id=temp.id(temp.depth==2);
        
        result(qqq).consolidated_structure_id_general =temp.id(temp.depth==2);
        
        if result(qqq).depth<2
            result(qqq).structure_id=0;
            result(qqq).consolidated_structure_id=0;
            result(qqq).consolidated_structure_id_general =0;
        end
    end
    
    
    % assign 0 if annotation is imprecise
    if isempty( result(qqq).structure_id)==1
        result(qqq).structure_id=0;
        result(qqq).consolidated_structure_id=0;
        result(qqq).consolidated_structure_id_general =0;
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
result([result.structure_id]==0)=[];


%create new field with annotations divided by group

[II,I ] = unique([result.consolidated_structure_id]);

nn=1;
for qqq=II
    
    ind=find([result.consolidated_structure_id]==qqq);
    summary{nn,1}=result(ind(1)).consolidated_structure_id;
    summary{nn,6}=result(ind(1)).consolidated_structure_id_general;
    n=1;
    for www=ind
        
        summary{nn,2}(n,1)=result(www).projection_energy_normalized;
        n=n+1;
        
    end
    nn=nn+1;
    if mod(qqq,10)==0
        fprintf('*')
    end
    if mod(qqq,100)==0
        fprintf('\n')
    end
end


for qqq=1:numel(summary(:,1))
    
    summary{qqq,3}=mean([ summary{qqq,2}]);%mean
    summary{qqq,4}=st.color_hex_triplet(st.id== summary{qqq,1});   %color consolidated structure
    summary{qqq,5}=st.safe_name(st.id== summary{qqq,1});   %name
    summary{qqq,7}=st.color_hex_triplet(st.id== summary{qqq,6});   %color consolidated_general structure
end

summary = sortrows(summary, [3]);
fprintf('\n DONE consolidating!')
