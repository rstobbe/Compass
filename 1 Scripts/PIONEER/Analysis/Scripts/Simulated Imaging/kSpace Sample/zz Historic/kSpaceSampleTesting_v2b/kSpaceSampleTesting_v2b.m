%===========================================
% (v2b)
%
%===========================================

function [SCRPTipt,SCRPTGBL,err] = kSpaceSampleTesting_v2b(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

ObFunc = SCRPTGBL.CurrentTree.Objectfunc;

if not(isfield(SCRPTGBL,'PerfSamp_File'))
    err.flag = 1;
    err.msg = '(Re)Load Implementation File';
    return
end

%---------------------------------------------
% Build Object
%---------------------------------------------
if isfield(SCRPTGBL,'Object')
    SCRPTGBL = rmfield(SCRPTGBL,'Object');              % reset
end
func = str2func(ObFunc.Func);
[SCRPTipt,Object,err] = func(SCRPTipt,ObFunc);
if err.flag == 1
    ErrDisp(err);
    return
end
Ob = Object.Ob;
ObFoV = Object.ObFoV;

%---------------------------------------------
% Get Sampling
%---------------------------------------------
PerfSamp = SCRPTGBL.PerfSamp_File;
path = PerfSamp.path;
kSampArr = PerfSamp.kSampArr;
kstep = PerfSamp.kstep;

%---------------------------------------------
% Normalize / Test
%---------------------------------------------
kSampArr = kSampArr/kstep;                         % every kstep spaced at 1 grid location. 
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

%---------------------------------------------
% Sample
%---------------------------------------------
Status('busy','This may take a while...');
tic
[SampDat] = mDirectFTCUDAs_v1a(Ob,kSampArr');
toc

%---------------------------------------------
% Display
%---------------------------------------------
SCRPTGBL.RWSUI.LocalOutput(1).label = 'FTduration_s';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(toc);

%--------------------------------------------
% Output
%--------------------------------------------
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = [path,'KSMP_',ObFunc.Func];
SCRPTGBL.RWSUI.SaveVariables = {SampDat,Object,PerfSamp};
SCRPTGBL.RWSUI.SaveVariableNames = {'SampDat','Object','PerfSamp'};



