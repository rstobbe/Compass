%====================================================
% (v1a)
%     
%====================================================
 
function [SCRPTipt,SCRPTGBL,err] = FlexCreateV_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
% if SCRPTGBL.RWSUI.panel ~= 5;
%     err.flag = 1;
%     err.msg = 'Run From Panel0';
% end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Fid_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Fid').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Fid').Struct;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Fid';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            SCRPTGBL.('Fid_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Fid';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.createfunc = SCRPTGBL.CurrentTree.('Createfunc').Func;
IMG.fid = SCRPTGBL.('Fid_Data');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ICipt = SCRPTGBL.CurrentTree.('Createfunc');
if isfield(SCRPTGBL,('Createfunc_Data'))
    ICipt.Createfunc_Data = SCRPTGBL.Createfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMG.createfunc); 
[SCRPTipt,IC,err] = func(SCRPTipt,ICipt);
if err.flag
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.IC = IC;
[IMG,err] = func(INPUT,IMG);
if err.flag
    return
end

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



