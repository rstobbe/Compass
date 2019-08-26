%==================================================
% Constrain Acceleration
%==================================================

function [SCRPTipt,CACC] = CAccT_v1a(SCRPTipt,CACC)

%------------------------------------------
% Script Input
%------------------------------------------
caccm = SCRPTipt(strcmp('ConstAccMethod',{SCRPTipt.labelstr})).entrystr;
caccp = SCRPTipt(strcmp('ConstAccProf',{SCRPTipt.labelstr})).entrystr;

%------------------------------------------
% Acceleration Profile
%------------------------------------------        
ind = length(CACC.magaccpre);             % constrain to acceleration value at end of projection         
func = str2func(caccp);
AccProfFunc = func();
AccProf = CACC.magaccpre(ind)*ones(1,length(CACC.T)).*AccProfFunc(CACC.T);

%------------------------------------------
% Constrain Acceleration
%------------------------------------------
func = str2func(caccm);
[CACC.T] = func(CACC.magaccpre,AccProf,CACC.T);
CACC.T = CACC.tro*CACC.T/CACC.T(length(CACC.T));
T0(:,1) = CACC.T; T0(:,2) = CACC.T; T0(:,3) = CACC.T;
[vel] = CalcVel_v1(CACC.KSA2,T0);
[acc] = CalcAcc_v1(vel,T0);
CACC.magaccpost = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
CACC.magvelpost = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);      

%------------------------------------------
% Test
%------------------------------------------
Test = 0;
if Test == 1;
    figure(360); hold on; plot(CACC.T,'b','linewidth',2); xlabel('Solution Segment'); ylabel('Segment Time'); title('Constrained Acceleration Solution Timing');
end

