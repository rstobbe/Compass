%====================================================
% 
%====================================================

function [SYSREL,err] = TrajComp_BasicQuantizedTPI_v1a_Func(SYSREL,INPUT)

Status2('busy','Complete Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GQNT = INPUT.GQNT;
G0 = INPUT.G;
PROJimp = INPUT.PROJimp;
SYS = INPUT.SYS;
TEND = SYSREL.TEND;
clear INPUT;

%---------------------------------------------
% Add Gslew
%---------------------------------------------
stepval = SYSREL.gslew*(SYS.GradSampBase/1000);
sz = size(G0);
nproj = sz(1);
G = zeros(nproj,PROJimp.tro*1000/SYS.GradSampBase,3);

tarr = (0:SYS.GradSampBase:PROJimp.tro*1000-SYS.GradSampBase);
for n = 1:nproj
    for dir = 1:3
        Garr = interp1(round(GQNT.samparr*1000),[G0(n,:,dir) G0(n,end,dir)],tarr,'previous');
        if abs(Garr(1)) > stepval
            G(n,1,dir) = sign(Garr(1))*stepval;
        else
            G(n,1,dir) = Garr(1);
        end
        for idx = 2:length(Garr)
            if Garr(idx) >= G(n,idx-1,dir)
                if Garr(idx) > (G(n,idx-1,dir) + stepval)
                    G(n,idx,dir) = G(n,idx-1,dir) + stepval;
                else
                    G(n,idx,dir) = Garr(idx);
                end
            else 
                if Garr(idx) < (G(n,idx-1,dir) - stepval)
                    G(n,idx,dir) = G(n,idx-1,dir) - stepval;
                else
                    G(n,idx,dir) = Garr(idx);
                end
            end
        end
    end
    Status2('busy',['Add Slew to Projection: ',num2str(n)],3);    
end

%figure(50); hold on;
%plot(GQNT.samparr,[G0(n,:,dir) G0(n,end,dir)],'r');
%plot(tarr,Garr,'b');
%plot(tarr,G(1,:,dir),'k');

%---------------------------------------------
% Calculate Gradient Momoment
%---------------------------------------------
Gmom = sum(G,2)*(SYS.GradSampBase/1000);
Gend = G(:,length(Garr),:);

%---------------------------------------------
% End Trajectory
%---------------------------------------------
Status2('busy','End Trajectory',3);
func = str2func([SYSREL.tendfunc,'_Func']);
INPUT.SYS = SYS;
INPUT.gslew = SYSREL.gslew;
INPUT.Gmom = Gmom;  
INPUT.Gend = Gend;
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end
Gend = TEND.Gend;
Gwend = cat(2,G,Gend);

%---------------------------------------------
% Test Refocus
%---------------------------------------------
Gmom2 = squeeze(sum(Gwend,2)*(SYS.GradSampBase/1000));
if not(isempty(find(Gmom2 > 0.05,1)))
    error;
end

%---------------------------------------------
% Return
%---------------------------------------------
SYSREL.tgwfm = length(Gwend)*(SYS.GradSampBase/1000);
SYSREL.qTscnr = (0:SYS.GradSampBase/1000:SYSREL.tgwfm-SYS.GradSampBase/1000);
SYSREL.G = Gwend;

Status2('done','',2);
Status2('done','',3);

