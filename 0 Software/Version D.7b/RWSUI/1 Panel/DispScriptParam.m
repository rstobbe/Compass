%=========================================================
% 
%=========================================================

function DispScriptParam(SCRPTipt,setfunc,tab,M)

global FIGOBJS
if strcmp(tab,'Ext')
    return
end
Select = FIGOBJS.(tab).Select;
Label = FIGOBJS.(tab).Label;
Entry = FIGOBJS.(tab).Entry;
PanelLengths = FIGOBJS.(tab).PanelLengths;

%--------------------------------------
% update all
%-------------------------------------- 
if setfunc == 1
    for m = 1:length(SCRPTipt)
        n = SCRPTipt(m).number;
        if isempty(n)
            Label(M,m).Visible = 'off';
            Entry(M,m).Visible = 'off';
            Select(M,m).Visible = 'off';
            break
        end
        userdata.entrystyle = SCRPTipt(m).entrystyle;
        userdata.entrystruct = SCRPTipt(m).entrystruct;
        Entry(M,n).UserData = userdata;
        Label(M,n).UserData = SCRPTipt(m).labelstyle;
        Select(M,n).UserData = SCRPTipt(m).selstyle;

        SetUpGlobal_B9(SCRPTipt(m).entrystyle,Entry(M,n),SCRPTipt(m).entrystr,SCRPTipt(m).entryvalue,'','');
        SetUpGlobal_B9(SCRPTipt(m).labelstyle,Label(M,n),SCRPTipt(m).labelstr,'','','');
        SetUpGlobal_B9(SCRPTipt(m).selstyle,Select(M,n),SCRPTipt(m).selstr,'',SCRPTipt(m).selfunction1,SCRPTipt(m).selfunction2);
    end
    for n = m+1:PanelLengths(M);
        Label(M,n).Visible = 'off';
        Entry(M,n).Visible = 'off';
        Select(M,n).Visible = 'off';
    end
    drawnow;
end
