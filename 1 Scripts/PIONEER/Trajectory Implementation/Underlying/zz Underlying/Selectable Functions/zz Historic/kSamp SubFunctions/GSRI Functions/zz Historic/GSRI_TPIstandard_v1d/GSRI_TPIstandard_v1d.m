%=========================================================
% (v1d)
%       - update for RWSUI_BA
%=========================================================

function [SCRPTipt,GSRIout,err] = GSRI_TPIstandard_v1d(SCRPTipt,GSRI)

Status2('busy','Add Step Response',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(GSRI,'GSRIfunc_Data'))
    file = GSRI.('GSRI_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    else
        load(file);
        GSRI.GSRIfunc_Data.GSRI_File_Data = saveData;
    end
end

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
GSRIout = struct();
GSRIout.SR = GSRI.GSRIfunc_Data.GSRI_File_Data;
SR = GSRIout.SR;
PROJimp = GSRI.PROJimp;
G = GSRI.G;
GQNT = GSRI.GQNT;
GWFM = GSRI.GWFM;

%---------------------------------------------
% Tests
%---------------------------------------------
if GQNT.mingseg < SR.T
    err.flag = 1;
    err.msg = 'Gradient Quantization Too Small for Measured Step Response';
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
GSRIout.TGSR = TGSR;
GSRIout.GSR = GSR;
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

%=============================================
% SRfunc
%=============================================
function [rise] = SRfunc(G0,G1,R,SR)
if G0 == G1
    rise = G0*ones(1,length(R{1}{1}));
else
    for n = 1:125
        if abs(G1-G0) < n*SR.Ginc+SR.Gmin-SR.Ginc/2
            rise = G0 + (G1-G0)*R{n}{1};
            break;
        end
    end
end





        
        


