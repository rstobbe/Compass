%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRand_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;

if SCRPTGBL.testing == 1
    PROJimp.nproj = PROJimp.tnproj;
else
    PROJimp.nproj = PROJdgn.nproj;    
end

PROJimp.projdist.IV(1,:) = acos(2*rand(1,PROJimp.nproj)-1);
PROJimp.projdist.IV(2,:) = 2*pi*rand(1,PROJimp.nproj);

%phivalues = acos(2*rand(1,10000000)-1);
%figure(2)
%hist(values,40);