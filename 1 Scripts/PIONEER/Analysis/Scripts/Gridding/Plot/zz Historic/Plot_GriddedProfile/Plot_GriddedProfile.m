%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GriddedProfile(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

Ksz = str2double(SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr);
slice_no = str2double(SCRPTipt(strcmp('Slice',{SCRPTipt.labelstr})).entrystr);
orientation = SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entrystr;
if iscell(orientation)
    orientation = SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entryvalue};
end
maxval = str2double(SCRPTipt(strcmp('MaxVal',{SCRPTipt.labelstr})).entrystr);
%maxval = max(SCRPTGBL.Cdat(slice_no,slice_no,:));

%Grid = SCRPTGBL.Cdat*0.118686;
Grid = SCRPTGBL.Cdat;

figure(10); hold on;
if strcmp(orientation,'z')
    plot(squeeze(Grid(slice_no,slice_no,:)),'b-*');
end