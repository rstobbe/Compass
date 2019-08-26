%====================================================
% for use with 'PostGradEddyMulti_v1' Sequence
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PostGradEddyMulti_v1b(SCRPTipt,SCRPTGBL)

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
FileGradDel1 = SCRPTipt(strcmp('File_GradDel1',{SCRPTipt.labelstr})).runfuncoutput{1};
FileGradDel2 = SCRPTipt(strcmp('File_GradDel2',{SCRPTipt.labelstr})).runfuncoutput{1};
GDVis = SCRPTipt(strcmp('GradDel Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(GDVis)
    GDVis = SCRPTipt(strcmp('GradDel Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('GradDel Vis',{SCRPTipt.labelstr})).entryvalue};
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
[Trans1,Trans2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3(FileGradDel1,FileGradDel2,'Transient',Sys,'PostGradEddyMulti_v1',ExpDisp);
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
ind1 = find(expT>gstart,1,'first');
ind2 = find(expT>gstop,1,'first');
[Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2);

%-------------------------------------
% Subtract background and separate
%-------------------------------------
GTrans = zeros(size(Bloc1));
B0Trans1 = zeros(size(Bloc1));
B0Trans2 = zeros(size(Bloc1));
meanGTrans = zeros(size(Params.gofftime));
meanB0Trans1 = zeros(size(Params.gofftime));
meanB0Trans2 = zeros(size(Params.gofftime));
[nexp,nacq] = size(Params.gofftime);
for n = 1:nexp
    for m = 1:nacq
        Bloc1(n,:,m) = Bloc1(n,:,m) - permute(Output.NGBloc1,[2 1]);
        Bloc2(n,:,m) = Bloc2(n,:,m) - permute(Output.NGBloc2,[2 1]);
        GTrans(n,:,m) = (Bloc2(n,:,m) - Bloc1(n,:,m))/Sep;
        B0Trans1(n,:,m) = Bloc1(n,:,m) - GTrans(n,:,m)*Loc1;
        B0Trans2(n,:,m) = Bloc2(n,:,m) - GTrans(n,:,m)*Loc2;
        meanGTrans(n,m) = mean(GTrans(n,ind1:ind2,m));
        meanB0Trans1(n,m) = mean(B0Trans1(n,ind1:ind2,m));
        meanB0Trans2(n,m) = mean(B0Trans2(n,ind1:ind2,m));
    end
end

%-------------------------------------
% Plot Transient Field Along each Acq
%-------------------------------------
if strcmp(GTVis,'Full') || strcmp(GTVis,'Partial')
    while true
        answer = inputdlg({'nexp','nacq'},'Acquisitions to Plot',2,{'1','1'})
        break
        if strcmp(GTVis,'Full') || strcmp(GTVis,'Partial')
            Ghand = figure(320); hold on; box on;
            plot([0 max(expT)],[0 0],'k:'); 
            plot(expT,GTrans(nexp,:,nacq)*1000,Clr); 
            ylim([-max(abs(GTrans(nexp,:,nacq)))*1.1*1000 max(abs(GTrans(nexp,:,nacq)))*1.1*1000]);      
            plot([expT(ind1),expT(ind1)],[-100 100],'k:'); plot([expT(ind2),expT(ind2)],[-100 100],'k:');
            xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(expT)]); 
            title('Acq Transient Field (Gradient)');  
        end
        if strcmp(GTVis,'Full') || strcmp(GTVis,'Partial')
            B0hand = figure(321); hold on; box on;
            plot([0 max(expT)],[0 0],'k:'); 
            plot(expT,B0Trans1(nexp,:,nacq)*1000,Clr); plot(expT,B0Trans2(nexp,:,nacq)*1000,[Clr,':']); 
            ylim([-max(abs(B0Trans2(nexp,:,nacq)))*1.1*1000 max(abs(B0Trans2(nexp,:,nacq)))*1.1*1000]); 
            plot([expT(ind1),expT(ind1)],[-100 100],'k:'); plot([expT(ind2),expT(ind2)],[-100 100],'k:');
            xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(expT)]); 
            title('Acq Transient Field (B0)');
        end
        if isempty(Figs.handle)
            p = 1;
        else
            p = length(Figs)+1;
        end
        Figs(p).handle = Ghand;
        Figs(p).name = 'Acq Transient Field (Gradient)';
        p = p+1;
        Figs(p).handle = B0hand;
        Figs(p).name = 'Acq Transient Field (B0)';
    end
end

%-------------------------------------
% Define time associated with average field
%-------------------------------------
if isnan(Params.falltime)
    Params.falltime = Params.gval/120;
end
Params.gofftime = Params.gofftime + Params.falltime/2000000 + (gstop+gstart)/2000;

%-------------------------------------
% Define time associated with average field
%-------------------------------------    
testing = 0;            % should be exactly the same as the joined experiments below...
if testing == 1
    for n = 1:nexp
        aGhand = figure(500); hold on; box on; 
        plot([0 max(Params.gofftime(:))],[0 0],'k:'); 
        plot(Params.gofftime(n,:),meanGTrans(n,:)*1000,[Clr,'*']);
        xlim([0 max(Params.gofftime(:))]); 
        if max(abs(meanGTrans(:))*1000) < 2.5
            limG = 2.5;
        else
            limG = max(abs(meanGTrans(:))*1000)*1.1;
        end
        ylim([-limG limG]);
        xlabel('(seconds)'); ylabel('Gradient Evolution (uT/m)'); title('Average Field (Gradient)');

        aB0hand = figure(502); hold on; box on; 
        plot([0 max(Params.gofftime(:))],[0 0],'k:'); 
        plot(Params.gofftime(n,:),meanB0Trans1(n,:)*1000,[Clr,'*']);
        xlim([0 max(Params.gofftime(:))]); 
        if max(abs(meanB0Trans1(:))*1000) < 0.25
            limB0 = 0.25;
        else
            limB0 = max(abs(meanB0Trans1(:))*1000)*1.1;
        end
        ylim([-limB0 limB0]);
        xlabel('(seconds)'); ylabel('B0 Evolution (uT)'); title('Average Field (B0)');
    end
    if isempty(Figs.handle)
        p = 1;
    else
        p = length(Figs)+1;
    end
    Figs(p).handle = aGhand;
    Figs(p).name = 'Exp Transient Field (Gradient)';
    p = p+1;
    Figs(p).handle = aB0hand;
    Figs(p).name = 'Exp Transient Field (B0)';
end   

%-------------------------------------
% Join Experiments
%-------------------------------------
B0eddy1 = zeros(1,nacq*nexp);
Geddy = zeros(1,nacq*nexp);
gofftime = zeros(1,nacq*nexp);
for n = 1:nexp
    for m = 1:nacq
        gofftime((m-1)*nexp+n) = Params.gofftime(n,m);
        Geddy((m-1)*nexp+n) = meanGTrans(n,m);
        B0eddy1((m-1)*nexp+n) = meanB0Trans1(n,m);
    end
end

Params.B0cal = B0cal*Params.gval;
%-------------------------------------
% Plot Joined Experiments
%-------------------------------------
if max(abs(Geddy)*1000) < 2.5
    limG = 2.5;
else
    limG = max(abs(Geddy)*1000)*1.1;
end
if max(abs(B0eddy1)*1000) < 0.25
    limB0 = 0.25;
else
    limB0 = max(abs(B0eddy1)*1000)*1.1;
end
if strcmp(GDVis,'Full') || strcmp(GDVis,'Partial')
    h500 = figure(500); hold on; 
    plot([0 max(gofftime)],[0 0],'k:'); plot(gofftime,Geddy*1000,[Clr,'*']); 
    xlabel('(seconds)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(gofftime)]); title('PostGrad Field Analysis (Gradient uT/m)'); box on;
    ylim([-limG limG]);

    h501 = figure(501); hold on; 
    plot([0 max(gofftime)],[0 0],'k:'); plot(gofftime,100*Geddy/Params.gval,[Clr,'*']); 
    xlabel('(seconds)'); ylabel('Gradient Evolution (%)'); xlim([0 max(gofftime)]); title('PostGrad Field Analysis (Gradient %)'); box on;
    ylim([-0.1*limG/Params.gval 0.1*limG/Params.gval]);
    
    h502 = figure(502); hold on; 
    plot([0 max(gofftime)],[0 0],'k:');
    plot(gofftime,B0eddy1*1000,[Clr,'*']); 
    xlabel('(seconds)'); ylabel('B0 Evolution (uT)'); xlim([0 max(gofftime)]); title('PostGrad Field Analysis (B0 uT)'); box on;
    ylim([-limB0 limB0]);

    h503 = figure(503); hold on; 
    plot([0 max(gofftime)],[0 0],'k:');
    plot(gofftime,B0eddy1*1000/Params.B0cal,[Clr,'*']); 
    xlabel('(seconds)'); ylabel('B0 Evolution (%)'); xlim([0 max(gofftime)]); title('PostGrad Field Analysis (B0 %)'); box on;
    ylim([-limB0/Params.B0cal limB0/Params.B0cal]);

    if isempty(Figs(1).handle)
        p = 1;
    else
        p = length(Figs)+1;
    end
    Figs(p).handle = h500;
    Figs(p).name = 'PostGrad_Field_Analysis_(Gradient uTpm)';
    p = p+1;
    Figs(p).handle = h501;
    Figs(p).name = 'PostGrad_Field_Analysis_(Gradient %)';
    p = p+1;
    Figs(p).handle = h502;
    Figs(p).name = 'PostGrad_Field_Analysis_(B0 uT)';
    p = p+1;
    Figs(p).handle = h503;
    Figs(p).name = 'PostGrad_Field_Analysis_(B0 %)';   
end

%------------------------------------
% Regression
%-------------------------------------
if strcmp(DoReg,'Yes')
    func = str2func(regGfunc);
    [Gbeta,Gfit,SCRPTipt] = func(gofftime*1000,Geddy*1000,SCRPTipt,Params);
    figure(500); hold on;
    plot(Gfit.interptime/1000,Gfit.interpvals,[Clr,'-'],'linewidth',2);
    figure(501); hold on;
    plot(Gfit.interptime/1000,0.1*Gfit.interpvals/Params.gval,[Clr,'-'],'linewidth',2);
    
    func = str2func(regB0func);
    [B0beta,B0fit,SCRPTipt] = func(gofftime*1000,B0eddy1*1000,SCRPTipt,Params);
    figure(502); hold on;
    plot(B0fit.interptime/1000,B0fit.interpvals,[Clr,'-'],'linewidth',2);
    figure(503); hold on;
    plot(B0fit.interptime/1000,B0fit.interpvals/Params.B0cal,[Clr,'-'],'linewidth',2);
end
    
SCRPTGBL.TextBox = ExpDisp;
SCRPTGBL.Figs = Figs;
SCRPTGBL.Data = [];
