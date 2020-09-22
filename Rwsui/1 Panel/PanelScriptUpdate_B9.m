%=========================================================
% 
%=========================================================

function PanelScriptUpdate_B9(Nchng,tab,panelnum)

Status('busy','');

global SCRPTIPTGBL

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
        altscrptfunc2 = 0;
        altscrptfunc3 = 0;
        if a == Nchng
            if strcmp(Current{m,2}{n,1}.entrytype,'Choose')
                Current{m,2}{n,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,1}.entrytype,'ScrptFunc')
                path = Current{m,2}{n,1}.path;
                [Func,~] = strtok(flipdim(path,2),filesep);
                Current{m,2}{n,1}.entrystr = flipdim(Func,2);
                Current{m,2}{n,1}.path = path;
                Current{m,2}(n,:) = GetSingleSubFunction_B9(Current{m,2}(n,:),tab,panelnum);
                altscrptfunc1 = 1;
                altscrptfunc2 = 1;
                altscrptfunc3 = 1;
                SCRPTIPTGBL.(tab)(panelnum).default{m,2}(n,:) = Current{m,2}(n,:);
            end
            Current{m,2}{n,1}.altval = 1;
        end 
        p = 0;
    elseif level == 3
        if not(altscrptfunc1 == 1)
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
                if strcmp(Current{m,2}{n,2}{p,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,1}.entryvalue = 0;
                elseif strcmp(Current{m,2}{n,2}{p,1}.entrytype,'ScrptFunc')
                    path = Current{m,2}{n,2}{p,1}.path;
                    [Func,~] = strtok(flipdim(path,2),filesep);
                    Current{m,2}{n,2}{p,1}.entrystr = flipdim(Func,2);
                    Current{m,2}{n,2}{p,1}.path = path;
                    Current{m,2}{n,2}(p,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}(p,:),tab,panelnum);
                    altscrptfunc2 = 1;
                    SCRPTIPTGBL.(tab)(panelnum).default{m,2}{n,2}(p,:) = Current{m,2}{n,2}(p,:);
                end
                Current{m,2}{n,2}{p,1}.altval = 1;
            elseif altscrptfunc1 == 1
                Current{m,2}{n,2}{p,1}.altval = 0;
            end
        end
        d = 0;
    elseif level == 4
        if not(altscrptfunc2 == 1)
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
            altscrptfunc3 = 0;
            if a == Nchng
                if strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,2}{d,1}.entryvalue = 0;
                elseif strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'ScrptFunc')
                    path = Current{m,2}{n,2}{p,2}{d,1}.path;
                    [Func,~] = strtok(flipdim(path,2),filesep);
                    Current{m,2}{n,2}{p,2}{d,1}.entrystr = flipdim(Func,2);
                    Current{m,2}{n,2}{p,2}{d,1}.path = path;
                    Current{m,2}{n,2}{p,2}(d,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}{p,2}(d,:),tab,panelnum);
                    altscrptfunc3 = 1;
                    SCRPTIPTGBL.(tab)(panelnum).default{m,2}{n,2}{p,2}(d,:) = Current{m,2}{n,2}{p,2}(d,:);
                end
                Current{m,2}{n,2}{p,2}{d,1}.altval = 1;
            elseif altscrptfunc1 == 1 || altscrptfunc2 == 1
                Current{m,2}{n,2}{p,2}{d,1}.altval = 0;
            end
        end
        e = 0;
    elseif level == 5
        if not(altscrptfunc2 == 1) && not(altscrptfunc3 == 1)
            e = e+1;
            Current{m,2}{n,2}{p,2}{d,2}{e,1} = SCRPTipt(a).entrystruct;
            Current{m,2}{n,2}{p,2}{d,2}{e,2} = cell(1);
            if isfield(Current{m,2}{n,2}{p,2}{d,2}{e,1},'altval')
                if Current{m,2}{n,2}{p,2}{d,2}{e,1}.altval == 1
                    if strcmp(Current{m,2}{n,2}{p,2}{d,2}{e,1}.entrytype,'Choose')
                        Current{m,2}{n,2}{p,2}{d,2}{e,1}.entryvalue = SCRPTipt(a).entryvalue; 
                    else
                        Current{m,2}{n,2}{p,2}{d,2}{e,1}.entrystr = SCRPTipt(a).entrystr;
                    end
                end
            end
            if a == Nchng
                if strcmp(Current{m,2}{n,2}{p,2}{d,2}{e,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,2}{d,2}{e,1}.entryvalue = 0;
                end
                Current{m,2}{n,2}{p,2}{d,2}{e,1}.altval = 1;
            elseif altscrptfunc1 == 1 || altscrptfunc2 == 1 || altscrptfunc3 == 1
                Current{m,2}{n,2}{p,2}{d,2}{e,1}.altval = 0;
            end
        end
    end
end

[SCRPTipt] = PanelRoutine(Current,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

Status('done','Edit Panel');
