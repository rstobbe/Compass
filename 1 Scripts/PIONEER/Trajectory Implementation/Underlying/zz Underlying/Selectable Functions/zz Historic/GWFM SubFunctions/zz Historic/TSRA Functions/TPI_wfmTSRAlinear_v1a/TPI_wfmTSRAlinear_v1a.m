%=====================================================
%
%=====================================================

function [PROJimp,qT,G,WFM,IMPipt,err] = TPI_wfmTSRAlinear_v1a(PROJdgn,PROJimp,qT,G,WFM,IMPipt,err)

PROJimp.SRASR = str2double(IMPipt(strcmp('SRASR (mT/m/ms)',{IMPipt.labelstr})).entrystr);
PROJimp.Ginit = str2double(IMPipt(strcmp('Ginit (mT/m)',{IMPipt.labelstr})).entrystr);

%----------------------------------
% Duration Extend
%----------------------------------
initG = G(:,1,:);
WFM.maxinitG = max(abs(initG(:)));
twG = G(:,2,:);
WFM.maxtwG = max(abs(twG(:)));
if WFM.incstepdur == 1
    eA = WFM.maxinitG*PROJdgn.iseg;
    rampA = PROJimp.Ginit^2/(2*PROJimp.SRASR);
    tramp = PROJimp.Ginit/PROJimp.SRASR;
    textend = (eA-rampA)/PROJimp.Ginit;
    if textend < 0
        error();
    end
    qT(2) = tramp+textend;
    qT(3) = 2*qT(2);
end

%----------------------------------
% Define Step Response
%----------------------------------
SR.step = 0.004;
SR.T = 0.6;
SR.t = (0:SR.step:SR.T);
SR.N = length(SR.t);
SR.Gmin = 0.5;
SR.Ginc = 0.125;
SR.Gmax = 60;
Garr = (SR.Gmin:SR.Ginc:SR.Gmax);
rise = PROJimp.SRASR*(SR.t+SR.step/2);
SR.x = ones(length(Garr),SR.N);
SR.y = ones(length(Garr),SR.N);
SR.z = ones(length(Garr),SR.N);
for n = (1:length(Garr));
    Gtemp = ones(1,SR.N);
    Gtemp(rise<Garr(n)) = rise(rise<Garr(n))/Garr(n);
    SR.x(n,:) = Gtemp;
    SR.y(n,:) = Gtemp;
    SR.z(n,:) = Gtemp;
    SR.mindur(n) = SR.step*length(rise(rise<Garr(n)));
end

%----------------------------------
% Limit SR to step duration
%----------------------------------
ind = find((SR.t+SR.step)<qT(2),1,'last');          % becayse SR.t starts at zero
SR.t = SR.t(:,1:ind);
SR.x = SR.x(:,1:ind);
SR.y = SR.y(:,1:ind);
SR.z = SR.z(:,1:ind);
SR.T = max(SR.t) + SR.step;

%----------------------------------
% Recalc Gradients for Initial Step
%----------------------------------
[nproj,~,~] = size(G);
for m = 1:nproj
    G0 = 0;
    G1 = G(m,1,1);
    eA = G1*PROJdgn.iseg;
    [G0outx,err] = Gradient_Step_Recalculate('x',SR,eA,G0,G1,qT(2),err);
    G(m,1,1) = G0outx;
    G0 = 0;
    G1 = G(m,1,2);
    eA = G1*PROJdgn.iseg;
    [G0outy,err] = Gradient_Step_Recalculate('y',SR,eA,G0,G1,qT(2),err);
    G(m,1,2) = G0outy;
    G0 = 0;
    G1 = G(m,1,3);
    eA = G1*PROJdgn.iseg;
    [G0outz,err] = Gradient_Step_Recalculate('z',SR,eA,G0,G1,qT(2),err);    
    G(m,1,3) = G0outz;
end

%----------------------------------
% Test
%----------------------------------
initG = G(:,1,:);
WFM.maxinitGout = max(abs(initG(:)));
if WFM.maxinitGout > PROJimp.Ginit*1.05
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Value of (p) too small to implement with SRA function';
    return
end

%----------------------------------
% Recalc Gradients for First TW Step
%----------------------------------
for m = 1:nproj
    G0 = G(m,1,1);
    G1 = G(m,2,1);
    eA = G1*PROJimp.twseg1;
    [G0outx,err] = Gradient_Step_Recalculate('x',SR,eA,G0,G1,qT(2),err);
    for errn = 1:length(err)
        if err(errn).flag == 1
            err(errn).msg = 'Reduce Ginit or increase p (SRA)';
            WFM.maxtwGout = 100;
            return
        end
    end
    G(m,2,1) = G0outx;
    G0 = G(m,1,2);
    G1 = G(m,2,2);
    eA = G1*PROJimp.twseg1;
    [G0outy,err] = Gradient_Step_Recalculate('y',SR,eA,G0,G1,qT(2),err);
    for errn = 1:length(err)
        if err(errn).flag == 1
            err(errn).msg = 'Reduce Ginit or increase p (SRA)';
            WFM.maxtwGout = 100;
            return
        end
    end
    G(m,2,2) = G0outy;
    G0 = G(m,1,3);
    G1 = G(m,2,3);
    eA = G1*PROJimp.twseg1;
    [G0outz,err] = Gradient_Step_Recalculate('z',SR,eA,G0,G1,qT(2),err);    
    G(m,2,3) = G0outz;
    for errn = 1:length(err)
        if err(errn).flag == 1
            err(errn).msg = 'Reduce Ginit or increase p (SRA)';
            WFM.maxtwGout = 100;
            return
        end
    end    
end

%----------------------------------
% Test
%----------------------------------
twG = G(:,2,:);
WFM.maxtwGout = max(abs(twG(:)));


%=====================================================
%
%=====================================================
function [G1out,err] = Gradient_Step_Recalculate(Orth,SR,eA,G0,G1,QL,err)

if strcmp(Orth,'x')
    R = SR.x;
elseif strcmp(Orth,'y')    
    R = SR.y;
elseif strcmp(Orth,'z')    
    R = SR.z;  
end

Garr = (SR.Gmin:SR.Ginc:SR.Gmax);

G1out = G1;
step = 1;
dir = 1;
while true
    Gstep = G1out - G0;
    ind = find((abs(Gstep)+SR.Ginc/2) >= Garr,1,'last');
    if isempty(ind)
        ind = 1;
    end
    if SR.mindur(ind) > QL
        if length(err) ~= 1
            errn = length(err)+1;
        else
            errn = 1;
        end
        err(errn).flag = 1;
        return;
    end
    srA = sum((G0 + (G1out - G0)*R(ind,:))*SR.step) + G1out*(QL-SR.T);
    if srA == 0
        break
    end    
    Aerr = abs(eA-srA);
    if Aerr < 0.01
        break
    end
    if srA < eA
       if dir == -1
           step = step*0.1;
       end
       G1out = G1out + step;
       dir = 1;
    else
        if dir == 1
            step = step*0.1;
        end
        G1out = G1out - step;
        dir = -1;
    end
    
end




            
        

       