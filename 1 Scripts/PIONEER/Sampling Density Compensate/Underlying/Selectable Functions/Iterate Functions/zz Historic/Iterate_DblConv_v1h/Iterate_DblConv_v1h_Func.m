%=========================================================
% 
%=========================================================

function [IT,err] = Iterate_DblConv_v1h_Func(IT,INPUT)

Status2('busy','Perform SDC Iterations',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.impPROJdgn;
PROJimp = IMP.PROJimp;
Kmat = IMP.Kmat;
SDCS = INPUT.SDCS;
SDC0 = INPUT.IE.iSDC;
iterations = INPUT.IE.iterations;
DOV = INPUT.CTFV.DOV;
FwdKern = INPUT.KRNprms.FwdKern;
RvsKern = INPUT.KRNprms.RvsKern;
CALC = IT.CALC;
ANLZ = IT.ANLZ;
BRK = IT.BRK;
clear INPUT;

%---------------------------------------------
% Define Functions
%---------------------------------------------
if strcmp(SDCS.Device,'Mex')
    if strcmp(SDCS.Precision,'Double')
        IT.S2GConvfunc = 'mS2GMexDoubleR_v3a';
        IT.G2SConvfunc = 'mG2SMexDoubleR_v3b';
    elseif strcmp(SDCS.Precision,'Single')
        IT.S2GConvfunc = 'mS2GMexSingleR_v3a';
        IT.G2SConvfunc = 'mG2SMexSingleR_v3b';
    end
elseif strcmp(SDCS.Device,'CUDA')
    CUDAdevice = 1;
    if strcmp(SDCS.Precision,'Double')
        IT.S2GConvfunc = 'mS2GCUDADoubleR_v4f';
        IT.G2SConvfunc = 'mG2SCUDADoubleR_v4f';
    elseif strcmp(SDCS.Precision,'Single')
        IT.S2GConvfunc = 'mS2GCUDASingleR_v4f';
        IT.G2SConvfunc = 'mG2SCUDASingleR_v4f';
    end
end
S2Gconvfunc = str2func(IT.S2GConvfunc);
G2Sconvfunc = str2func(IT.G2SConvfunc);
calcfunc = str2func([IT.Calcfunc,'_Func']);
anlzfunc = str2func([IT.Anlzfunc,'_Func']);
breakfunc = str2func([IT.Breakfunc,'_Func']);

%--------------------------------------
% Setup
%--------------------------------------
BRK.stop = 0;

%--------------------------------------
% Setup Fwd Conv
%--------------------------------------
zWtest = 2*(ceil((FwdKern.W*SDCS.SubSamp-2)/2)+1)/SDCS.SubSamp;                       
if zWtest > FwdKern.zW
    error('Kernel Zero-Fill Too Small');
end
FwdKern.W = FwdKern.W*SDCS.SubSamp;
FwdKern.res = FwdKern.res*SDCS.SubSamp;
if round(1e9/FwdKern.res) ~= 1e9*round(1/FwdKern.res)
    error('should not get here - already tested');
end    
FwdKern.iKern = round(1/FwdKern.res);
FwdConvPrms.chW = ceil((FwdKern.W-2)/2);                   

%--------------------------------------
% Setup Rvs Conv
%--------------------------------------
zWtest = 2*(ceil((RvsKern.W*SDCS.SubSamp-2)/2)+1)/SDCS.SubSamp;                       
if zWtest > RvsKern.zW
    error('Kernel Zero-Fill Too Small');
end
RvsKern.W = RvsKern.W*SDCS.SubSamp;
RvsKern.res = RvsKern.res*SDCS.SubSamp;
if round(1e9/RvsKern.res) ~= 1e9*round(1/RvsKern.res)
    error('should not get here - already tested');
end    
RvsKern.iKern = round(1/RvsKern.res);
RvsConvPrms.chW = ceil((RvsKern.W-2)/2);                    

%--------------------------------------
% Use largest chW
%--------------------------------------
if FwdConvPrms.chW >= RvsConvPrms.chW
    chW = FwdConvPrms.chW;
else
    chW = RvsConvPrms.chW;
end
    
%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4b(Kmat,PROJimp.nproj,PROJimp.npro,PROJdgn.kstep,chW,SDCS.SubSamp,'M2A');

%--------------------------------------
% zero SDC beyond kmax
%--------------------------------------
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
kmax = PROJdgn.kmax*PROJimp.meanrelkmax;       % make sure not instep (kstep/2) version (i.e. mean vals at trajectory ends)         
SDC0(r > (kmax + PROJdgn.kstep/2)) = 0;

%--------------------------------------
% Iterate
%--------------------------------------
StatLev = 3;
SDC0 = SDCMat2Arr(SDC0,PROJimp.nproj,PROJimp.npro);
for j = iterations + 1:500   

    Status2('busy',['Iteration: ',num2str(j-1)],2);       
    %--------------------------------------
    % Convolve
    %--------------------------------------
    [CV,~] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,SDC0,FwdConvPrms,StatLev,CUDAdevice);                
    CV = CV/(FwdKern.convscaleval);
    [W,~] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,CV,RvsConvPrms,StatLev,CUDAdevice);          
    W = W/(RvsKern.convscaleval*SDCS.SubSamp^3);
        
    %--------------------------------------
    % Positive Normalize 
    %--------------------------------------    
    if not(isempty(find(W < 0,1)))
        W(W < 0) = 0.001;
        PositiveNorm = 'Yes'
        IT.PosNorm = PositiveNorm;
        %error();
    end 

    %--------------------------------------
    % Analysis
    %--------------------------------------
    INPUT.IMP = IMP;
    INPUT.DOV = DOV;
    INPUT.W = W;
    INPUT.SDC0 = SDC0;
    INPUT.j = j;
    [ANLZ,err] = anlzfunc(ANLZ,INPUT); 
    if err.flag
        return
    end
    clear INPUT    

    %--------------------------------------
    % Test for completion
    %--------------------------------------    
    INPUT.IMP = IMP;
    INPUT.j = j;
    INPUT.ANLZ = ANLZ;
    [BRK,err] = breakfunc(BRK,INPUT);
    if err.flag
        return
    end
    clear INPUT    
    if BRK.stop == 1
        BRK = BRK
        break
    end
    
    %--------------------------------------
    % Calculate SDC 
    %--------------------------------------
    INPUT.IMP = IMP;
    INPUT.DOV = DOV;
    INPUT.W = W;
    INPUT.SDC0 = SDC0;
    INPUT.j = j;
    [CALC,err] = calcfunc(CALC,INPUT);
    if err.flag
        return
    end
    clear INPUT
    SDC = CALC.SDC;
    
    %--------------------------------------
    % Save iteration as previous
    %-------------------------------------- 
    SDC0 = SDC;
end

%--------------------------------------
% Return
%--------------------------------------
IT.CALC = CALC;
IT.ANLZ = ANLZ;
IT.BRK = BRK;
IT.SDC = SDC;

%--------------------------------------
% Panel
%--------------------------------------
IT.PanelOutput = [ANLZ.PanelOutput;BRK.PanelOutput];

Status2('done','',2);

