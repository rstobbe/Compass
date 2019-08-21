function OptionsACC_TOTALGBL(Control,Action)

%--------------------------------------------------
% Input
%--------------------------------------------------
val = Control.Value;
if isempty(val)
    return
end
for n = 1:length(val)
    totgblnum(n) = Control.UserData(val(n)).totgblnum;
end

%--------------------------------------------------
% Options
%--------------------------------------------------
[s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Delete Selected','Delete All'});
if isempty(s)
    return
end
switch s
    case 1
        for n = 1:length(totgblnum)
            Delete_TOTALGBL(totgblnum(n));
        end
    case 2
        DeleteAll_TOTALGBL;
end

