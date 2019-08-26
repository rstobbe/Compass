%=====================================================
%
%=====================================================

function [GCDAT,err] = GrappaCalDatExtCube_v1a_Func(GCDAT,INPUT)

Status2('busy','Extract Grappa Calibration Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
kDat = INPUT.kDat;
clear INPUT;

%---------------------------------------------
% Extract
%---------------------------------------------
[x,y,z] = size(kDat);
cen = (x+1)/2;                          % assume symmetric and odd
start = cen-((GCDAT.wid-1)/2);          % assume symmetric and odd
stop = cen+((GCDAT.wid-1)/2); 

%---------------------------------------------
% Return
%---------------------------------------------
GCDAT.cDat = kDat(start:stop,start:stop,start:stop,:);

Status2('done','',2);
Status2('done','',3);



