%====================================================
%
%====================================================

function [CurrentScript,CurrentTree,AllTrees] = BuildInputTrees_B9(SCRPTipt,RWSUI)

i = zeros(1,3);
foundcurrent = 0;
Input = struct();
for a = 1:length(SCRPTipt)
    level = SCRPTipt(a).entrystruct.funclevel;
    if level == 1
        i(1) = i(1)+1;
        i(2) = 0;
    elseif level == 2
        i(2) = i(2)+1;
        i(3) = 0;
    elseif level == 3
        i(3) = i(3)+1;
        i(4) = 0;
    elseif level == 4
        i(4) = i(4)+1;
    end
    
    current = 1;
    for j = 1:length(RWSUI.treecellarray)
        if not(RWSUI.treecellarray(j) == i(j))
            current = 0;
            break
        end
    end
    if current == 1 && not(foundcurrent == 1)
        CurrentScript.Func = SCRPTipt(a).entrystr;
        CurrentScript.Struct = SCRPTipt(a).entrystruct;
        foundcurrent = 1;
        currentlevel = level;
    end
    
    type = SCRPTipt(a).entrystruct.entrytype;
    ind = strfind(SCRPTipt(a).labelstr,32);
    if not(isempty(ind))
        SCRPTipt(a).labelstr(ind) = '_';
    end
    ind = strfind(SCRPTipt(a).labelstr,'(');
    if not(isempty(ind))
        SCRPTipt(a).labelstr = SCRPTipt(a).labelstr(1:ind-2);
    end
    
    if level == 1
        M = a;
        if not(isfield(SCRPTipt(M).entrystruct,'scrpttype'))
            break
        end
        if isfield(Input,SCRPTipt(M).entrystruct.scrpttype)
            scrpttype = [SCRPTipt(M).entrystruct.scrpttype,'2'];               % scrpttype used for script differentiation in 'AllTrees'
            if isfield(Input,scrpttype)
                scrpttype = [SCRPTipt(M).entrystruct.scrpttype,'3'];
            end
        else
            scrpttype = SCRPTipt(M).entrystruct.scrpttype;
        end
        if M == RWSUI.treepanipt(1)
            curscrpttype = scrpttype;
        end
        Input.(scrpttype).Func = SCRPTipt(M).entrystr;
        Input.(scrpttype).Struct = SCRPTipt(M).entrystruct;   
    elseif level == 2
        N = a;
        if strcmp(type,'Space')
            % don't include
        elseif strcmp(type,'ScrptFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).Func = SCRPTipt(N).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).Struct = SCRPTipt(N).entrystruct;
        elseif strcmp(type,'RunExtFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).EntryStr = SCRPTipt(N).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).Struct = SCRPTipt(N).entrystruct;
        else
            if strcmp(type,'Choose');
                if iscell(SCRPTipt(N).entrystr)
                    entrystr = SCRPTipt(N).entrystr{SCRPTipt(N).entryvalue};
                else
                    entrystr = SCRPTipt(N).entrystr;
                end
            else
                entrystr = SCRPTipt(N).entrystr;
            end
            Input.(scrpttype).(SCRPTipt(N).labelstr) = entrystr;
            if current == 1 && level == currentlevel+1
                CurrentScript.(SCRPTipt(N).labelstr) = entrystr;
            end
        end
    elseif level == 3
        P = a;
        if strcmp(type,'ScrptFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).Func = SCRPTipt(P).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).Struct = SCRPTipt(P).entrystruct;
        elseif strcmp(type,'RunExtFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).EntryStr = SCRPTipt(P).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).Struct = SCRPTipt(P).entrystruct;
        else
            if strcmp(type,'Choose');
                if iscell(SCRPTipt(P).entrystr)
                    entrystr = SCRPTipt(P).entrystr{SCRPTipt(P).entryvalue};
                else
                    entrystr = SCRPTipt(P).entrystr;
                end
            else
                entrystr = SCRPTipt(P).entrystr;
            end
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr) = entrystr;
            if current == 1 && level == currentlevel+1
                CurrentScript.(SCRPTipt(P).labelstr) = entrystr;
            end
        end
    elseif level == 4
        D = a;
        if strcmp(type,'ScrptFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).Func = SCRPTipt(D).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).Struct = SCRPTipt(D).entrystruct;
        elseif strcmp(type,'RunExtFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).EntryStr = SCRPTipt(D).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).Struct = SCRPTipt(D).entrystruct;
        else
            if strcmp(type,'Choose');
                if iscell(SCRPTipt(D).entrystr)
                    entrystr = SCRPTipt(D).entrystr{SCRPTipt(D).entryvalue};
                else
                    entrystr = SCRPTipt(D).entrystr;
                end
            else
                entrystr = SCRPTipt(D).entrystr;
            end
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr) = entrystr;
            if current == 1 && level == currentlevel+1
                CurrentScript.(SCRPTipt(D).labelstr) = entrystr;
            end
        end
    elseif level == 5
        E = a;
        if strcmp(type,'ScrptFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).(SCRPTipt(E).labelstr).Func = SCRPTipt(E).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).(SCRPTipt(E).labelstr).Struct = SCRPTipt(E).entrystruct;
        elseif strcmp(type,'RunExtFunc')
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).(SCRPTipt(E).labelstr).EntryStr = SCRPTipt(E).entrystr;
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).(SCRPTipt(E).labelstr).Struct = SCRPTipt(E).entrystruct;
        else
            if strcmp(type,'Choose');
                if iscell(SCRPTipt(E).entrystr)
                    entrystr = SCRPTipt(E).entrystr{SCRPTipt(E).entryvalue};
                else
                    entrystr = SCRPTipt(E).entrystr;
                end
            else
                entrystr = SCRPTipt(E).entrystr;
            end
            Input.(scrpttype).(SCRPTipt(N).labelstr).(SCRPTipt(P).labelstr).(SCRPTipt(D).labelstr).(SCRPTipt(E).labelstr) = entrystr;
            if current == 1 && level == currentlevel+1
                CurrentScript.(SCRPTipt(E).labelstr) = entrystr;
            end
        end
    end    
end

CurrentTree = Input.(curscrpttype);
AllTrees = Input;

    
    

