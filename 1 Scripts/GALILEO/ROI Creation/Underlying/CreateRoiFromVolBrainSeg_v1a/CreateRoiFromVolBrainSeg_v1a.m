%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,SCRPTGBL,ROI,err] = CreateRoiFromVolBrainSeg_v1a(SCRPTipt,SCRPTGBL,ROIipt)

Status2('busy','Create Roi From VolBrain Segmentation',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;
ROI.imloadfunc = ROIipt.('ImLoadfunc').Func;
ROI.segnum = str2double(ROIipt.('SegmentNumber'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = ROIipt.Struct.labelstr;
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

%------------------------------------------
% Return
%------------------------------------------
ROI.IMG = IMG;

Status2('done','',2);
Status2('done','',3);









