function BRIO_distance(result,summary)


   result = struct2table(result);
    result = sortrows(result, 'projection_energy_normalized');
    result = table2struct( result);
    
colors=[];

    
    for qqq=1:numel(result)
        
        colors=vertcat(colors, hex2rgb(result(qqq).hex));
   
    end

   x=log10([result.projection_energy_normalized ]);
 y=[result.distance]/10;%µm
 
 
figure

sss=scatter(x,y,30,colors,'filled')

 
ylabel('Distance (µm)')
xlabel('log(Projection energy)')
makepretty(1)

hold on

%add regression

for qqq=1:numel()
p = polyfit(x,y,2);
y1 = polyval(p,x);
plot(x,y1)
end


for qqq = 2:2:numel(y)*2
ppp(qqq).Color = colors(qqq/2,:);
ppp(qqq).FontWeight='Bold';
end



% legend  (name,'Location','northeastoutside')

makepretty(1)