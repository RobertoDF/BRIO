

function makepretty(nn)
% set some graphical attributes of the current axis

% set(get(gca, 'XLabel'), 'FontSize', 17);
% set(get(gca, 'YLabel'), 'FontSize', 17);
% set(gca, 'FontSize', 13);

set(get(gca, 'Title'), 'FontSize', 20);

ch = get(gca, 'Children');

for c = 1:length(ch)
    thisChild = ch(c);
    if strcmp('line', get(thisChild, 'Type')) 
        if strcmp('.', get(thisChild, 'Marker'))
            set(thisChild, 'MarkerSize', 15);
        end
        if strcmp('-', get(thisChild, 'LineStyle'))
            set(thisChild, 'LineWidth', nn);
        end
    end
end

set(gca,'TickDir','out'); % The only other option is 'in'
set(gcf,'color','w');
box off