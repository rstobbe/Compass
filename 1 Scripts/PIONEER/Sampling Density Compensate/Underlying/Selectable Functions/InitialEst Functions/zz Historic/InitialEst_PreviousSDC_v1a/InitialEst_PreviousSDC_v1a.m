%====================================================
% 
%====================================================

function [iSDC,SDCS,SDCipt,err] = InitialEst_PreviousSDC_v1a(Kmat,PROJdgn,PROJimp,SDCS,SDCipt,SCRPTGBL,err)

iSDC = SCRPTGBL.InitialEstfunc.InitialEst_SDC.saveData.SDC;

[iSDC] = SDCArr2Mat(iSDC,PROJdgn.nproj,PROJimp.npro);