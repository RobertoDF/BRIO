function BRIO_pie(summary,metric,threshold)

colors=[];

switch metric
    case 'projection_energy_normalized'
        summary = sortrows(summary, 7);
        y=[summary{:,7}];
        size_dots=10;
        
        y=y*size_dots;
    case 'projection_density_normalized'
        summary = sortrows(summary, 8);
        y=[summary{:,8}];
        size_dots=10000;
        
        
        y=y*size_dots;
        
    case 'projection_intensity_normalized'
        summary = sortrows(summary, 9);
        y=[summary{:,9}];
        size_dots=2;
        
        
        y=y*size_dots;
        
    case 'normalized_projection_volume'
        summary = sortrows(summary, 10);
        y=[summary{:,10}];
        size_dots=20;
        
        y=y*size_dots;
end

for qqq=1:numel(summary(:,1))
    
    colors=vertcat(colors, hex2rgb(summary{qqq,11}));
    
end



% delete if value less than one, pie gets messy

colors(y<threshold,:)=[];
summary((y<threshold),:)=[];
y(y<threshold)=[];

figure
ppp=pie(y,ones(numel(y),1),[summary{:,12}]);
colormap(colors)



for qqq = 2:2:numel(y)*2
    ppp(qqq).Color = colors(qqq/2,:);
    ppp(qqq).FontWeight='Bold';
end



% legend  (name,'Location','northeastoutside')

makepretty(1)