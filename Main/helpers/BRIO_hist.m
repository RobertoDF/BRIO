function BRIO_hist(result,legend)

 result = struct2table(result);
 result = sortrows(result, 'projection_energy');
 result = table2struct( result);


hh=figure;
h=bar(1:length(result),[result.projection_energy]);
h.FaceColor = 'flat';
colors=[];

for qqq=1:numel(result)

colors=vertcat(colors, hex2rgb(result(qqq).hex));

end


h.CData = colors;
set(gca,'YScale','log')

h.EdgeColor ='none';

ylabel('Projection Energy')


if legend ==1
ax=gca;

for qqq = 1:numel(result)
ax.XTickLabel{qqq} = sprintf('\\color[rgb]{%f,%f,%f}%s', ...
colors(qqq,:), char(result(qqq).name));
end

xticks([1:numel(result)])
xtickangle(45)

else
    
xticklabels([])
xticks([])
end


ax.YDir = 'reverse'
camroll(-90)


makepretty(1)

set(gca,'yscale','log')