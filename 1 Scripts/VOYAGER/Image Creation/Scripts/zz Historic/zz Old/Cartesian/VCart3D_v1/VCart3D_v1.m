%====================================================
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = VCart3D_v1(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

Vis = SCRPTipt(strcmp('Visuals',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('Visuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Visuals',{SCRPTipt.labelstr})).entryvalue};
end
Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(Clr)
    Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

figno = 1;
%------------------------------------------
% Load Data
%------------------------------------------
[Dat] = ImportFIDmat_v1([SCRPTGBL.File_FIDdata.FIDLoc,'\fid']);
[Params,errorflag,error] = Load_Params_v1([SCRPTGBL.File_FIDdata.FIDLoc,'\Params']);
if errorflag == 1
    Status('error',error);
    return
end
set(findobj('tag','TestBox'),'string',Params);
TextBox = Params;

dp = 10;
figure(10); hold on;
plot(angle(Dat(:,dp)));

MaxDat = max(abs(Dat(:)));
figure(11); hold on;
plot(abs(Dat(:,dp))); ylim([0 MaxDat]);

figure(12); hold on;
plot(angle(Dat(497,:)));
plot(angle(Dat(498,:)),'r');
plot(angle(Dat(499,:)),'g');

figure(13); hold on;
plot(abs(Dat(497,:)));
plot(abs(Dat(498,:)),'r');
plot(abs(Dat(499,:)),'g');

%------------------------------------------
% RF spoil unwind
%------------------------------------------
[dummies] = str2double(Parse_Params_v1(Params,'dummies'));
[rfspoil] = str2double(Parse_Params_v1(Params,'rfspoil'));
if not(isempty(rfspoil))
    [Dat] = rfspoil_uwnd_v1(Dat,dummies,rfspoil);
end

figure(10);
plot(angle(Dat(:,dp)),'r');

%------------------------------------------
% DC correct
%------------------------------------------
dccor = SCRPTipt(strcmp('DC_cor',{SCRPTipt.labelstr})).entrystr;
func = str2func(dccor);
[SCRPTipt,Dat] = func(SCRPTipt,Dat);

%------------------------------------------
% Separate into Matrix
%------------------------------------------
[nro] = Parse_Params_v1(Params,'osnro');
[nv1] = Parse_Params_v1(Params,'nv1');
[nv2] = Parse_Params_v1(Params,'nv2');
DatMat = zeros(osnp,nv1,nv2);
ind = 0;
for n = 1:nv2
    for m = 1:nv1
        ind = ind+1;
        DatMat(:,n,m) = Dat(:,ind);
    end
end

%------------------------------------------
% Filter
%------------------------------------------
filter = SCRPTipt(strcmp('Filter',{SCRPTipt.labelstr})).entrystr;
func = str2func(filter);
[SCRPTipt,DatMat] = func(SCRPTipt,DatMat);

%------------------------------------------
% Zero Fill
%------------------------------------------

%------------------------------------------
% Orient
%------------------------------------------

%------------------------------------------
% FT
%------------------------------------------

%------------------------------------------
% Scale
%------------------------------------------


%------------------------------------------
% Crop
%------------------------------------------

[np] = Parse_Params_v1(Params,'np');

Figs(figno).handle = figure(110); hold on;
Figs(figno).name = 'RF Spoil Test';




