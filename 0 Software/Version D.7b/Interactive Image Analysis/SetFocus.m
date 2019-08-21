%============================================
% 
%============================================
function SetFocus(tab,axnum)

global IMAGEANLZ;

if strcmp(tab,'IM')
    arr = 1;
elseif strcmp(tab,'IM2')
    arr = [1 2];
elseif strcmp(tab,'IM3')
    arr = [1 2 3];
elseif strcmp(tab,'IM4')  
    arr = [1 2 3 4];
end
IMAGEANLZ.(tab)(axnum).Highlight;
inds = find(arr~=axnum);
for n = 1:length(inds)
    IMAGEANLZ.(tab)(arr(inds(n))).UnHighlight;
end
IMAGEANLZ.(tab)(axnum).SetFocus;
