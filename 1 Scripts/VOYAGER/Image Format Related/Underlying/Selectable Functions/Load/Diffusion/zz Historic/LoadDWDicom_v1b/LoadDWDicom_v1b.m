%=========================================================
% (v1b)
%       - update for RWSUI_BA
%=========================================================

function [SCRPTipt,IMAT,err] = LoadDWDicom_v1b(SCRPTipt,IMATipt)

Status2('done','Get Dicom Loading Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
IMAT = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = IMATipt.Struct.labelstr;
if not(isfield(IMATipt,[CallingLabel,'_Data']))
    if isfield(IMATipt.('FirstDicomFile').Struct,'selectedfile')
        file = IMATipt.('FirstDicomFile').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load First Dicom File';
            ErrDisp(err);
            return
        else
            IMATipt.([CallingLabel,'_Data']).('FirstDicomFile_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load First Dicom File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IMAT = struct();
IMAT.bvaluesstr = IMATipt.('bvalues');
IMAT.totb0ims = str2double(IMATipt.('Tot_b0images'));
IMAT.totslices = str2double(IMATipt.('Tot_Slices'));
IMAT.totdirs = str2double(IMATipt.('Tot_Directions'));
IMAT.numaverages = str2double(IMATipt.('Averages'));
IMAT.locm = IMATipt.([CallingLabel,'_Data']).('FirstDicomFile_Data').file;

%---------------------------------------------
% Get b-values
%---------------------------------------------
bvaluesstr = IMAT.bvaluesstr;
inds = strfind(bvaluesstr,' ');
if isempty(inds)
    bvalues = str2double(bvaluesstr);
else
    bvalues(1) = str2double(bvaluesstr(1:inds(1)));
    for n = 2:length(inds)
        bvalues(n) = str2double(bvaluesstr(inds(n-1)+1:inds(n)));
    end
    if isempty(n)
        bvalues(2) = str2double(bvaluesstr(inds(1)+1:length(bvaluesstr)));
    else
        bvalues(n+1) = str2double(bvaluesstr(inds(n)+1:length(bvaluesstr)));
    end    
end
IMAT.bvalues = bvalues;
IMAT.numbvalues = length(bvalues);

Status2('done','',2);
Status2('done','',3);

