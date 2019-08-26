%=========================================================
% 
%=========================================================

function [CORR,err] = CorrAbsNoise_v1c_Func(CORR,INPUT)

Status('busy','Correct for Effect of Absolute Value on Noise');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
dwims = INPUT.avedwims;
sdv = CORR.sdvnoise;
aves = INPUT.numaverages;
clear INPUT;

%-------------------------------------
% Load Correction Curves
%-------------------------------------
load(['ProbUnderSigAve',num2str(aves)]);
compmax = max(meassigval_med);
meas = [meassigval_med (compmax+1:100)];
under = [medsig0 (compmax+1:100)];
%meas = [meassigval_mean (compmax+1:100)];
%under = [meansig0 (compmax+1:100)];
naninds = isnan(under);
under(naninds) = under(sum(naninds)+1);

%-------------------------------------
% Tests
%-------------------------------------
test = min(dwims(:));
if test < 0
    error();
end
sz = size(dwims);
if length(sz) > 5
    error();
end

%-------------------------------------
% Correct
%-------------------------------------
nmdwims = dwims/sdv;                % Normalized diffusion images
cnmdwims = interp1(meas,under,nmdwims);
cdwims = cnmdwims*sdv;

%---------------------------------------------
% Return
%---------------------------------------------
CORR.cdwims = cdwims;
CORR.numaverages = aves;
