%====================================================
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PostGradEddySingle_v1a(SCRPTipt,SCRPTGBL)

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
TFVis = SCRPTipt(strcmp('TransFld Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(TFVis)
    TFVis = SCRPTipt(strcmp('TransFld Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('TransFld Vis',{SCRPTipt.labelstr})).entryvalue};
end
MAVis = SCRPTipt(strcmp('MultAcq Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(MAVis)
    MAVis = SCRPTipt(strcmp('MultAcq Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('MultAcq Vis',{SCRPTipt.labelstr})).entryvalue};
end
DoReg = SCRPTipt(strcmp('Do Regress',{SCRPTipt.labelstr})).entrystr;
if iscell(DoReg)
    DoReg = SCRPTipt(strcmp('Do Regress',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Do Regress',{SCRPTipt.labelstr})).entryvalue};
end
Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(Clr)
    Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end
B0cal = str2double(SCRPTipt(strcmp('B0 (1% -> uTpG)',{SCRPTipt.labelstr})).entrystr);
filtGfunc = SCRPTipt(strcmp('Filt_Grad',{SCRPTipt.labelstr})).entrystr;
filtB0func = SCRPTipt(strcmp('Filt_B0',{SCRPTipt.labelstr})).entrystr;
regGfunc = SCRPTipt(strcmp('Reg_Grad',{SCRPTipt.labelstr})).entrystr;
regB0func = SCRPTipt(strcmp('Reg_B0',{SCRPTipt.labelstr})).entrystr;
psbgfunc = SCRPTipt(strcmp('Pos / Bgrnd',{SCRPTipt.labelstr})).entrystr;
gstart = str2double(SCRPTipt(strcmp('Gstart (ms)',{SCRPTipt.labelstr})).entrystr);
gstop = str2double(SCRPTipt(strcmp('Gstop (ms)',{SCRPTipt.labelstr})).entrystr);

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
Figs(1).handle = [];
Figs(1).name = '';
Input.Figs = Figs;
func = str2func(psbgfunc);
[SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);

ExpDisp = Output.ExpDisp;
Figs = Output.Figs;
Loc1 = Output.Loc1;
Loc2 = Output.Loc2;
Sep = Output.Sep;
visuals.colour = Clr;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[Trans1,Trans2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3(SCRPTGBL.File_GradDel1.FIDLoc,SCRPTGBL.File_GradDel2.FIDLoc,'Transient',Sys,'PostGradEddySingle_v1',ExpDisp);
set(findobj('tag','TestBox'),'string',ExpDisp);
if errorflag == 1
    err.msg = error;
    return
end
if strcmp(TFVis,'On')
    visuals.figno = 300;
    visuals.title = 'Transient Field';
else
    visuals.figno = 0;
end
[PH1,PH2,Figs] = PhaseEvolution_v2(Trans1,Trans2,expT,visuals,Figs);
if strcmp(TFVis,'On')
    visuals.figno = 300;
    visuals.title = 'Transient Field';
else
    visuals.figno = 0;
end
ind1 = find(expT>gstart,1,'first');
ind2 = find(expT>gstop,1,'first');
[Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2);

%-------------------------------------
% Subtract background and separate
%-------------------------------------
[nexp,~] = size(Trans1);
for n = 1:nexp
    Bloc1(n,:) = Bloc1(n,:) - permute(Output.NGBloc1,[2 1]);
    Bloc2(n,:) = Bloc2(n,:) - permute(Output.NGBloc2,[2 1]);
    GTrans(n,:) = (Bloc2(n,:) - Bloc1(n,:))/Sep;
    B0Trans1(n,:) = Bloc1(n,:) - GTrans(n,:)*Loc1;
    B0Trans2(n,:) = Bloc2(n,:) - GTrans(n,:)*Loc2;
end

%-------------------------------------
% Join
%-------------------------------------
B0 = NaN*zeros(nexp,1000*Params.gofftime(nexp)/Params.dwell+ind2);
G = NaN*zeros(size(B0));
for n = 1:nexp 
    start = 1000*Params.gofftime(n)/Params.dwell + ind1;
    B0(n,start:start+ind2-ind1) = B0Trans1(n,ind1:ind2)*1000;
    G(n,start:start+ind2-ind1) = GTrans(n,ind1:ind2)*1000;
end
for m = 1:length(B0)
    totB = 0;
    totG = 0;
    vals = 0;
    for n = 1:nexp
        if not(isnan(B0(n,m)))
            totB = totB + B0(n,m);
            totG = totG + G(n,m);
            vals = vals + 1;
        end
    end
    if vals == 0
        B0ave(m) = NaN;
        Gave(m) = NaN;
    else
        B0ave(m) = totB/vals;
        Gave(m) = totG/vals;
    end
end
T = (0:Params.dwell:Params.dwell*(length(B0)-1));

%-------------------------------------
% Plot
%-------------------------------------
mGhand = figure(400); hold on; 
plot([0 T(length(T))],[0 0]*1000,'k:'); 
plot(T,Gave,Clr);
gtylim = max(abs(Gave))*1.1; ylim([-gtylim gtylim]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); 
xlim([min(expT(ind1:ind2)+Params.gofftime(1)*1000) max(expT(ind1:ind2)+Params.gofftime(nexp)*1000)]); 
title('Transient Field (Gradient)');
mB0hand = figure(401); hold on; 
plot([0 T(length(T))],[0 0]*1000,'k:');  
plot(T,B0ave,Clr);
b0tylim = max(abs(B0ave))*1.1; ylim([-b0tylim b0tylim]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); 
xlim([min(expT(ind1:ind2)+Params.gofftime(1)*1000) max(expT(ind1:ind2)+Params.gofftime(nexp)*1000)]); 
title('Transient Field (B0)');
if isempty(Figs(1).handle)
    p = 1;
else
    p = length(Figs)+1;
end
Figs(p).handle = mGhand;
Figs(p).name = 'Transient Field (Gradient)';
p = p+1;
Figs(p).handle = mB0hand;
Figs(p).name = 'Transient Field (B0)';   

%-------------------------------------
% Plot
%-------------------------------------
if strcmp(MAVis,'On')
    for n = 1:nexp   
        figure(400);
        plot(expT(ind1:ind2)+Params.gofftime(n)*1000,GTrans(n,ind1:ind2)*1000,'b');       
        figure(401);
        plot(expT(ind1:ind2)+Params.gofftime(n)*1000,B0Trans1(n,ind1:ind2)*1000,'b'); 
        plot(expT(ind1:ind2)+Params.gofftime(n)*1000,B0Trans2(n,ind1:ind2)*1000,'b:'); 
    end    
end

%-------------------------------------
% Filter
%-------------------------------------
start = 1000*Params.gofftime(1,1)/Params.dwell + ind1;
Gave2 = Gave(start:length(Gave));
func = str2func(filtGfunc);
[Gfilt,SCRPTipt] = func(Gave2,Params,SCRPTipt);
Gfilt = [zeros(1,start-1) Gfilt];
figure(400); hold on;
plot(T,real(Gfilt),'r','linewidth',2)
plot(T,imag(Gfilt),'r')

B0ave2 = B0ave(start:length(B0ave));
func = str2func(filtB0func);
[B0filt,SCRPTipt] = func(B0ave2,Params,SCRPTipt);
B0filt = [zeros(1,start-1) B0filt];
figure(401); hold on;
plot(T,real(B0filt),'r','linewidth',2)
plot(T,imag(B0filt),'r')

%------------------------------------
% Regression
%-------------------------------------
Params.B0cal = B0cal*Params.gval;
if strcmp(DoReg,'Yes')
    func = str2func(regGfunc);
    [Gbeta,Gfit,SCRPTipt] = func(T,real(Gfilt),SCRPTipt,Params);
    figure(400); hold on;
    plot(Gfit.interptime,Gfit.interpvals,'b-','linewidth',2);
    %figure(501); hold on;
    %plot(Gfit.interptime/1000,0.1*Gfit.interpvals/Params.gval,[Clr,'-'],'linewidth',2);
    
    func = str2func(regB0func);
    [B0beta,B0fit,SCRPTipt] = func(T,real(B0filt),SCRPTipt,Params);
    figure(401); hold on;
    plot(B0fit.interptime,B0fit.interpvals,'b-','linewidth',2);
    %figure(503); hold on;
    %plot(B0fit.interptime/1000,B0fit.interpvals/Params.B0cal,[Clr,'-'],'linewidth',2);
end

SCRPTGBL.TextBox = ExpDisp;
SCRPTGBL.Figs = Figs;
SCRPTGBL.Data = [];
