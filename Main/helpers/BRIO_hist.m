function BRIO_hist(result,labels)

 result = struct2table(result);
 result = sortrows(result, 'projection_energy_normalized');
 result = table2struct( result);


hh=figure;
h=bar(1:length(result),[result.projection_energy_normalized]);
h.FaceColor = 'flat';
colors=[];

for qqq=1:numel(result)

colors=vertcat(colors, hex2rgb(result(qqq).hex));

end


h.CData = colors;
set(gca,'YScale','log')

h.EdgeColor ='none';

ylabel('Projection Energy')


if labels ==1
    
    
    for qqq = 1:numel(result)
        ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
            colors(qqq,:), char(result(qqq).name));
    end
    
    xticks([1:numel(result)])
    xtickangle(45)
    
else
    ax=gca;
    
    
    camroll(90)
     ax.YDir = 'reverse'
    xticklabels([])
    xticks([])
 
end




makepretty(1)

set(gca,'yscale','log')