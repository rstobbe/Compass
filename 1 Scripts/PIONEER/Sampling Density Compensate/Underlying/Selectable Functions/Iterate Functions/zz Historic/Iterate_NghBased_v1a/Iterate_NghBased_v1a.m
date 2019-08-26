%===========================================================================================
%  
%===========================================================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_NghBased_v1a(Kmat,PROJdgn,PROJimp,iSDC,CTF,KRNprms,SDCS,SCRPTipt,err)

%(Kmat,iSDC,AIDrp,AIDimp,PROJdgn,SDCS,SCRPTipt,SDconv,KRNprms,visuals)

Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFvis',{SCRPTipt.labelstr})).entryvalue};
end

SDCS.FindFunc = SCRPTipt(strcmp('FindFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.KernValFunc = SCRPTipt(strcmp('KernValFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.ConvFunc = SCRPTipt(strcmp('ConvFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.AccFunc = SCRPTipt(strcmp('AccFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.AnlzFunc = SCRPTipt(strcmp('AnlzFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.BreakFunc = SCRPTipt(strcmp('BreakFunc',{SCRPTipt.labelstr})).entrystr;
findfunc = str2func(SDCS.FindFunc);
kernvalfunc = str2func(SDCS.KernValFunc);
convfunc = str2func(SDCS.ConvFunc);
accfunc = str2func(SDCS.AccFunc);
anlzfunc = str2func(SDCS.AnlzFunc);
breakfunc = str2func(SDCS.BreakFunc);

%--------------------------------------
% Find Neighbours
%--------------------------------------
Status2('busy','Find Neighbours',2);
[NGH,error,errorflag] = findfunc(Kmat,KRNprms.W,PROJimp);
if errorflag == 1
    err.flag = errorflag;
    err.msg = error;
    return
end

Status2('busy','Solve Kernel Values at Neighbour Locations',2);
[KrnVals,error,errorflag] = kernvalfunc(NGH,Kmat,KRNprms,SDCS,AIDrp);
if errorflag == 1
    return
end

SDC = iSDC;
for j = 1:2500

    if visuals == 0
        figure(99); clf(99); hold on;
        [ArrKmat] = KMat2Arr(Kmat,AIDrp.nproj,AIDrp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/AIDimp.impkmax;
        [ArrSDC] = DatMat2Arr(SDC,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrSDC,'r*');
        title('SDC Values at Sampling Point Locations');
    end
    
    Status2('busy',['Iteration: ',num2str(j)],2);
    CV = convfunc(NGH,KrnVals,SDC,AIDrp);    

    acc = accfunc(j);
    SDC = ((DOV ./ CV).^acc) .* SDC;                                      
    SDC(SDC > max(SDconv)) = max(SDconv);
    SDC(SDC < 0) = 0.001*max(SDconv);  
    E = 1 - (DOV ./ CV);
    SDCS = anlzfunc(SDCS,E,AIDrp,SDC,j);

    if visuals == 0
        figure(100); clf(100); hold on;
        plot(SDCS.ConvTFRad,SDconv,'b-*');
        [ArrCV] = DatMat2Arr(CV,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrCV,'r*');
        title('Output Values at Sampling Point Locations');
        
        figure(101); clf(101); hold on;
        [ArrE] = DatMat2Arr(E,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrE*100,'r*');
        title('Error (%) at Sampling Point Locations');
    end

    [stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,AIDrp,SDC,j);
    if stop == 1
        break
    end    
end
SDCS.it = j;
Status2('done','',2);

SDC = SDCMat2Arr(SDC,AIDrp.nproj,AIDrp.npro);

M = length(SCRPTipt)+1;
n = M;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'Stop Reason';
SCRPTipt(n).entrystr = SDCS.stopping;
SCRPTipt(n).entrystyle = '0text';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'Iterations';
SCRPTipt(n).entrystr = num2str(SDCS.it);
SCRPTipt(n).entrystyle = '0text';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'Centre Error';
SCRPTipt(n).entrystr = num2str(SDCS.CErr(length(SDCS.CErr)));
SCRPTipt(n).entrystyle = '0text';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'Average Error';
SCRPTipt(n).entrystr = num2str(SDCS.AErr(length(SDCS.AErr)));
SCRPTipt(n).entrystyle = '0text';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'Sampling Eff';
SCRPTipt(n).entrystr = num2str(SDCS.Eff(length(SDCS.Eff)));
SCRPTipt(n).entrystyle = '0text';

