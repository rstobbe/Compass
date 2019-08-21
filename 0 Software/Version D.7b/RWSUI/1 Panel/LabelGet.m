%=========================================================
% 
%=========================================================

function [panelipt] = LabelGet(tab,M)

global FIGOBJS
Select = FIGOBJS.(tab).Select;
Label = FIGOBJS.(tab).Label;
Entry = FIGOBJS.(tab).Entry;

panelipt = struct();
p = 1;
for n = 1:FIGOBJS.(tab).PanelLengths(M)
    if strcmp(Label(M,n).Visible,'off')
        continue
    end
    panelipt(p).number = n;
    panelipt(p).entrystyle = Entry(M,n).UserData.entrystyle;
    panelipt(p).entrystruct = Entry(M,n).UserData.entrystruct; 
    panelipt(p).entrystr = Entry(M,n).String;
    panelipt(p).entryvalue = Entry(M,n).Value;
    panelipt(p).labelstyle = Label(M,n).UserData;
    panelipt(p).labelstr = Label(M,n).String;
    panelipt(p).selstyle = Select(M,n).UserData;
    panelipt(p).selstr = Select(M,n).String;
    panelipt(p).selfunction1 = Select(M,n).Callback;
    panelipt(p).selfunction2 = Select(M,n).ButtonDownFcn; 
    p = p+1;
end
