%=====================================================
%
%=====================================================

function [PROJimp,G,WFM,IMPipt,err] = TPI_GSRAstandard_v1a(PROJimp,qT,G,WFMin,IMPipt,err)

PROJimp.GSRAfile = IMPipt(strcmp('GSRA_Data',{IMPipt.labelstr})).runfuncoutput{1};
WFM = WFMin.Data.GSRA_Data.SR;

if not(isfield(WFM,'SlewRate'))
    WFM.SlewRate = 120;
end
    
if PROJimp.mingseg < WFM.T
    if length(err) ~= 1
        n = length(err)+1;
    else
        n = 1;
    end
    err(n).flag = 1;
    err(n).msg = 'Gradient Quantization Too Small for Measured Step Response';
end

steprespbuff = 0;
Tmax = PROJimp.iseg - steprespbuff;
MaxGaccomSRAiseg = (WFM.SlewRate*Tmax^2/2 + WFM.SlewRate*steprespbuff*Tmax)/(Tmax + steprespbuff); 
initsteps = G(:,1,:);
maxinitG = max(initsteps(:));
if maxinitG > MaxGaccomSRAiseg
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Initial Gradient Time-Step Too Small for GSRA';
    return;
end

Tmax = PROJimp.twseg - steprespbuff;
MaxGaccomSRAtwseg = (WFM.SlewRate*Tmax^2/2 + WFM.SlewRate*steprespbuff*Tmax)/(Tmax + steprespbuff); 
%AssocSRAGmax = WFM.SlewRate*Tmax;
m = (2:length(qT)-1);
twsteps = G(:,m,:)-G(:,m-1,:);
maxtwG = max(twsteps(:));
if maxtwG > MaxGaccomSRAtwseg
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Twisted Gradient Time-Step Too Small for SRA';
    return;
end

for n = 1:3
    maxinitG = maxinitG*1.05;
    maxtwG = maxtwG*1.05;
    [istep,istepout,err] = Gradient_Step_Recalculate(WFM,PROJimp.iseg,maxinitG,n,err);
    [twstep,twstepout,err] = Gradient_Step_Recalculate(WFM,PROJimp.twseg,maxtwG,n,err);
    step0 = G(:,1,n);
    G(:,1,n) = sign(step0).*interp1(istep,istepout,abs(step0));
    for m = 3:length(qT)
        step0 = G(:,m-1,n)-G(:,m-2,n);
        if max(abs(step0(:))) > max(twstep)
            maxtwG = maxtwG*1.1;
            [twstep,twstepout,err] = Gradient_Step_Recalculate(WFM,PROJimp.twseg,maxtwG,n,err);
            for errn = 1:length(err)
                if err(errn).flag == 1
                    return
                end
            end
        end
        G(:,m-1,n) = G(:,m-2,n)+sign(step0).*interp1(twstep,twstepout,abs(step0));
    end
end

%------------------------------------------
%
%------------------------------------------
function [Gtest,Gtestout,err] = Gradient_Step_Recalculate(WFM,QL,Gtestmax,n,err)

Tinc = WFM.step;
Tmax = WFM.T;
Gmax = WFM.Gmax;
Gstep = (WFM.Gmin:WFM.Ginc:Gmax);
Gtest = (WFM.Gmin:WFM.Ginc:Gtestmax);
if n == 1
    stepresp = WFM.x;
elseif n == 2
    stepresp = WFM.y;    
elseif n == 3
    stepresp = WFM.z;
end

Gtestout = zeros(1,length(Gtest));
for n = 1:length(Gtest);
    eA = Gtest(n)*QL;
    Gstep0 = Gtest(n);
    while true
        ind = find(Gstep >= Gstep0,1,'first');
        if isempty(ind)
            if length(err) ~= 1
                errn = length(err)+1;
            else
                errn = 1;
            end
            err(errn).flag = 1;
            err(errn).msg = 'SRA exploding';
            return;
        end
        srA = Gstep0*sum(stepresp{ind}{1})*Tinc + Gstep0*(QL-Tmax);
        graderr = abs(1 - (eA/srA));
        if graderr < 0.01
            break
        end
        Gstep0 = (eA/srA)*Gstep0;
    end
    Gtestout(n) = Gstep0;
end
Gtest = [0 Gtest];
Gtestout = [0 Gtestout];



            
        

       