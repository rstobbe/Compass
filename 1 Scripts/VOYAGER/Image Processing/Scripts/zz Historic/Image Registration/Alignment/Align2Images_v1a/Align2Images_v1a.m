%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Align2Images_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Generate B1 Map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Registr_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    if SCRPTGBL.RWSUI.scrptnum > indnum(1)
        indnum = indnum(2);
    else
        indnum = indnum(1);
    end
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
for m = 1:2
    if not(isfield(SCRPTGBL,['Image_File',num2str(m),'_Data']))
        if isfield(SCRPTGBL.CurrentTree.(['Image_File',num2str(m)]).Struct,'selectedfile')
            file = SCRPTGBL.CurrentTree.(['Image_File',num2str(m)]).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Image_Files';
                ErrDisp(err);
                return
            else
                load(file);
                saveData.path = file;
                SCRPTGBL.(['Image_File',num2str(m),'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load Image_Files';
            ErrDisp(err);
            return
        end
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
RGSTR.method = SCRPTGBL.CurrentScript.Func;
for m = 1:2
    fields = fieldnames(SCRPTGBL.(['Image_File',num2str(m),'_Data']));
    for n = 1:length(fields)
        if isfield(SCRPTGBL.(['Image_File',num2str(m),'_Data']).(fields{n}),'Im')
            IMG{m} = SCRPTGBL.(['Image_File',num2str(m),'_Data']).(fields{n});
            break
        end
    end
end
RGSTR.alignfunc = SCRPTGBL.CurrentTree.('Alignfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ALGNipt = SCRPTGBL.CurrentTree.('Alignfunc');
if isfield(SCRPTGBL,('Alignfunc_Data'))
    ALGNipt.Alignfunc_Data = SCRPTGBL.Alignfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(RGSTR.alignfunc);           
[SCRPTipt,ALGN,err] = func(SCRPTipt,ALGNipt);
if err.flag
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([RGSTR.method,'_Func']);
INPUT.IMG = IMG;
INPUT.ALGN = ALGN;
[RGSTR,err] = func(RGSTR,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Registration:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RGSTR};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGSTR'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

