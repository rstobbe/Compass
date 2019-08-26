%====================================================
% (v1b)
%      - starting...
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PopCreateLoopV_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Select Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if SCRPTGBL.RWSUI.panel ~= 5;
    err.flag = 1;
    err.msg = 'Run From Panel0';
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'VarianFolder_Data'))
    if isfield(SCRPTGBL.CurrentTree.('VarianFolder').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('VarianFolder').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load VarianFolder';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            SCRPTGBL.('VarianFolder_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load VarianFolder';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'LocalFolder_Data'))
    if isfield(SCRPTGBL.CurrentTree.('LocalFolder').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('LocalFolder').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load LocalFolder';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            SCRPTGBL.('LocalFolder_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load LocalFolder';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.varianfolder = SCRPTGBL.('VarianFolder_Data').path;
IMG.localfolder = SCRPTGBL.('LocalFolder_Data').path;

%---------------------------------------------
% RWSUI
%---------------------------------------------
Options.excludelocaloutput = 'yes';
if not(err.flag)
    Options.makelocalcurrent = 'yes';
end
Options.scrptnum = SCRPTGBL.RWSUI.scrptnum;
[CellArray] = PANlab2CellArray_B9(SCRPTipt,Options);

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.RWSUI = SCRPTGBL.RWSUI;
INPUT.CellArray = CellArray;
[IMG,err] = func(INPUT,IMG);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



