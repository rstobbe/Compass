%=========================================================
% (v1a) 
%        
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = VarianFID2Mat_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'FIDpath_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FIDpath').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FIDpath').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FIDpath';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('FIDpath_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FIDpath';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
EXPORT.method = SCRPTGBL.CurrentScript.Func;
EXPORT.path = SCRPTGBL.('FIDpath_Data').path;

%---------------------------------------------
% Export
%---------------------------------------------
func = str2func([EXPORT.method,'_Func']);
INPUT = struct();
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'mo';

