%=========================================================
% 
%=========================================================

function [GSRI,err] = GSRI_TPIsepsegs_v2f_Func(GSRI,INPUT)

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
SRiseg = GSRI.SRiseg;
SRtwseg = GSRI.SRtwseg;
clear INPUT

%---------------------------------------------
% Common
%---------------------------------------------
[nproj,~,~] = size(G);

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
if GWFM.Gmaxinit > SRiseg.Gmax
    err.flag = 1;
    err.msg = ['Initial Grad Step (',num2str(GWFM.Gmaxinit),') Too Large for SR File'];
    return
end
if GWFM.Gmaxtwstep > SRtwseg.Gmax
    err.flag = 1;
    err.msg = ['Twisted Grad Steps (',num2str(GWFM.Gmaxtwstep),') Too Large for SR File'];
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
% SR timing
%---------------------------------------------
TGSR = StepResp_Timing(GWFM.qTscnr,SRiseg.N,SRiseg.t,SRtwseg.N,SRtwseg.t);

%---------------------------------------------
% Add Step Response to Gradient Waveforms
%---------------------------------------------
GSR = zeros(nproj,length(TGSR),3);    
for n = 1:nproj
    if strcmp(PROJimp.orient,'Axial');    
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),SRiseg,SRtwseg);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),SRiseg,SRtwseg);
        [GSR(n,:,3)] = StepResp_Grad('z',G(n,:,3),SRiseg,SRtwseg);
    elseif strcmp(PROJimp.orient,'Coronal');
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),SRiseg,SRtwseg);
        [GSR(n,:,2)] = StepResp_Grad('z',G(n,:,2),SRiseg,SRtwseg);
        [GSR(n,:,3)] = StepResp_Grad('y',G(n,:,3),SRiseg,SRtwseg);
    elseif strcmp(PROJimp.orient,'Sagittal');    
        [GSR(n,:,1)] = StepResp_Grad('z',G(n,:,1),SRiseg,SRtwseg);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),SRiseg,SSRtwseg);
        [GSR(n,:,3)] = StepResp_Grad('x',G(n,:,3),SRiseg,SRtwseg);
    end
    Status2('busy',['Add Gradient Step-Response Projection Number: ',num2str(n)],3);    
end
GSRI.TGSR = TGSR;
GSRI.GSR = GSR;
GSRI.gcoil = SRiseg.gcoil;
GSRI.graddel = SRiseg.graddel;

Status2('done','',2);
Status2('done','',3);


%=============================================
% StepResp_Timing
%=============================================
function [TGSR] = StepResp_Timing(qT,Niseg,tiseg,Ntwseg,ttwseg)
M = length(qT)-1;
TGSR = zeros(1,Niseg+(M-1)*Ntwseg);
TGSR(1:Niseg) = tiseg;                            
N0 = Niseg;
for m = 2:M                             
    TGSR(N0+1:N0+Ntwseg) = qT(m)+ttwseg;
    N0 = N0 + Ntwseg;
end
TGSR(N0+1) = qT(M)+(qT(M)-qT(M-1));

%=============================================
% StepResp_Grad
%=============================================
function [GSR] = StepResp_Grad(Orth,G,SRiseg,SRtwseg)
if strcmp(Orth,'x')
    Riseg = SRiseg.GSR(:,:,1);
    Rtwseg = SRtwseg.GSR(:,:,1);    
elseif strcmp(Orth,'y')    
    Riseg = SRiseg.GSR(:,:,2);
    Rtwseg = SRtwseg.GSR(:,:,2); 
elseif strcmp(Orth,'z')    
    Riseg = SRiseg.GSR(:,:,3);  
    Rtwseg = SRtwseg.GSR(:,:,3); 
end
Niseg = SRiseg.N;
Ntwseg = SRtwseg.N;

M = length(G(1,:));                                   
GSR = zeros(1,Niseg+(M-1)*Ntwseg);
[rise] = SRfunc(0,G(1),Riseg,SRiseg);
GSR(1:Niseg) = rise;
N0 = Niseg;
for m = 2:M                             
    [rise] = SRfunc(G(m-1),G(m),Rtwseg,SRtwseg);
    GSR(N0+1:N0+Ntwseg) = rise;
    N0 = N0 + Ntwseg;
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





        
        


