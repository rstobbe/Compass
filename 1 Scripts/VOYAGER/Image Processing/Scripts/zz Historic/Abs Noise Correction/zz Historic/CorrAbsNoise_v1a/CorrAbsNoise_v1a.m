%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CorrAbsNoise_v1a(SCRPTipt,SCRPTGBL)

global IM

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script
%-------------------------------------
aves = str2double(SCRPTipt(strcmp('Averages',{SCRPTipt.labelstr})).entrystr); 
sdv = str2double(SCRPTipt(strcmp('sdv_noise',{SCRPTipt.labelstr})).entrystr); 
inputnum = str2double(SCRPTipt(strcmp('CorrInputImNum',{SCRPTipt.labelstr})).entrystr); 
outputnum = str2double(SCRPTipt(strcmp('CorrOutputImNum',{SCRPTipt.labelstr})).entrystr); 

%-------------------------------------
% Correct
%-------------------------------------
load(['ProbUnderSigAve',num2str(aves)]);
compmax = max(meassigval_med);
meas = [meassigval_med (compmax+1:100)];
under = [medsig0 (compmax+1:100)];
%meas = [meassigval_mean (compmax+1:100)];
%under = [meansig0 (compmax+1:100)];

naninds = isnan(under);
under(naninds) = under(sum(naninds)+1);

kims = IM{inputnum};
test = min(kims(:));
if test < 0
    error();
end
%test = size(kims)
nmkims = mean(kims,5)/sdv;                % Normalized mean kurtosis images

cnmkims = interp1(meas,under,nmkims);

IM{outputnum} = cnmkims*sdv;

set(findobj('tag',['I',num2str(outputnum)]),'string','CorrIM');
set(findobj('tag',['I',num2str(outputnum)]),'visible','on');