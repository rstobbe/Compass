%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = B1map5angle_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Generate B1 Map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('B1map_Name',{SCRPTipt.labelstr});
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
B1MAP.method = SCRPTGBL.CurrentScript.Func;
for m = 1:5
    IMG{m} = SCRPTGBL.(['Image_File',num2str(m),'_Data']).IMG;
    B1MAP.specflip(m) = str2double(SCRPTGBL.CurrentScript.(['SpecFlip',num2str(m)]));
end

%---------------------------------------------
% Export
%---------------------------------------------
func = str2func([B1MAP.method,'_Func']);
INPUT.IMG = IMG;
[B1MAP,err] = func(B1MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name B1 Map:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {B1MAP};
SCRPTGBL.RWSUI.SaveVariableNames = {'B1MAP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

