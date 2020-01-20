%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,SCRPTGBL,ROI,err] = CreateRoiFromImage_v1b(SCRPTipt,SCRPTGBL,ROIipt)

Status2('busy','Create Roi From Image',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;
ROI.imloadfunc = ROIipt.('ImLoadfunc').Func;
ROI.maskfunc = ROIipt.('Maskfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = ROIipt.Struct.labelstr;
MASKipt = ROIipt.('Maskfunc');
if isfield(ROIipt,([CallingLabel,'_Data']))
    if isfield(ROIipt.([CallingLabel,'_Data']),'Maskfunc_Data')
        MASKipt.('Maskfunc_Data') = ROIipt.([CallingLabel,'_Data']).('Maskfunc_Data');
    end
end
LOADipt = ROIipt.('ImLoadfunc');
if isfield(ROIipt,([CallingLabel,'_Data']))
    if isfield(ROIipt.([CallingLabel,'_Data']),'ImLoadfunc_Data')
        LOADipt.('ImLoadfunc_Data') = ROIipt.([CallingLabel,'_Data']).('ImLoadfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(ROI.imloadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(ROI.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
ROI.MASK = MASK;
ROI.IMG = IMG;

Status2('done','',2);
Status2('done','',3);









