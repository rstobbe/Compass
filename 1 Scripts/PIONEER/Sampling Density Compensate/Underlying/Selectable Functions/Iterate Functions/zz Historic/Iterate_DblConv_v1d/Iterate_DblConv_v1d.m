%=========================================================
% (v1d)
%       - Update for RWSUI_BA
%=========================================================

function [SCRPTipt,ITout,err] = Iterate_DblConv_v1d(SCRPTipt,IT,err)

Status('busy','Perform SDC Iterations');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
ITout.S2GConvfunc = 'mFCMexSingleR_v3';
ITout.G2SConvfunc = 'mG2SMexSingleR_v3';
ITout.Accfunc = IT.('Accfunc').Func;
ITout.Anlzfunc = IT.('Anlzfunc').Func;
ITout.Breakfunc = IT.('Breakfunc').Func;
ITout.maxrelchange = str2double(IT.('MaxRelChange'));

%---------------------------------------------
% Setup up Called Functions
%---------------------------------------------
CallingPanel = IT.Struct.labelstr;
ACC = IT.('Accfunc');
if isfield(IT,([CallingPanel,'_Data']))
    if isfield(IT.([CallingPanel,'_Data']),('Accfunc_Data'))
        ACC.('Accfunc_Data') = IT.([CallingPanel,'_Data']).('Accfunc_Data');
    end
end
ANLZ = IT.('Anlzfunc');
if isfield(IT,([CallingPanel,'_Data']))
    if isfield(IT.([CallingPanel,'_Data']),('Anlzfunc_Data'))
        ANLZ.('Anlzfunc_Data') = IT.([CallingPanel,'_Data']).('Anlzfunc_Data');
    end
end
BRK = IT.('Breakfunc');
if isfield(IT,([CallingPanel,'_Data']))
    if isfield(IT.([CallingPanel,'_Data']),('Breakfunc_Data'))
        BRK.('Breakfunc_Data') = IT.([CallingPanel,'_Data']).('Breakfunc_Data');
    end
end

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = IT.PROJdgn;
PROJimp = IT.PROJimp;
Kmat = IT.Kmat;
SDCS = IT.SDCS;
iSDC = IT.IE.iSDC;
DOV = IT.CTF.DOV;
FwdKern = IT.KRNprms.FwdKern;
RvsKern = IT.KRNprms.RvsKern;

%---------------------------------------------
% Define Functions
%---------------------------------------------
S2Gconvfunc = str2func(ITout.S2GConvfunc);
G2Sconvfunc = str2func(ITout.G2SConvfunc);
accfunc = str2func(ITout.Accfunc);
anlzfunc = str2func(ITout.Anlzfunc);
breakfunc = str2func(ITout.Breakfunc);

%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
maxkmax = PROJimp.maxrelkmax*PROJdgn.kmax;
kernwid = FwdKern.W;
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJimp.nproj,PROJimp.npro,maxkmax,PROJdgn.kstep,kernwid,SDCS.SubSamp,'M2A');
%normrad = (((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2).^(1/2));
%maxnormrad = max(normrad(:));

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
% Iterate
%--------------------------------------
StatLev = 3;
SDC = iSDC;
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
    ACC.j = j;
    [SCRPTipt,ACCout,err] = accfunc(SCRPTipt,ACC);
    if err.flag
        return
    end
    acc = ACCout.acc;
    
    %--------------------------------------
    % Calculate SDC
    %--------------------------------------
    E = 1 - (DOV ./ W);
    SDC = ((DOV ./ W).^acc) .* SDC;                                      
    SDC(SDC < 0) = 0.001;  
    SDC(SDC < (1/ITout.maxrelchange)*SDC0) = (1/ITout.maxrelchange)*SDC0(SDC < (1/ITout.maxrelchange)*SDC0);
    SDC(SDC > ITout.maxrelchange*SDC0) = ITout.maxrelchange*SDC0(SDC > ITout.maxrelchange*SDC0);
    rSDCchg = SDC./SDC0;
     
    %--------------------------------------
    % Analysis
    %--------------------------------------
    ANLZ.Kmat = Kmat;
    ANLZ.E = E;
    ANLZ.DOV = DOV;
    ANLZ.W = W;
    ANLZ.SDC = SDC;
    ANLZ.rSDCchg = rSDCchg;
    ANLZ.PROJdgn = PROJdgn;
    ANLZ.PROJimp = PROJimp;
    ANLZ.j = j;
    [SCRPTipt,ANLZout,err] = anlzfunc(SCRPTipt,ANLZ); 
    if err.flag
        return
    end
    
    %--------------------------------------
    % Test for completion
    %--------------------------------------    
    BRK.E = E;
    BRK.PROJdgn = PROJdgn;
    BRK.PROJimp = PROJimp;
    BRK.j = j;
    [SCRPTipt,BRKout,err] = breakfunc(SCRPTipt,BRK);
    if err.flag
        return
    end
    if BRKout.stop == 1
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
ITout.ACC = ACCout;
ITout.ANLZ = ANLZout;
ITout.BRK = BRKout;
ITout.SDC = SDC;

%--------------------------------------
% Panel
%--------------------------------------

Status2('done','',2);

