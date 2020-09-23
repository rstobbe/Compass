%===================================================
%
%===================================================
function UpdateOrthoSlices(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if isempty(IMAGEANLZ.(tab)(axnum).buttonfunction)
    IMAGEANLZ.(tab)(axnum).movefunction = 'UpdateOrthoSlices';
    IMAGEANLZ.(tab)(axnum).buttonfunction = 'UpdateOrthoSlices';
    set(gcf,'pointer','circle');
    IMAGEANLZ.(tab)(axnum).pointer = 'circle';
else
    IMAGEANLZ.(tab)(axnum).movefunction = '';
    IMAGEANLZ.(tab)(axnum).buttonfunction = '';
    set(gcf,'pointer','arrow');
    IMAGEANLZ.(tab)(axnum).pointer = 'arrow';
end
    