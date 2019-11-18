%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,PDGM,err] = FmriPdgmCorrRelDifOutput_v1a(SCRPTipt,PDGMipt)

Status2('busy','FMRI Paradigm Correlation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PDGM.method = PDGMipt.Func;
PDGM.MinSigVal = str2double(PDGMipt.('MinSigVal'));
PDGM.RefSigVal = str2double(PDGMipt.('RefSigVal'));
PDGM.Significance = str2double(PDGMipt.('Significance'));

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = PDGMipt.Struct.labelstr;
if not(isfield(PDGMipt,[CallingLabel,'_Data']))
    if isfield(PDGMipt.('Paradigm_ExcelFile').Struct,'selectedfile')
        file = PDGMipt.('Paradigm_ExcelFile').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Paradigm_ExcelFile';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Paradigm_ExcelFile',2);
            load(file);
            saveData.path = file;
            PDGMipt.([CallingLabel,'_Data']).('Paradigm_ExcelFile_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Paradigm_ExcelFile';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PDGM.ParadigmExcelFile = PDGMipt.([CallingLabel,'_Data']).('Paradigm_ExcelFile_Data');

Status2('done','',2);
Status2('done','',3);

