function BRIO_notboxplot(summary)

colors=[];
 y=[summary{:,3}];
    
    for qqq=1:numel(summary(:,1))
        
        colors=vertcat(colors, hex2rgb(summary{qqq,4}));
   
    end
    
    figure
    hold on
    for qqq=1:numel(summary(:,1))
        
        H=notBoxPlot(repmat(qqq,1,numel([summary{qqq,2}])),[summary{qqq,2}],'style','sdline','jitter',0.3);
        
        set([H.data],...
            'MarkerFaceColor', [colors(qqq,:) 0.2],...
            'markerEdgeColor', colors(qqq,:),  'MarkerSize', 4)
     
        set([H.sd],'Color',colors(qqq,:))
        
        set([H.semPtch],'FaceColor',colors(qqq,:) ,...
            'EdgeColor','none','FaceAlpha',0.5)
         
 set([H.mu],'color',colors(qqq,:))
 
        fprintf('*')
    end
    
    

    
    xticks([0:100:1000])
    set(gca,'xscale','log') 
    
XTickLabels = cellstr(num2str(round(log10(XTick(:))), '10^%d'));

 
 makepretty(1)

makepretty(1)