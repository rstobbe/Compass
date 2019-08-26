%=====================================================
% (v1b)
%       - update for RWSUI_BA
%=====================================================

function [SCRPTipt,GSRAout,err] = GSRA_TPIstandard_v1b(SCRPTipt,GSRA)

Status2('busy','Accomodate Step Response',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

GSRAout = struct();
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(GSRA,'GSRAfunc_Data'))
    if isfield(GSRA.('GSRA_File').Struct,'selectedfile')
        file = GSRA.('GSRA_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRA_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRA.GSRAfunc_Data.GSRA_File_Data = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRA_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
GSRAout.SR = GSRA.GSRAfunc_Data.GSRA_File_Data;
SR = GSRAout.SR;
PROJimp = GSRA.PROJimp;
qT = GSRA.qT;
G = GSRA.G;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SR,'SlewRate'))
    SR.SlewRate = 120;
end
    
if GSRA.mingseg < SR.T
    err.flag = 1;
    err.msg = 'Gradient Quantization Too Small for Measured Step Response';
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
for n = 1:3
    maxinitG = maxinitG*1.05;
    maxtwG = maxtwG*1.05;
    [istep,istepout,err] = Gradient_Step_Recalculate(SR,PROJimp.iseg,maxinitG,n);
    if err.flag == 1
        return
    end
    [twstep,twstepout,err] = Gradient_Step_Recalculate(SR,PROJimp.twseg,maxtwG,n);
    if err.flag == 1
        return
    end
    step0 = G(:,1,n);
    G(:,1,n) = sign(step0).*interp1(istep,istepout,abs(step0));
    for m = 3:length(qT)
        step0 = G(:,m-1,n)-G(:,m-2,n);
        if max(abs(step0(:))) > max(twstep)
            maxtwG = maxtwG*1.1;
            [twstep,twstepout,err] = Gradient_Step_Recalculate(SR,PROJimp.twseg,maxtwG,n);
            if err.flag == 1
                return
            end
        end
        G(:,m-1,n) = G(:,m-2,n)+sign(step0).*interp1(twstep,twstepout,abs(step0));
    end
end
GSRAout.Gaccom = G;


%============================================
% Step Recalculate
%============================================
function [Gtest,Gtestout,err] = Gradient_Step_Recalculate(SR,QL,Gtestmax,n)

err.flag = 0;
err.msg = '';

Tinc = SR.step;
Tmax = SR.T;
Gmax = SR.Gmax;
Gstep = (SR.Gmin:SR.Ginc:Gmax);
Gtest = (SR.Gmin:SR.Ginc:Gtestmax);
if n == 1
    stepresp = SR.x;
elseif n == 2
    stepresp = SR.y;    
elseif n == 3
    stepresp = SR.z;
end

Gtestout = zeros(1,length(Gtest));
for n = 1:length(Gtest);
    eA = Gtest(n)*QL;
    Gstep0 = Gtest(n);
    while true
        ind = find(Gstep >= Gstep0,1,'first');
        if isempty(ind)
            err.flag = 1;
            err.msg = 'SRA exploding';
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



            
        

       