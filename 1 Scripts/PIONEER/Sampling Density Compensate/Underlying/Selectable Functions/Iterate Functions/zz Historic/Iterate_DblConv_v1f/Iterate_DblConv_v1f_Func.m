%=========================================================
% 
%=========================================================

function [IT,err] = Iterate_DblConv_v1f_Func(IT,INPUT)

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
iSDC = INPUT.IE.iSDC;
DOV = INPUT.CTFV.DOV;
FwdKern = INPUT.KRNprms.FwdKern;
RvsKern = INPUT.KRNprms.RvsKern;
ACC = IT.ACC;
ANLZ = IT.ANLZ;
BRK = IT.BRK;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
npro = PROJimp.npro;

%---------------------------------------------
% Define Functions
%---------------------------------------------
IT.S2GConvfunc = 'mFCMexSingleR_v3';
IT.G2SConvfunc = 'mG2SMexSingleR_v3';
S2Gconvfunc = str2func(IT.S2GConvfunc);
G2Sconvfunc = str2func(IT.G2SConvfunc);
accfunc = str2func([IT.Accfunc,'_Func']);
anlzfunc = str2func([IT.Anlzfunc,'_Func']);
breakfunc = str2func([IT.Breakfunc,'_Func']);

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
SDC = iSDC;
SDC(r > (kmax + PROJdgn.kstep/2)) = 0;

%--------------------------------------
% Iterate
%--------------------------------------
StatLev = 3;
SDC = SDCMat2Arr(SDC,PROJimp.nproj,PROJimp.npro);
SDC0 = SDC;
for j = 1:500   

    %--------------------------------------
    % Convolve
    %--------------------------------------
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,SDC,FwdConvPrms,StatLev);                
    CV = CV/(FwdKern.convscaleval);
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [W,~,~] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,CV,RvsConvPrms,StatLev);          
    W = W/(RvsKern.convscaleval*SDCS.SubSamp^3);
    
    %--------------------------------------
    % Accelerate 
    %--------------------------------------
    INPUT.j = j;
    [ACC,err] = accfunc(ACC,INPUT);
    if err.flag
        return
    end
    clear INPUT
    acc = ACC.acc;
    
    %--------------------------------------
    % Calculate SDC
    %--------------------------------------
    E = (W ./ DOV) - 1;
    E(E < -1) = -1;
    E(E > 1) = 1;
    Wzerocor = W;
    Wzerocor(Wzerocor < 0) = 0.001;     
    SDC = ((DOV ./ Wzerocor).^acc) .* SDC;                                      
    SDC(SDC < 0) = 0.001;  
    SDC(SDC < (1/IT.maxrelchange)*SDC0) = (1/IT.maxrelchange)*SDC0(SDC < (1/IT.maxrelchange)*SDC0);
    SDC(SDC > IT.maxrelchange*SDC0) = IT.maxrelchange*SDC0(SDC > IT.maxrelchange*SDC0);
    rSDCchg = SDC./SDC0;
     
    %--------------------------------------
    % Analysis
    %--------------------------------------
    INPUT.IMP = IMP;
    INPUT.E = E;
    INPUT.DOV = DOV;
    INPUT.W = W;
    INPUT.SDC = SDC;
    INPUT.rSDCchg = rSDCchg;
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
    INPUT.E = E;
    INPUT.j = j;
    INPUT.ANLZ = ANLZ;
    [BRK,err] = breakfunc(BRK,INPUT);
    if err.flag
        return
    end
    clear INPUT
    if BRK.stop == 1
        break
    end
    
    %--------------------------------------
    % Save iteration as previous
    %-------------------------------------- 
    SDC0 = SDC;
end

%--------------------------------------
% Return
%--------------------------------------
IT.ACC = ACC;
IT.ANLZ = ANLZ;
IT.BRK = BRK;
IT.SDC = SDC;

%--------------------------------------
% Panel
%--------------------------------------

Status2('done','',2);

