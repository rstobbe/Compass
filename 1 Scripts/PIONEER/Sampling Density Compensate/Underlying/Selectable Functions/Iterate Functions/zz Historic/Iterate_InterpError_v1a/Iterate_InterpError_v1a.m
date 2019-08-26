%=========================================================
% (Iterate_InterpError) - trilinear error interpolation
%=========================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_InterpError_v1a(Kmat,PROJdgn,PROJimp,iSDC,CTF,KRNprms,SDCS,SCRPTipt,err)

Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFvis',{SCRPTipt.labelstr})).entryvalue};
end

IT.Convfunc = 'mFCMexSingleR_v3';
IT.Accfunc = SCRPTipt(strcmp('Accfunc',{SCRPTipt.labelstr})).entrystr;
IT.Anlzfunc = SCRPTipt(strcmp('Anlzfunc',{SCRPTipt.labelstr})).entrystr;
IT.Breakfunc = SCRPTipt(strcmp('Breakfunc',{SCRPTipt.labelstr})).entrystr;
convfunc = str2func(IT.Convfunc);
accfunc = str2func(IT.Accfunc);
anlzfunc = str2func(IT.Anlzfunc);
breakfunc = str2func(IT.Breakfunc);

%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
[KszSS,KxSS,KySS,KzSS,CSS] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,SDCS.compkmax,PROJdgn.kstep,KRNprms.W,SDCS.SubSamp,'M2A');
[Ksz0,Kx0,Ky0,Kz0,C0] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,SDCS.compkmax,PROJdgn.kstep,KRNprms.W,1,'M2A');

%--------------------------------------
% Setup
%--------------------------------------
KRNprmsSS = KRNprms;
KRNprmsSS.W = KRNprmsSS.W*SDCS.SubSamp;
KRNprmsSS.res = KRNprmsSS.res*SDCS.SubSamp;
KRNprmsSS.iKern = 1/KRNprmsSS.res;
CONVprmsSS.chW = ceil((KRNprmsSS.W-2)/2);                    % with mFCMexSingleR_v3

KRNprms0 = KRNprms;
KRNprms0.W = KRNprms0.W;
KRNprms0.res = KRNprms0.res;
KRNprms0.iKern = 1/KRNprms0.res;
CONVprms0.chW = ceil((KRNprms0.W-2)/2);                    % with mFCMexSingleR_v3

StatLev = 3;
SDC = iSDC;
SDC = SDCMat2Arr(SDC,PROJdgn.nproj,PROJimp.npro);
DOVSS = CTF.ConvTFSS;
DOV = CTF.ConvTF;

for j = 1:500
    Status2('busy','Test',2);   
    [CV,~,~] = convfunc(Ksz0,Kx0,Ky0,Kz0,KRNprms0,SDC,CONVprms0,StatLev);       
    
    if strcmp(Vis,'On');
        figure(51);
        [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/SDCS.compkmax;
        plot(rads,SDC,'r*');
        title('SDC Values at Sampling Point Locations'); xlabel('relative radial dimension');
      
        figure(52); clf; hold on;
        plot(squeeze(DOV(C0,C0,:)),'b-*');
        plot(squeeze(CV(C0,C0,:)),'r*');
        figure(53); clf; hold on;
        plot(squeeze(DOV(:,C0,C0)),'b-*');
        plot(squeeze(CV(:,C0,C0)),'r*');
    end
    
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = convfunc(KszSS,KxSS,KySS,KzSS,KRNprmsSS,SDC,CONVprmsSS,StatLev);         
        
    rErr = CV./DOVSS;
    
    Status2('busy','Interpolate rErr',3);
    rErri = zeros(PROJdgn.nproj*PROJimp.npro,1);                                               
    for n = 1:PROJdgn.nproj*PROJimp.npro
        rErri(n) = trilin_interp(rErr,KxSS(n),KySS(n),KzSS(n));                           
    end
        
    acc = accfunc(j);
    SDC = ((1 ./ rErri).^acc) .* SDC;                                      
    %SDC(SDC > max(DOVSS)) = max(DOVSS);
    SDC(SDC < 0) = 0.001*max(DOVSS(:));  

    %[stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,PROJdgn,PROJimp,SDC,j);
    stop = 0;  
    if j == 5
        stop = 1;
    end
    if stop == 1
        break
    end    
end
SDCS.it = j;
SDCS.IT = IT;

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Stop Reason','0output',SDCS.stopping,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Iterations','0output',num2str(SDCS.it),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Centre Error','0output',num2str(SDCS.CErr(length(SDCS.CErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Average Error','0output',num2str(SDCS.AErr(length(SDCS.AErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sampling Eff','0output',num2str(SDCS.Eff(length(SDCS.Eff))),'0numout');

Status2('done','',2);

