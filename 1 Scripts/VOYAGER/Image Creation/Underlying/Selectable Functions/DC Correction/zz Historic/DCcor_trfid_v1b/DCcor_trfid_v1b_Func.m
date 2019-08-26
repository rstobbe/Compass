%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor_trfid_v1b_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
clear INPUT;

%---------------------------------------------
% DC correct from trailing FID values
%---------------------------------------------
Dat = FID.FIDmat;
np = length(Dat(1,:));
trfidpts = round(DCCOR.trfidper*np*0.01);

DatSum = mean(Dat,1);
DCcor = mean(DatSum(np-trfidpts+1:np));    
Dat = Dat - DCcor;

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = Dat;

Status2('done','',2);
Status2('done','',3);



