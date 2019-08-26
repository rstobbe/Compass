%=========================================================
% 
%=========================================================

function [GSRI,err] = GSRI_TPIstandard_v2f_Func(GSRI,INPUT)

Status2('busy','Add Step Response',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
G = INPUT.G;
GQNT = INPUT.GQNT;
GWFM = INPUT.GWFM;
SR = GSRI.SR;
clear INPUT

%---------------------------------------------
% Tests
%---------------------------------------------
if GQNT.mingseg < SR.T
    err.flag = 1;
    err.msg = 'Gradient Quantization Too Small for Step Response File';
    return
end
if GWFM.Gmaxinit > SR.Gmax
    err.flag = 1;
    err.msg = ['Initial Grad Step (',num2str(GWFM.Gmaxinit),') Too Large for SR File'];
    return
end
if GWFM.Gmaxtwstep > SR.Gmax
    err.flag = 1;
    err.msg = ['Twisted Grad Steps (',num2str(GWFM.Gmaxtwstep),') Too Large for SR File'];
    return
end

%---------------------------------------------
% Add Step Response to Gradient Waveforms
%---------------------------------------------
[nproj,~,~] = size(G);
TGSR = StepResp_Timing(GWFM.qTscnr,SR.N,SR.t);
GSR = zeros(nproj,length(TGSR),3);    
for n = 1:nproj
    if strcmp(PROJimp.orient,'Axial');    
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),SR,SR.N);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),SR,SR.N);
        [GSR(n,:,3)] = StepResp_Grad('z',G(n,:,3),SR,SR.N);
    elseif strcmp(PROJimp.orient,'Coronal');
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),SR,SR.N);
        [GSR(n,:,2)] = StepResp_Grad('z',G(n,:,2),SR,SR.N);
        [GSR(n,:,3)] = StepResp_Grad('y',G(n,:,3),SR,SR.N);
    elseif strcmp(PROJimp.orient,'Sagittal');    
        [GSR(n,:,1)] = StepResp_Grad('z',G(n,:,1),SR,SR.N);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),SR,SR.N);
        [GSR(n,:,3)] = StepResp_Grad('x',G(n,:,3),SR,SR.N);
    end
    Status2('busy',['Add Gradient Step-Response Projection Number: ',num2str(n)],3);    
end
GSRI.TGSR = TGSR;
GSRI.GSR = GSR;
GSRI.gcoil = SR.gcoil;
GSRI.graddel = SR.graddel;

Status2('done','',2);
Status2('done','',3);


%=============================================
% StepResp_Timing
%=============================================
function [TGSR] = StepResp_Timing(qT,N,t)
M = length(qT)-1;
TGSR = zeros(1,M*N);
TGSR(1:N) = t;                            
N0 = N;
for m = 2:M                             
    TGSR(N0+1:N0+N) = qT(m)+t;
    N0 = N0 + N;
end
TGSR(N0+1) = qT(M)+(qT(M)-qT(M-1));

%=============================================
% StepResp_Grad
%=============================================
function [GSR] = StepResp_Grad(Orth,G,SR,N)
if strcmp(Orth,'x')
    R = SR.GSR(:,:,1);
elseif strcmp(Orth,'y')    
    R = SR.GSR(:,:,2);
elseif strcmp(Orth,'z')    
    R = SR.GSR(:,:,3);  
end
M = length(G(1,:));                                   
GSR = zeros(1,M*N);
[rise] = SRfunc(0,G(1),R,SR);
GSR(1:N) = rise;
N0 = N;
for m = 2:M                             
    [rise] = SRfunc(G(m-1),G(m),R,SR);
    GSR(N0+1:N0+N) = rise;
    N0 = N0 + N;
end
GSR(N0+1) = G(M);

%=============================================
% SRfunc
%=============================================
function [rise] = SRfunc(G0,G1,R,SR)

%GSRarr = (SR.Gmin:SR.Ginc:SR.Gmax) + SR.Ginc/2;
if G0 == G1
    rise = G0*ones(1,length(R(1,:)));
else
    for n = 1:length(R(:,1))
        if abs(G1-G0) < n*SR.Ginc+SR.Gmin-SR.Ginc/2
            rise = G0 + (G1-G0)*R(n,:);
            break;
        end
    end
    %ind = find(GSRarr >= abs(G1-G0),1,'first');
    %rise0 = G0 + (G1-G0)*R(ind,:);
    %GSRval = GSRarr(ind);
    %if n ~= ind
    %    error();
    %end
end





        
        


