%=====================================================
% 
%=====================================================

function [GSRA,err] = GSRA_TPIloose_v2g_Func(GSRA,INPUT)

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
SR = GSRA.SR;
qT = GQNT.scnrarr;

%---------------------------------------------
% Tests
%---------------------------------------------    
if GQNT.mingseg < SR.T
    err.flag = 1;
    err.msg = 'iGseg or twGseg Too Short for Step Response Cal';
    return
end

steprespbuff = 0;
Tmax = PROJimp.iseg - steprespbuff;
MaxGaccomSRAiseg = (SR.SlewRate*Tmax^2/2 + SR.SlewRate*steprespbuff*Tmax)/(Tmax + steprespbuff); 
initsteps = G(:,1,:);
maxinitG = max(initsteps(:));
if maxinitG > MaxGaccomSRAiseg
    err.flag = 1;
    err.msg = 'Initial Gradient Time-Step Too Small for GSRA';
    return;
end

Tmax = PROJimp.twseg - steprespbuff;
MaxGaccomSRAtwseg = (SR.SlewRate*Tmax^2/2 + SR.SlewRate*steprespbuff*Tmax)/(Tmax + steprespbuff); 
m = (2:length(qT)-1);
twsteps = G(:,m,:)-G(:,m-1,:);
maxtwG = max(twsteps(:));
if maxtwG > MaxGaccomSRAtwseg
    err.flag = 1;
    err.msg = 'Twisted Gradient Time-Step Too Small for SRA';
    return;
end

%---------------------------------------------
% Accomadate Gradients for Step Response
%---------------------------------------------
maxinitrelaccom = 1.5;
segconst = 5;

for n = 1:3
    maxinitG = maxinitG*1.02;
    [istep,istepout,err] = Gradient_Step_Recalculate(SR,PROJimp.iseg,maxinitG,n,maxinitrelaccom,'iseg');
    if err.flag == 1
        return
    end
    step0 = G(:,1,n);
    G(:,1,n) = sign(step0).*interp1(istep,istepout,abs(step0));
    for m = 2:length(qT)-1
        maxrelaccom = 1+(maxinitrelaccom-1)*exp(-m/segconst);
        step0 = G(:,m,n)-G(:,m-1,n);
        maxtwG = max(abs(step0(:)))*1.02;
        if maxtwG < 1
            maxtwG = 1;
        end
        [twstep,twstepout,err] = Gradient_Step_Recalculate(SR,PROJimp.twseg,maxtwG,n,maxrelaccom,'twseg');
        if err.flag == 1
            return
        end
        figure(5000);
        plot(twstep,twstepout);
        figure(5001);
        plot(twstep,twstepout./twstep);            

        accomstep = interp1(twstep,twstepout,abs(step0));
        relaccom = accomstep./abs(step0);
        maxproprelaccom = max(relaccom)
        inds = find(relaccom > maxrelaccom);
        accomstep(inds) = maxrelaccom.*abs(step0(inds));
        G(:,m,n) = G(:,m-1,n)+sign(step0).*accomstep;
    end
end
GSRA.Gaccom = G;
GSRA.gcoil = SR.gcoil;
GSRA.graddel = SR.graddel;

Status2('done','',2);
Status2('done','',3);


%============================================
% Step Recalculate
%============================================
function [Gtest,Gtestout,err] = Gradient_Step_Recalculate(SR,QL,Gtestmax,dim,maxrelaccom,seg)

err.flag = 0;
err.msg = '';

Tinc = SR.step;
Tmax = SR.T;
Gmax = SR.Gmax;
GSR = SR.GSR;
%Gstep = (SR.Gmin:SR.Ginc:Gmax);
Gstep = (SR.Gmin:SR.Ginc:Gmax) + SR.Ginc/2;         % associate with middle value in between steps
Gtest = (SR.Gmin:SR.Ginc:Gtestmax);

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
            Status2('warn',['Increase ''',seg,''' and/or ''p'' and/or decrease ''MaxRelAccom'''],2);
            return;
        end
        srA = Gstep0*sum(GSR(ind,:,dim))*Tinc + Gstep0*(QL-Tmax);
        graderr = abs(1 - (eA/srA));
        test = Gstep0/Gtest(n);
        if test > maxrelaccom
            Gstep0 = maxrelaccom*Gtest(n);
            break
        elseif graderr < 0.01
            break
        end
        Gstep0 = (eA/srA)*Gstep0;
    end
    Gtestout(n) = Gstep0;
end
Gtest = [0 Gtest];
Gtestout = [0 Gtestout];



            
        

       