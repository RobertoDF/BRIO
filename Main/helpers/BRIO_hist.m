function BRIO_hist(summary,labels_on,metric)

colors=[];

%ugly way to understand input, to be changed
if isstruct(summary)==1
    summary = struct2table(summary);
    
    summary = sortrows(summary, metric);
    
    summary = table2struct( summary);
    
    switch metric
        case 'projection_energy_normalized'
            y=[summary.projection_energy_normalized];
        case 'projection_density_normalized'
            y=[summary.projection_density_normalized];
        case 'projection_intensity_normalized'
            y=[summary.projection_intensity_normalized];
        case 'normalized_projection_volume'
            y=[summary.normalized_projection_volume];
    end
    for qqq=1:numel(summary)
        
        
        colors=vertcat(colors, hex2rgb(summary(qqq).hex));
        
    end
    
else
    
    switch metric
        case 'projection_energy_normalized'
            summary = sortrows(summary, [7]);
            y=[summary{:,7}];
        case 'projection_density_normalized'
            summary = sortrows(summary, [8]);
            y=[summary{:,8}];
        case 'projection_intensity_normalized'
            summary = sortrows(summary, [9]);
            y=[summary{:,9}];
        case 'normalized_projection_volume'
            summary = sortrows(summary, [10]);
            y=[summary{:,10}];
    end
    
    
    for qqq=1:numel(summary(:,1))
        
        colors=vertcat(colors, hex2rgb(summary{qqq,11}));
        
        switch metric
            case 'projection_energy_normalized'
                errbar(qqq)=std(summary{qqq,3})/sqrt(numel(summary{qqq,3}));
            case 'projection_density_normalized'
                errbar(qqq)=std(summary{qqq,4})/sqrt(numel(summary{qqq,4}));
            case 'projection_intensity_normalized'
                errbar(qqq)=std(summary{qqq,5})/sqrt(numel(summary{qqq,5}));
            case 'normalized_projection_volume'
                errbar(qqq)=std(summary{qqq,6})/sqrt(numel(summary{qqq,6}));
        end
        
    end
end

hh=figure('Position',[      231          47         576         945]);
h=bar(1:numel(summary(:,1)),y);
hold on

if isstruct(summary)==0
    for qqq=1:numel(summary(:,1))
        er = errorbar(qqq,y(qqq), [],errbar(qqq));
        er.Color = colors(qqq,:);
        er.LineStyle = 'none';
        er.LineWidth=1;
    end
end


h.FaceColor = 'flat';

h.CData = colors;


h.EdgeColor ='none';


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

ax=gca;
camroll(90)
ax.YDir = 'reverse'
set(gca,'yscale','log')

yl=ylim;
half=(yl(2)-yl(1))/80;
if labels_on==1
    if isstruct(summary)==1
        
        for qqq = 1:numel(summary)
            if y(qqq)<half
                
                ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    colors(qqq,:), char(summary(qqq).name));
                
            else
                ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    [1 1 1], char(summary(qqq).name));
            end
        end
        
    else
        for qqq = 1:numel(summary(:,1))
            if y(qqq)<half
                text( qqq,y(qqq)+(errbar(qqq)*3),sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    colors(qqq,:), char(summary{qqq,12})),'FontWeight','bold')
            else
                text( qqq,y(1),sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    [1 1 1], char(summary{qqq,12})),'FontWeight','bold')
            end
        end
    end
    
    
    xticks([1:numel(summary)])
    
    xticklabels([])
    xticks([])
    
    %     ylim([0.00100000000000000,1000])
    %     yticklabels([-3:3])
    
else
    
    
    %     ylim([  1.00000000000000e-10,10000   ])
    %     yticklabels([-10:2:4])
    xticks([])
    
end

makepretty(1)

