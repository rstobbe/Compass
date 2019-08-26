%====================================================
% (v1b)
%      - general function order update
%====================================================

function [SCRPTipt,SCRPTGBL,err] = SelectCreate_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Select Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'FIDfile_Data'))
    if isfield(SCRPTGBL.CurrentTree.('FIDfile').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('FIDfile').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FIDfile';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            SCRPTGBL.('FIDfile_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FIDfile';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.func = SCRPTGBL.CurrentTree.('Function');
FID.path = SCRPTGBL.('FIDfile_Data').path;

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
INPUT.FID = FID;
INPUT.RWSUI = SCRPTGBL.RWSUI;
INPUT.CellArray = CellArray;
[IMG,err] = func(INPUT,IMG);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



