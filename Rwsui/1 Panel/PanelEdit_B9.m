%=========================================================
% 
%=========================================================

function PanelEdit_B9(treepanipt,curpanipt,treecellarray,tab,panelnum)

global SCRPTIPTGBL
global SCRPTGBL

%---------------------------------------------
% Clear Naming
%---------------------------------------------
[SCRPTipt] = LabelGet(tab,panelnum);
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(indnum < curpanipt);
end
if not(isempty(indnum))
    for n = 1:length(indnum)
        SCRPTipt(indnum(n)).entrystruct.entrystr = '';
    end
end

if treepanipt(2) == 0
    RWSUI.callingfuncs = '';
elseif treepanipt(3) == 0
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr};
elseif treepanipt(4) == 0
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr,SCRPTipt(treepanipt(3)).labelstr};
else
    %error;      % not supported
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr,SCRPTipt(treepanipt(3)).labelstr,SCRPTipt(treepanipt(4)).labelstr};
end
RWSUI.funclabel = SCRPTipt(curpanipt).labelstr;

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
        if a == curpanipt
            if strcmp(Current{m,2}{n,1}.entrytype,'Choose')
                Current{m,2}{n,1}.entryvalue = 0;
            elseif strcmp(Current{m,2}{n,1}.entrytype,'ScrptFunc')
                if isfield(Current{m,2}{n,1},'path')
                    if not(exist(Current{m,2}{n,1}.path,'dir'))
                        path = which([Current{m,2}{n,1}.entrystr,'.m']);
                        if not(isempty(path))
                            ind = strfind(path,'\');
                            path = path(1:ind(end));
                        end
                        Current{m,2}{n,1}.path = path;
                    end
                    func = str2func(Current{m,2}{n,1}.entrystr);
                    try
                        test = func();
                        [file,path] = uigetfile(Current{m,2}{n,1}.path,'Select Function');
                    catch
                        file = 0;
                        path = uigetdir(Current{m,2}{n,1}.path,'Select Function');
                    end
                else
                    error;   % delete case
                    path = uigetdir(Current{m,2}{n,1}.searchpath,'Select Function');
                end
                if path == 0
                    Status2('done','Function Not Selected',1);
                    return
                end
                if file == 0
                    [Func,~] = strtok(flipdim(path,2),filesep);
                    Current{m,2}{n,1}.entrystr = flipdim(Func,2);
                    Current{m,2}{n,1}.path = path;
                    Current{m,2}(n,:) = GetSingleSubFunction_B9(Current{m,2}(n,:),tab,panelnum);
                else
                    Current{m,2}{n,1}.entrystr = strtok(file,'.');
                    Current{m,2}{n,1}.path = path;
                    Current{m,2}(n,:) = GetSingleSubFunction_B9(Current{m,2}(n,:),tab,panelnum);
                end
                altscrptfunc1 = 1;
                altscrptfunc2 = 1;
                altscrptfunc3 = 1;   
                SCRPTIPTGBL.(tab)(panelnum).default{m,2}(n,:) = Current{m,2}(n,:);
                if not(isempty(SCRPTGBL.(tab){panelnum,treecellarray(1)}))
                    if isfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']))
                        SCRPTGBL.(tab){panelnum,treecellarray(1)} = rmfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']));
                    end
                end
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
            altscrptfunc3 = 0;
            if a == curpanipt
                if strcmp(Current{m,2}{n,2}{p,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,1}.entryvalue = 0;
                elseif strcmp(Current{m,2}{n,2}{p,1}.entrytype,'ScrptFunc')
                    if isfield(Current{m,2}{n,2}{p,1},'path')
                        if not(exist(Current{m,2}{n,2}{p,1}.path,'dir'))
                            path = which([Current{m,2}{n,2}{p,1}.entrystr,'.m']);
                            if not(isempty(path))
                                ind = strfind(path,'\');
                                path = path(1:ind(end));
                            end
                            Current{m,2}{n,2}{p,1}.path = path;
                        end
                        func = str2func(Current{m,2}{n,2}{p,1}.entrystr);
                        try
                            test = func();
                            [file,path] = uigetfile(Current{m,2}{n,2}{p,1}.path,'Select Function');
                        catch
                            file = 0;
                            path = uigetdir(Current{m,2}{n,2}{p,1}.path,'Select Function');
                        end
                    else
                        error;   % delete case
                        path = uigetdir(Current{m,2}{n,2}{p,1}.searchpath,'Select Function');
                    end
                    if path == 0
                        Status('done','Function Not Selected');
                        return
                    end
                    if file == 0
                        [Func,~] = strtok(flipdim(path,2),filesep);
                        Current{m,2}{n,2}{p,1}.entrystr = flipdim(Func,2);
                        Current{m,2}{n,2}{p,1}.path = path;
                        Current{m,2}{n,2}(p,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}(p,:),tab,panelnum);
                    else
                        Current{m,2}{n,2}{p,1}.entrystr = strtok(file,'.');
                        Current{m,2}{n,2}{p,1}.path = path;
                        Current{m,2}{n,2}(p,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}(p,:),tab,panelnum);
                    end
                    altscrptfunc1 = 1;
                    altscrptfunc2 = 1;
                    altscrptfunc3 = 1;   
                    SCRPTIPTGBL.(tab)(panelnum).default{m,2}{n,2}(p,:) = Current{m,2}{n,2}(p,:);
                    if not(isempty(SCRPTGBL.(tab){panelnum,treecellarray(1)}))
                        if isfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']))
                            SCRPTGBL.(tab){panelnum,treecellarray(1)} = rmfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']));
                        end
                    end
                end
                Current{m,2}{n,2}{p,1}.altval = 1;
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
            if a == curpanipt
                if strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'Choose')
                    Current{m,2}{n,2}{p,2}{d,1}.entryvalue = 0;
                elseif strcmp(Current{m,2}{n,2}{p,2}{d,1}.entrytype,'ScrptFunc')
                    if isfield(Current{m,2}{n,2}{p,2}{d,1},'path')
                        if not(exist(Current{m,2}{n,2}{p,2}{d,1}.path,'dir'))
                            path = which([Current{m,2}{n,2}{p,2}{d,1}.entrystr,'.m']);
                            if not(isempty(path))
                                ind = strfind(path,'\');
                                path = path(1:ind(end));
                            end
                            Current{m,2}{n,2}{p,2}{d,1}.path = path;
                        end
                        func = str2func(Current{m,2}{n,2}{p,2}{d,1}.entrystr);
                        try
                            test = func();
                            [file,path] = uigetfile(Current{m,2}{n,2}{p,2}{d,1}.path,'Select Function');
                        catch
                            file = 0;
                            path = uigetdir(Current{m,2}{n,2}{p,2}{d,1}.path,'Select Function');
                        end
                    else
                        error;   % delete case
                        path = uigetdir(Current{m,2}{n,2}{p,2}{d,1}.searchpath,'Select Function');
                    end
                    if path == 0
                        Status('done','Function Not Selected');
                        return
                    end
                    if file == 0
                        [Func,~] = strtok(flipdim(path,2),filesep);
                        Current{m,2}{n,2}{p,2}{d,1}.entrystr = flipdim(Func,2);
                        Current{m,2}{n,2}{p,2}{d,1}.path = path;
                        Current{m,2}{n,2}{p,2}(d,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}{p,2}(d,:),tab,panelnum);
                    else
                        Current{m,2}{n,2}{p,2}{d,1}.entrystr = strtok(file,'.');
                        Current{m,2}{n,2}{p,2}{d,1}.path = path;
                        Current{m,2}{n,2}{p,2}(d,:) = GetSingleSubFunction_B9(Current{m,2}{n,2}{p,2}(d,:),tab,panelnum);
                    end
                    altscrptfunc1 = 1;
                    altscrptfunc2 = 1;
                    altscrptfunc3 = 1;   
                    SCRPTIPTGBL.(tab)(panelnum).default{m,2}{n,2}{p,2}(d,:) = Current{m,2}{n,2}{p,2}(d,:);
                    if not(isempty(SCRPTGBL.(tab){panelnum,treecellarray(1)}))
                        if isfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']))
                            SCRPTGBL.(tab){panelnum,treecellarray(1)} = rmfield(SCRPTGBL.(tab){panelnum,treecellarray(1)},([RWSUI.funclabel,'_Data']));
                        end
                    end
                end
                Current{m,2}{n,2}{p,2}{d,1}.altval = 1;
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
            if a == curpanipt
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

