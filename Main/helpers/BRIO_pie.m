function BRIO_pie(summary)

colors=[];
 y=[summary{:,3}];
    
    for qqq=1:numel(summary(:,1))
        
        colors=vertcat(colors, hex2rgb(summary{qqq,4}));
   
    end


% delete if value less than one, pie gets messy
thr=1;

colors(y<thr,:)=[];
summary((y<thr),:)=[];
y(y<thr)=[];

figure
ppp=pie(y,ones(numel(y),1),[summary{:,5}]);
colormap(colors)



for qqq = 2:2:numel(y)*2
ppp(qqq).Color = colors(qqq/2,:);
ppp(qqq).FontWeight='Bold';
end



% legend  (name,'Location','northeastoutside')

makepretty(1)