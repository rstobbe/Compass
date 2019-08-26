%=========================================================
% 
%=========================================================

function [IM,IMPROP,IMPROC,KRN,warn,warnflag] = ConvolutionGridding_v1(Dat,SDC,ArrKmat,kstep,kmax,IMCONprms,KRN)

%if IMCONprms.ZF.narrow == 1;
%    IMCOMprms.ZF.value3D = 2*ceil(round(Ksz/2));
%end
%CDat = Zerofill(CDat,IMCONprms);

%********************************
% Should make a multiple of 1.2 
% so can get exactly back to FoV
%********************************



