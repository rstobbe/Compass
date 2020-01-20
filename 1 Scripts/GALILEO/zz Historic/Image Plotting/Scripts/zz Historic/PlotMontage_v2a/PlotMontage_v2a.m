%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontage_v2a(SCRPTipt,SCRPTGBL)

global IMT
global IMLVL
global CURFIG

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script
%-------------------------------------
xboti = str2double(SCRPTipt(strcmp('leftinset',{SCRPTipt.labelstr})).entrystr); 
xtopi = str2double(SCRPTipt(strcmp('rightinset',{SCRPTipt.labelstr})).entrystr); 
yboti = str2double(SCRPTipt(strcmp('bottominset',{SCRPTipt.labelstr})).entrystr); 
ytopi = str2double(SCRPTipt(strcmp('topinset',{SCRPTipt.labelstr})).entrystr); 
zstart = str2double(SCRPTipt(strcmp('zstart',{SCRPTipt.labelstr})).entrystr); 
zstop = str2double(SCRPTipt(strcmp('zstop',{SCRPTipt.labelstr})).entrystr); 
zstep = str2double(SCRPTipt(strcmp('zstep',{SCRPTipt.labelstr})).entrystr); 
nrows = str2double(SCRPTipt(strcmp('nrows',{SCRPTipt.labelstr})).entrystr); 

%order = 'reverse';
order = 'forward';
SLab = 0;
%topadd = 5;
topadd = 0;
%figsize = [800 1100];
figsize = [300 300];

IM = cell2mat(IMT(CURFIG));
%----------------------------------------
% Select Images
%----------------------------------------
[y,x,z] = size(IM)
if zstop > z
    zstop = z;
end
if strcmp(order,'reverse');
    IM2 = IM(1+ytopi:y-yboti,1+xboti:x-xtopi,zstop:-zstep:zstart);
    slcno = (zstop:-zstep:zstart);
else
    IM2 = IM(1+ytopi:y-yboti,1+xboti:x-xtopi,zstart:zstep:zstop);
    slcno = (zstart:zstep:zstop);
end
[y,x,z] = size(IM2);

IMt = zeros(y+topadd,x,z);
IMt(topadd+1:y+topadd,:,:) = IM2;
IM2 = IMt;


AxialMontage_v2a(IM,IMSTRCT);




Status('done','');
Status2('done','',2);
Status2('done','',3);



