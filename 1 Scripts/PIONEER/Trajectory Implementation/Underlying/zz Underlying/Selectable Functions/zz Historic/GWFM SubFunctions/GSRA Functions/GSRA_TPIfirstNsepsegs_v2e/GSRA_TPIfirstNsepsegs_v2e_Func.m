%=====================================================
% 
%=====================================================

function [GSRA,err] = GSRA_TPIfirstNsepsegs_v2e_Func(GSRA,INPUT)

Status2('busy','Accomodate Step Response',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
GQNT = INPUT.GQNT;
G = INPUT.G;
clear INPUT

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
SRiseg = GSRA.SRiseg;
SRtwseg = GSRA.SRtwseg;
accomNsegs = GSRA.accomNsegs;

%---------------------------------------------
% Tests
%---------------------------------------------
if GQNT.iseg < SRiseg.T
    err.flag = 1;
    err.msg = 'Initial Segment Too Small for Step Response File';
    return
end
if GQNT.twseg < SRtwseg.T
    err.flag = 1;
    err.msg = 'Twistetd Segment Too Small for Step Response File';
    return
end
if not(strcmp(SRiseg.gcoil,SRtwseg.gcoil))
    err.flag = 1;
    err.msg = 'SR Files Do Not Contain the Same Gcoil';
    return
end
if not(SRiseg.graddel==SRtwseg.graddel)
    err.flag = 1;
    err.msg = 'SR Files Do Have the Same Graddel';
    return
end
    
%---------------------------------------------
% Accomadate Gradients for Step Response
%---------------------------------------------
initsteps = G(:,1,:);
maxinitG = max(initsteps(:));
for n = 1:3
    [istep,istepout,err] = Gradient_Step_Recalculate(SRiseg,PROJimp.iseg,maxinitG,n,'iseg');
    if err.flag == 1
        return
    end
    step0 = G(:,1,n);
    G(:,1,n) = sign(step0).*interp1(istep,istepout,abs(step0));    
    if accomNsegs > 1
        for m = 2:accomNsegs
            step0 = G(:,m,n)-G(:,m-1,n);
            maxtwG = max(abs(step0(:)));
            [twstep,twstepout,err] = Gradient_Step_Recalculate(SRtwseg,PROJimp.twseg,maxtwG,n,'twseg');
            if err.flag == 1
                return
            end 
            G(:,m,n) = G(:,m-1,n)+sign(step0).*interp1(twstep,twstepout,abs(step0));
        end
    end
end
GSRA.Gaccom = G;
GSRA.gcoil = SRiseg.gcoil;
GSRA.graddel = SRiseg.graddel;

Status2('done','',2);
Status2('done','',3);


%============================================
% Step Recalculate
%============================================
function [Gtest,Gtestout,err] = Gradient_Step_Recalculate(SR,QL,Gtestmax0,dim,seg)

err.flag = 0;
err.msg = '';

Tinc = SR.step;
Tmax = SR.T;
Gmax = SR.Gmax;
GSR = SR.GSR;
%Gstep = (SR.Gmin:SR.Ginc:Gmax);
Gstep = (SR.Gmin:SR.Ginc:Gmax) + SR.Ginc/2;         % associated with middle value in between steps

Gtest = (SR.Gmin:SR.Ginc:100);
ind = find(Gtest > Gtestmax0,1,'first');
Gtest = Gtest(1:ind);

Gtestout = zeros(1,length(Gtest));
for n = 1:length(Gtest);
    eA = Gtest(n)*QL;
    Gstep0 = Gtest(n);
    ind = 0;
    ind01 = 0;
    while true
        ind02 = ind01;
        ind01 = ind;
        ind = find(Gstep >= Gstep0,1,'first');
        if ind == ind02
            if abs(ind - ind01) == 1
                err.flag = 1;
                err.msg = ['Convergence Error - Try longer ' seg];
                return;
            elseif abs(ind - ind01) == 2
                ind = (ind + ind01)/2;
            end
        end
        if isempty(ind)
            err.flag = 1;
            err.msg = [seg,' (',num2str(Gstep0),' mT/m) is Beyond Calibration'];
            Status2('warn',['Increase ',seg,' and/or increase p'],2);
            return;
        end
        srA = Gstep0*sum(GSR(ind,:,dim))*Tinc + Gstep0*(QL-Tmax);
        graderr = abs(1 - (eA/srA));
        if graderr < 0.02
            break
        end
        Gstep0 = (eA/srA)*Gstep0;
    end
    Gtestout(n) = Gstep0;
end
Gtest = [0 Gtest];
Gtestout = [0 Gtestout];

