%=========================================================
% (v1b)
%       - remove PROJdgn
%       - move 'E' to anlzfunc
%       - move figures to anlzfunc
%=========================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_DblConv_v1b(Kmat,PROJimp,iSDC,DOV,KRNprms,SDCS,SCRPTipt,err)

IT.S2GConvfunc = 'mFCMexSingleR_v3';
IT.G2SConvfunc = 'mG2SMexSingleR_v3';
IT.Accfunc = SCRPTipt(strcmp('Accfunc',{SCRPTipt.labelstr})).entrystr;
IT.Anlzfunc = SCRPTipt(strcmp('Anlzfunc',{SCRPTipt.labelstr})).entrystr;
IT.Breakfunc = SCRPTipt(strcmp('Breakfunc',{SCRPTipt.labelstr})).entrystr;
S2Gconvfunc = str2func(IT.S2GConvfunc);
G2Sconvfunc = str2func(IT.G2SConvfunc);
accfunc = str2func(IT.Accfunc);
anlzfunc = str2func(IT.Anlzfunc);
breakfunc = str2func(IT.Breakfunc);

FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJimp.nproj,PROJimp.npro,SDCS.compkmax,PROJimp.kstep,FwdKern.W,SDCS.SubSamp,'M2A');
normrad = (((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2).^(1/2));
maxnormrad = max(normrad(:));

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
%DOV = SDCMat2Arr(DOV,PROJimp.nproj,PROJimp.npro);
for j = 1:500   
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,SDC,FwdConvPrms,StatLev);                
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [W,~,~] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,CV,RvsConvPrms,StatLev);          
    acc = accfunc(j);
    SDC = ((DOV ./ W).^acc) .* SDC;                                      
    SDC(SDC < 0) = 0.001;  
    [E,SDCS,SCRPTipt,err] = anlzfunc(Kmat,DOV,W,SDC,SDCS,PROJimp,j,SCRPTipt,err);    
    [stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,PROJimp,PROJimp,SDC,j);
    if stop == 1
        break
    end 
end

%--------------------------------------
% Return
%--------------------------------------
SDCS.it = j;
SDCS.IT = IT;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Stop Reason','0output',SDCS.stopping,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Iterations','0output',num2str(SDCS.it),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Centre Error','0output',num2str(SDCS.CErr(length(SDCS.CErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Average Error','0output',num2str(SDCS.AErr(length(SDCS.AErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sampling Eff','0output',num2str(SDCS.Eff(length(SDCS.Eff))),'0numout');

Status2('done','',2);

