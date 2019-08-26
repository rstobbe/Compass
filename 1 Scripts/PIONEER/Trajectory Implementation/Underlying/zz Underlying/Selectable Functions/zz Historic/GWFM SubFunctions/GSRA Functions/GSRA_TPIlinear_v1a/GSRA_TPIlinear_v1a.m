%=====================================================
%
%=====================================================

function [PROJimp,G,IMPipt,err] = TPI_GSRAlinear_v1a(PROJimp,qT,G,IMPipt,err)

PROJimp.SRASR = str2double(IMPipt(strcmp('SRASR (mT/m/ms)',{IMPipt.labelstr})).entrystr);

steprespbuff = 0;
Tmax = PROJimp.iseg - steprespbuff;
MaxGaccomSRAiseg = (PROJimp.SRASR*Tmax^2/2 + PROJimp.SRASR*steprespbuff*Tmax)/(Tmax + steprespbuff); 
initsteps = G(:,1,:);
maxinitG = max(initsteps(:));
if maxinitG > MaxGaccomSRAiseg
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Initial Gradient Time-Step Too Small for SRA';
    return;
end
Tmax = PROJimp.twseg - steprespbuff;
MaxGaccomSRAtwseg = (PROJimp.SRASR*Tmax^2/2 + PROJimp.SRASR*steprespbuff*Tmax)/(Tmax + steprespbuff); 
%AssocSRAGmax = PROJimp.SRASR*Tmax;
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

maxinitG = maxinitG*1.05;
maxtwG = maxtwG*1.05;
[istep,istepout,err] = Gradient_Step_Recalculate(PROJimp.SRASR,PROJimp.iseg,maxinitG,err);
[twstep,twstepout,err] = Gradient_Step_Recalculate(PROJimp.SRASR,PROJimp.twseg,maxtwG,err);

for n = 1:3
    step0 = G(:,1,n);
    G(:,1,n) = sign(step0).*interp1(istep,istepout,abs(step0));
    for m = 3:length(qT)
        step0 = G(:,m-1,n)-G(:,m-2,n);
        if max(abs(step0(:))) > max(twstep)
            maxtwG = maxtwG*1.1;
            [twstep,twstepout,err] = Gradient_Step_Recalculate(PROJimp.SRASR,PROJimp.twseg,maxtwG,err);
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
function [Gtest,Gtestout,err] = Gradient_Step_Recalculate(SR,QL,Gtestmax,err)

Tinc = 0.002;
t = (Tinc:Tinc:QL);
Tmax = t(length(t));
rise = SR*t;
Gmax = 120;
Gstep = (0.125:0.125:Gmax);
Gtest = (0.125:0.125:Gtestmax);

stepresp = ones(length(Gstep),length(t));
for n = 1:length(Gstep)
    stepresp(n,rise < Gstep(n)) = rise(rise < Gstep(n))/Gstep(n);
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
        srA = Gstep0*sum(stepresp(ind,:))*Tinc + Gstep0*(QL-Tmax);
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



            
        

       