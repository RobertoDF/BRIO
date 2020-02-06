function BRIO_pie(result)


 result = struct2table(result);
 result = sortrows(result, 'projection_energy_normalized');
 result = table2struct( result);

colors=[];
for qqq=1:numel(result)

colors=vertcat(colors, hex2rgb(result(qqq).hex));

end

name=[];
for qqq=1:numel(result)

name{qqq}=result(qqq).name;

end


% delete if value less than one, pie gets messy
thr=1;

y=[result.projection_energy_normalized]';
colors(y<thr,:)=[];
name(y<thr)=[];
y(y<thr)=[];

figure
ppp=pie(y,ones(numel(y),1),name);
colormap(colors)



for qqq = 2:2:numel(y)*2
ppp(qqq).Color = colors(qqq/2,:);
ppp(qqq).FontWeight='Bold';
end


% legend  (name,'Location','northeastoutside')

makepretty(1)