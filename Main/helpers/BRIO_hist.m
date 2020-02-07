function BRIO_hist(summary,labels)

colors=[];
if isstruct(summary)==1
    summary = struct2table(summary);
    summary = sortrows(summary, 'projection_energy_normalized');
    summary = table2struct( summary);
    y=[summary.projection_energy_normalized];
    
    for qqq=1:numel(summary)
        
        colors=vertcat(colors, hex2rgb(summary(qqq).hex));
        
    end
    
else
    
    y=[summary{:,3}];
    
    for qqq=1:numel(summary(:,1))
        
        colors=vertcat(colors, hex2rgb(summary{qqq,4}));
        errbar(qqq)=std(summary{qqq,2})/sqrt(numel(summary{qqq,2}));
    end
end

hh=figure('Position',[      2311          47         576         945]);
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

ylabel('log(Projection Energy)')

ax=gca;
camroll(90)
ax.YDir = 'reverse'


if labels ==1
    if isstruct(summary)==1
        
        for qqq = 1:numel(summary)
            if y(qqq)<1
                
                ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    colors(qqq,:), char(summary(qqq).name));
                
            else
                ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    [1 1 1], char(summary(qqq).name));
            end
        end
        
    else
        for qqq = 1:numel(summary(:,1))
            if y(qqq)<1
                text( qqq,y(qqq)+(errbar(qqq)*3),sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    colors(qqq,:), char(summary{qqq,5})),'FontWeight','bold')
            else
                text( qqq,y(1),sprintf('\\color[rgb]{%f,%f,%f}%s', ...
                    [1 1 1], char(summary{qqq,5})),'FontWeight','bold')
            end
        end
    end
    
    
    xticks([1:numel(summary)])
    
    xticklabels([])
    xticks([])
    set(gca,'yscale','log')
       ylim([0.00100000000000000,1000])
      yticklabels([-3:3])
    
else
    
    set(gca,'yscale','log')
    ylim([  1.00000000000000e-10,10000   ])
      yticklabels([-10:2:4])
    xticks([])
    
end

makepretty(1)

