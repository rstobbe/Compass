%====================================================
% (v1b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,IEout,err] = InitialEst_PreviousSDC_v1b(SCRPTipt,IE,err)

Status('busy','Return Previous SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

IEout = struct();
CallingLabel = IE.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(IE,[CallingLabel,'_Data']))
    if isfield(IE.('SDC_File').Struct,'selectedfile')
        file = IE.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            IE.([CallingLabel,'_Data']).('SDC_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IEout.SDC_File = IE.([CallingLabel,'_Data']).('SDC_File_Data').path;

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJimp = IE.PROJimp;

%----------------------------------------
% Return
%----------------------------------------
iSDC = IE.([CallingLabel,'_Data']).('SDC_File_Data').SDCS.SDC;
IEout.iSDC = SDCArr2Mat(iSDC,PROJimp.nproj,PROJimp.npro);

