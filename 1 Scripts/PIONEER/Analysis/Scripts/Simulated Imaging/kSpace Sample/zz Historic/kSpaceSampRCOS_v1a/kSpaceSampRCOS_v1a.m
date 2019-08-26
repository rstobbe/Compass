%===========================================
%
%===========================================

function [SCRPTipt,SCRPTGBL,err] = kSpaceSampRCOS_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

funclabel = SCRPTGBL.RWSUI.funclabel;
if length(funclabel) == 1
    funclabel = funclabel{1};
end
obfunc = (SCRPTipt(strcmp('Objectfunc',{SCRPTipt.labelstr})).entrystr); 

if not(isfield(SCRPTGBL,funclabel))
    err.flag = 1;
    err.msg = 'Load Implementation File';
    return
end
if not(isfield(SCRPTGBL.(funclabel),'Imp_File'))
    err.flag = 1;
    err.msg = 'Load Implementation File';
    return
end

%---------------------------------------------
% Build Object
%---------------------------------------------
if isfield(SCRPTGBL.(funclabel),'Object')
    SCRPTGBL = rmfield(SCRPTGBL.(funclabel),'Object');              % reset
end
func = str2func(obfunc);
[SCRPTipt,Object,err] = func(SCRPTipt,SCRPTGBL.(funclabel));
SCRPTGBL.(funclabel).Object = Object;
Ob = Object.Ob;
ObFoV = Object.ObFoV;

%---------------------------------------------
% Load Trajectory
%---------------------------------------------
PROJimp = SCRPTGBL.(funclabel).Imp_File.PROJimp;
PROJdgn = SCRPTGBL.(funclabel).Imp_File.PROJdgn;
Kmat = SCRPTGBL.(funclabel).Imp_File.Kmat;

kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJdgn.nproj;

%---------------------------------------------
% Isolate nproj projections from Kmat for RCOS
%---------------------------------------------
Kmat = Kmat(1:nproj,:,:);

%---------------------------------------------
% Normalize / Test
%---------------------------------------------
[kSampArr0] = KMat2Arr(Kmat,nproj,npro);
kSampArr = kSampArr0/kstep;                         % every kstep spaced at 1 grid location. 
rel = (ObFoV/1000)*kstep;                           % adjust sampling according to relative FoV
kSampArr = kSampArr*rel;

test1 = max(abs(kSampArr(:)));
if (test1*2) > length(Ob)
    err.flag = 1;
    err.msg = 'Use Object Function with Larger Matrix and/or Smaller FoV'; 
    return
end

[x,y] = size(kSampArr);
if y ~= 3
    error
end

Status('busy','This may take a while...');

tic
[SampDat] = mDirectFTCUDAs_v1a(Ob,kSampArr');
toc

SCRPTGBL.(funclabel).SampDat = SampDat;

Status('done','');

