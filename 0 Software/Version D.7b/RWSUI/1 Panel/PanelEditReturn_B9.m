%=========================================================
% 
%=========================================================

function PanelEditReturn_B9(Nchng,tab,panelnum)

global SCRPTIPTGBL
Default = SCRPTIPTGBL.(tab)(panelnum).default;

[SCRPTipt] = LabelGet(tab,panelnum);

m = 0;
for a = 1:length(SCRPTipt)
    level = SCRPTipt(a).entrystruct.funclevel;
    if level == 1
        m = m+1;
        Current{m,1} = SCRPTipt(a).entrystruct;
        n = 0;
    elseif level == 2
        if strcmp(SCRPTipt(a).entrystruct.entrytype,'Space')
            continue
        end
        n = n+1;
        Current{m,2}{n,1} = SCRPTipt(a).entrystruct;
        Current{m,2}{n,2} = cell(1);
        if isfield(Current{m,2}{n,1},'altval')
            if Current{m,2}{n,1}.altval == 1
                if strcmp(Current{m,2}{n,1}.entrytype,'Choose')
                    Current{m,2}{n,1}.entryvalue = SCRPTipt(a).entryvalue; 
                else
                    Current{m,2}{n,1}.entrystr = SCRPTipt(a).entrystr;
                end
            end
        end      
        altscrptfunc1 = 0;
        if a == Nchng
            Current{m,2}{n,1}.altval = 0;
            Current{m,2}{n,1} = Default{m,2}{n,1};
            if strcmp(Current{m,2}{n,1}.entrytype,'Choose')
                Current{m,2}{n,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,1}.entrytype,'ScrptFunc')
                altscrptfunc1 = 1;
            end
        end
        p = 0;
    elseif level == 3
        p = p+1;
        Current{m,2}{n,2}{p,1} = SCRPTipt(a).entrystruct;
        Current{m,2}{n,2}{p,2} = cell(1);
        if isfield(Current{m,2}{n,2}{p,1},'altval')
            if Current{m,2}{n,2}{p,1}.altval == 1
                if strcmp(Current{m,2}{n,2}{p,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,1}.entryvalue = SCRPTipt(a).entryvalue; 
                else
                    Current{m,2}{n,2}{p,1}.entrystr = SCRPTipt(a).entrystr;
                end
            end
        end       
        altscrptfunc2 = 0;
        if a == Nchng
            Current{m,2}{n,2}{p,1}.altval = 0;
            Current{m,2}{n,2}{p,1} = Default{m,2}{n,2}{p,1};
            if strcmp(Current{m,2}{n,2}{p,1}.entrytype,'Choose')
                Current{m,2}{n,2}{p,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,2}{p,1}.entrytype,'ScrptFunc')
                altscrptfunc2 = 1;
            end
        elseif altscrptfunc1 == 1
            Current{m,2}{n,2}{p,1}.altval = 0;
        end
        d = 0;
    elseif level == 4
        d = d+1;
        Current{m,2}{n,2}{p,2}{d,1} = SCRPTipt(a).entrystruct;
        Current{m,2}{n,2}{p,2}{d,2} = cell(1);
        if isfield(Current{m,2}{n,2}{p,2}{d,1},'altval')
            if Current{m,2}{n,2}{p,2}{d,1}.altval == 1
                if strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,2}{d,1}.entryvalue = SCRPTipt(a).entryvalue; 
                else
                    Current{m,2}{n,2}{p,2}{d,1}.entrystr = SCRPTipt(a).entrystr;
                end
            end
        end       
        altscrptfunc2 = 0;
        if a == Nchng
            Current{m,2}{n,2}{p,2}{d,1}.altval = 0;
            Current{m,2}{n,2}{p,2}{d,1} = Default{m,2}{n,2}{p,2}{d,1};
            if strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'Choose')
                Current{m,2}{n,2}{p,2}{d,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'ScrptFunc')
                altscrptfunc2 = 1;
            end
        elseif altscrptfunc1 == 1
            Current{m,2}{n,2}{p,2}{d,1}.altval = 0;
        end
        e = 0; 
    elseif level == 5
        e = e+1;
        Current{m,2}{n,2}{p,2}{d,2}{e,1} = SCRPTipt(a).entrystruct;
        Current{m,2}{n,2}{p,2}{d,2}{e,2} = cell(1);
        altscrptfunc3 = 0;
        if a == Nchng
            Current{m,2}{n,2}{p,2}{d,2}{e,1}.altval = 0;
            Current{m,2}{n,2}{p,2}{d,2}{e,1} = Default{m,2}{n,2}{p,2}{d,2}{e,1};
            if strcmp(Current{m,2}{n,2}{p,2}{d,2}{e,1}.entrytype,'Choose')
                Current{m,2}{n,2}{p,2}{d,2}{e,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,2}{p,2}{d,2}{e,1}.entrytype,'ScrptFunc')
                altscrptfunc3 = 1;
            end
        elseif altscrptfunc1 == 1 || altscrptfunc2 == 1
            Current{m,2}{n,2}{p,2}{d,2}{e,1}.altval = 0;
        end
    end
end

[SCRPTipt] = PanelRoutine(Current,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

