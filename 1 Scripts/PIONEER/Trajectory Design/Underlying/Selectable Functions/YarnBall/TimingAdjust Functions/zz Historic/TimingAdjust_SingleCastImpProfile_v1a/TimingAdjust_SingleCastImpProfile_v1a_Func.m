%====================================================
%
%====================================================

function [TIMADJ,err] = TimingAdjust_SingleCastImpProfile_v1a_Func(TIMADJ,INPUT)

Status2('busy','Adjust Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GENPRJ = INPUT.GENPRJ;
DESTYPE = INPUT.DESTYPE;
IMPTYPE = INPUT.IMPTYPE;
DESOL = INPUT.DESOL;
TST = INPUT.TST;
CACC = TIMADJ.CACC;
GVP = TIMADJ.GVP;
clear INPUT;

%---------------------------------------------
% Generate outward trajectories
%---------------------------------------------  
func = str2func([DESTYPE.method,'_Func']);    
INPUT.PSMP.phi = 0;
INPUT.PSMP.theta = 0;
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.DESOL = DESOL;
INPUT.func = 'GenerateOut';      
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
T = IMPTYPE.T;
KSA = IMPTYPE.KSA;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)
    error
end

%---------------------------------------------
% Constrain acceleration
%---------------------------------------------
func = str2func([CACC.method,'_Func']);  
CACC.Vis = TST.CACC.Vis;
INPUT.TArr = T;
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.TST = TST;
INPUT.GVP = GVP;
INPUT.kArr = squeeze(KSA);
INPUT.ProfileTest = 'Yes';
INPUT.check = 0;
INPUT.type = '3D';
[CACC,err] = func(CACC,INPUT);
if err.flag ~= 0
    return
end
clear INPUT;   
Tout = CACC.TArr;

%---------------------------------------------
% Test
%---------------------------------------------
testtro = interp1(Rad,Tout,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end

%---------------------------------------------
% Determine Initial Radial Speed
%---------------------------------------------    
ind = find(Tout > 1,1,'first');
TIMADJ.kRadAt1ms = Rad(ind)*PROJdgn.kmax;
ind = find(Tout > 0.3,1,'first');
TIMADJ.kRadAt03ms = Rad(ind)*PROJdgn.kmax;

%---------------------------------------------
% Return
%--------------------------------------------- 
TIMADJ.ConstEvolT = Tout;
TIMADJ.ConstEvolRad = Rad;

%---------------------------------------------
% Return
%---------------------------------------------
TIMADJ.CACC = CACC;

Status2('done','',2);
Status2('done','',3);



    