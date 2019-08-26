%====================================================
% (v1c)
%   - just RWSUI related changes
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PreGradEddy_v1c(SCRPTipt,SCRPTGBL)

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
GTVis = SCRPTipt(strcmp('GradTrans Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(GTVis)
    GTVis = SCRPTipt(strcmp('GradTrans Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('GradTrans Vis',{SCRPTipt.labelstr})).entryvalue};
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
regGfunc = SCRPTipt(strcmp('Reg_Grad',{SCRPTipt.labelstr})).entrystr;
regB0func = SCRPTipt(strcmp('Reg_B0',{SCRPTipt.labelstr})).entrystr;
psbgfunc = SCRPTipt(strcmp('Pos / Bgrnd',{SCRPTipt.labelstr})).entrystr;

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
meanBGGrad = Output.meanBGGrad;
meanBGB0 = Output.meanBGB0;
visuals.colour = Clr;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[Trans1,Trans2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3(SCRPTGBL.File_Grad1.FIDLoc,SCRPTGBL.File_Grad2.FIDLoc,'During',Sys,'PreGradEddy_v1',ExpDisp);
set(findobj('tag','TestBox'),'string',ExpDisp);
if errorflag == 1
    err.msg = error;
    return
end
if strcmp(GTVis,'Full')
    visuals.figno = 300;
    visuals.title = 'Transient Field';
else
    visuals.figno = 0;
end
[PH1,PH2,Figs] = PhaseEvolution_v2(Trans1,Trans2,expT,visuals,Figs);
if strcmp(GTVis,'Full')
    visuals.figno = 300;
    visuals.title = 'Transient Field';
else
    visuals.figno = 0;
end
ind1 = 1;
ind2 = 1;
[Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2);

NGBloc1 = interp1(Output.NGexpT,Output.NGBloc1,expT);
NGBloc2 = interp1(Output.NGexpT,Output.NGBloc2,expT);
Bloc1 = Bloc1 - NGBloc1;
Bloc2 = Bloc2 - NGBloc2;
GTrans = (Bloc2 - Bloc1)/Sep;
B0Trans1 = Bloc1 - GTrans*Loc1;         % B0Trans1 and B0Trans2 should be identical
B0Trans2 = Bloc2 - GTrans*Loc2;

if(strcmp(GTVis,'Full') || strcmp(GTVis,'Partial'))
    Ghand = figure(320); hold on; 
    plot([0 max(expT)],[0 0],'k:'); 
    plot(expT,GTrans,Clr);     
    ylim([-max(abs(GTrans)) max(abs(GTrans))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(expT)]); title('Transient Field (Gradient)');

    B0hand = figure(321); hold on; 
    plot([0 max(expT)],[0 0],'k:'); 
    plot(expT,B0Trans1*1000,Clr); 
    ylim([-max(abs(B0Trans1*1000)) max(abs(B0Trans1*1000))]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(expT)]); title('Transient Field (B0)');

    if isempty(Figs(1).handle)
        p = 1;
    else
        p = length(Figs)+1;
    end
    Figs(p).handle = Ghand;
    Figs(p).name = 'Transient Field (Gradient)';
    p = p+1;
    Figs(p).handle = B0hand;
    Figs(p).name = 'Transient Field (B0)';
end

%------------------------------------
% Regression
%-------------------------------------
Params.gval = 5;
Params.B0cal = B0cal*Params.gval;
if strcmp(DoReg,'Yes')
    func = str2func(regGfunc);
    [Gbeta,Gfit,SCRPTipt] = func(expT,GTrans*1000,SCRPTipt,Params);
    figure(320); hold on;
    plot(Gfit.interptime,Gfit.interpvals/1000,[Clr,'-'],'linewidth',2);
    %figure(501); hold on;
    %plot(Gfit.interptime/1000,0.1*Gfit.interpvals/Params.gval,[Clr,'-'],'linewidth',2);
    
    func = str2func(regB0func);
    [B0beta,B0fit,SCRPTipt] = func(expT,B0Trans1*1000,SCRPTipt,Params);
    figure(321); hold on;
    plot(B0fit.interptime,B0fit.interpvals,[Clr,'-'],'linewidth',2);
    %figure(503); hold on;
    %plot(B0fit.interptime,B0fit.interpvals/Params.B0cal,[Clr,'-'],'linewidth',2);
end
    

SCRPTGBL.TextBox = ExpDisp;
SCRPTGBL.Figs = Figs;
SCRPTGBL.Data = [];
