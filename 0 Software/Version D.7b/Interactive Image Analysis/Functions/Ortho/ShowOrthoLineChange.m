%===================================================
%
%===================================================
function ShowOrthoLineChange(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
    IMAGEANLZ.(tab)(n).ShowOrthoLine(src.Value); 
end

DrawOrthoLines(tab);


