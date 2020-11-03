function BRIO_distance(result,summary,st,metric)


result = struct2table(result);
result = sortrows(result, 'distance');
result = table2struct( result);

colors=[];


for qqq=1:numel(result)
    
    colors=vertcat(colors, hex2rgb(result(qqq).hex));
    %     colors=vertcat(colors, hex2rgb(st.color_hex_triplet([st.id]==result(qqq).consolidated_structure_id_general)));
    
end


switch metric
    case 'projection_energy_normalized'
        y=log10([result.projection_energy_normalized ]);
    case 'projection_density_normalized'
        y=log10([result.projection_density_normalized ]);
    case 'projection_intensity_normalized'
        y=log10([result.projection_intensity_normalized ]);
    case 'normalized_projection_volume'
        y=log10([result.normalized_projection_volume ]);
end


x=[result.distance]/10;%µm


figure('Position',[      231          47         576         945]);

scatter(x,y,20,colors,'filled','MarkerEdgeColor' ,'none')

xlabel('Distance (µm)')

switch metric
    case 'projection_energy_normalized'
       ylabel('log(Projection energy)')
    case 'projection_density_normalized'
       ylabel('log(Projection density)')
    case 'projection_intensity_normalized'
        ylabel('log(Projection intensity)')
    case 'normalized_projection_volume'
       ylabel('log(Projection volume)')
end


makepretty(1)



hold on

%
% %add regression general
%
% p = polyfit(x,y,2);
% y1 = polyval(p,x);
% plot(x,y1,'LineWidth',2,'Color',[0 0 0])
%


order=[695 703 623 1129 313 1065 512];


% all main structures regression
n=1;
for qqq=order
    
    idx=([result.consolidated_structure_id_general]==qqq);
    if sum(idx)>0
    p = polyfit(x(idx),y(idx),2);
    y1 = polyval(p,x(idx));
    
    ind=[summary{:,2}]==qqq;
    color=summary{ind,13};
    
    ppp(n)= plot(x(idx),y1,'LineWidth',4,'Color',hex2rgb(color));
    
    names{n}=char(st.safe_name([st.id]==qqq));
    
    
    n=n+1;
    end
end
leg=legend(ppp);

leg.String=names;
leg.Box='Off';


xticks([0:200:1000])


ylim([-6 Inf])



%%
try
    
figure('Position',[      231          50         900         900]);

for q=1:4
    
    subplot(2,2,q)
  list = {'projection_energy_normalized','projection_density_normalized','projection_intensity_normalized',...                   
'normalized_projection_volume'};

metric=char(list(q))

switch metric
    case 'projection_energy_normalized'
        y=log10([result.projection_energy_normalized ]);
    case 'projection_density_normalized'
        y=log10([result.projection_density_normalized ]);
    case 'projection_intensity_normalized'
        y=log10([result.projection_intensity_normalized ]);
    case 'normalized_projection_volume'
        y=log10([result.normalized_projection_volume ]);
end


x=[result.distance]/10;%µm



scatter(x,y,20,colors,'filled','MarkerEdgeColor' ,'none')

xlabel('Distance (µm)')

switch metric
    case 'projection_energy_normalized'
       ylabel('log(Projection energy)')
    case 'projection_density_normalized'
       ylabel('log(Projection density)')
    case 'projection_intensity_normalized'
        ylabel('log(Projection intensity)')
    case 'normalized_projection_volume'
       ylabel('log(Projection volume)')
end


makepretty(1)



hold on

%
% %add regression general
%
% p = polyfit(x,y,2);
% y1 = polyval(p,x);
% plot(x,y1,'LineWidth',2,'Color',[0 0 0])
%


order=[695 703 623 1129 313 1065 512];


% all main structures regression
n=1;
for qqq=order
    
    idx=([result.consolidated_structure_id_general]==qqq);
    if sum(idx)>0
    p = polyfit(x(idx),y(idx),2);
    y1 = polyval(p,x(idx));
    
    ind=[summary{:,2}]==qqq;
    color=summary{ind,13};
    
    ppp(n)= plot(x(idx),y1,'LineWidth',4,'Color',hex2rgb(color));
    
    names{n}=char(st.safe_name([st.id]==qqq));
    
    
    n=n+1;
    end
end
leg=legend(ppp);

leg.String=names;
leg.Box='Off';


xticks([0:200:1000])

ylim([-6 Inf])

end
catch
    close

end


