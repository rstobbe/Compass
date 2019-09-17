%===================================================
% 
%===================================================
function ResetContrastFull(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Reset
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).InitializeContrast;
    IMAGEANLZ.(tab)(axnum).LoadContrast;
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    ContrastSettings = IMAGEANLZ.(tab)(axnum).InitializeContrast;          
    for r = 1:3
        IMAGEANLZ.(tab)(r).InitializeContrastSpecify(ContrastSettings);
        IMAGEANLZ.(tab)(r).LoadContrast;
    end
end