%====================================================
% 
%====================================================

function [TF,SDCS,err] = TF_MatchSD_v1b(PROJdgn,SDCS,SDCipt)

TF = struct();
err.flag = 0;

if not(isfield(PROJdgn,'sdcTF'))
    err.flag = 1;
    err.msg = 'TFfunc ''TF_MatchSD'' not suitable for projection design';
    return
end

TF.tf = PROJdgn.sdcTF; 
TF.r = PROJdgn.sdcR;

visuals = 0;
if visuals == 1
    figure; plot(TF.r,TF.tf);
end
