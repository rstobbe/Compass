%===================================================
% 
%===================================================
function ContrastMaxval(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if isnan(str2double(src.String))
    return
end

if str2double(src.String) > IMAGEANLZ.(tab)(axnum).MAXCONTRAST
    if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
        IMAGEANLZ.(tab)(axnum).MAXCONTRAST = str2double(src.String);
        IMAGEANLZ.(tab)(axnum).SetContrast;        
    elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
        for n = 1:3
            IMAGEANLZ.(tab)(n).MAXCONTRAST = str2double(src.String);
            IMAGEANLZ.(tab)(n).SetContrast;
        end
    end
end
    
val = str2double(src.String)/IMAGEANLZ.(tab)(axnum).MAXCONTRAST;
IMAGEANLZ.(tab)(axnum).ChangeMaxContrast(val);

