%====================================================
%
%====================================================

function [SCRPTipt] = Load_GradientDesign_v1(SCRPTipt,SCRPTGBL)

%-------------------------------------
% Load Script
%-------------------------------------
load(SCRPTGBL.outpath4);        
whos
dG = dG(nproj,:);                  
Gmax = dGmax(nproj);

gmaxloc1 = find(expT > testlocs.max1,1,'first');             
gmaxloc2 = find(expT > testlocs.max2,1,'first');
gzeroloc1 = find(expT > testlocs.zero1,1,'first');             
gzeroloc2 = find(expT > testlocs.zero2,1,'first');

%-------------------------------------
% Display Script Info
%-------------------------------------

