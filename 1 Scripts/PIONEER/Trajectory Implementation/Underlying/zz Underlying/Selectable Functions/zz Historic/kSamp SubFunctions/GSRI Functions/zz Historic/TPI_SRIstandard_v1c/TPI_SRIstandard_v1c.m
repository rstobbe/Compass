%=========================================================
% (v1c)
%   - get SRI_Data from Global rather than memory
%=========================================================

function [PROJimp,TGSR,GSR,KSMP,IMPipt,err] = TPI_SRIstandard_v1c(PROJimp,qT,G,KSMPin,IMPipt,err)

PROJimp.SRIfile = IMPipt(strcmp('SRI_Data',{IMPipt.labelstr})).runfuncoutput{1};
KSMP = KSMPin.Data.SRI_Data.SR;
SR = KSMP;

if PROJimp.mingseg < SR.T
    if length(err) ~= 1
        n = length(err)+1;
    else
        n = 1;
    end
    err(n).flag = 1;
    err(n).msg = 'Gradient Quantization Too Small for Measured Step Response';
end

[nproj,~,~] = size(G);
TGSR = StepResp_Timing(qT,SR.N,SR.t);
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
    Status('busy',['Add Gradient Step-Response Projection Number: ',num2str(n)]);    
end


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


function [GSR] = StepResp_Grad(Orth,G,SR,N)
if strcmp(Orth,'x')
    R = SR.x;
elseif strcmp(Orth,'y')    
    R = SR.y;
elseif strcmp(Orth,'z')    
    R = SR.z;  
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


function [rise] = SRfunc(G0,G1,R,SR)
if G0 == G1
    rise = G0*ones(1,length(R{1}{1}));
else
    for n = 1:125
        %if abs(G1-G0) < n*0.125+0.4375
        if abs(G1-G0) < n*SR.Ginc+SR.Gmin-SR.Ginc/2
            rise = G0 + (G1-G0)*R{n}{1};
            break;
        end
    end
end





        
        


