%====================================================
%
%====================================================

function [SCRPTipt,Output,err] = PosBG2_v1a(SCRPTipt,SCRPTGBL,Input)

err.flag = 0;
Output = struct();

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
FilePosLoc1 = SCRPTipt(strcmp('File_PosLoc1',{SCRPTipt.labelstr})).runfuncoutput{1};
FilePosLoc2 = SCRPTipt(strcmp('File_PosLoc2',{SCRPTipt.labelstr})).runfuncoutput{1};
FileNoGrad1 = SCRPTipt(strcmp('File_NoGrad1',{SCRPTipt.labelstr})).runfuncoutput{1};
FileNoGrad2 = SCRPTipt(strcmp('File_NoGrad2',{SCRPTipt.labelstr})).runfuncoutput{1};
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
PlVis = SCRPTipt(strcmp('PosLoc Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(PlVis)
    PlVis = SCRPTipt(strcmp('PosLoc Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('PosLoc Vis',{SCRPTipt.labelstr})).entryvalue};
end
BGVis = SCRPTipt(strcmp('NoGrad Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(BGVis)
    BGVis = SCRPTipt(strcmp('NoGrad Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('NoGrad Vis',{SCRPTipt.labelstr})).entryvalue};
end
Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(Clr)
    Clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end
plstart = str2double(SCRPTipt(strcmp('PLstart (ms)',{SCRPTipt.labelstr})).entrystr);
plstop = str2double(SCRPTipt(strcmp('PLstop (ms)',{SCRPTipt.labelstr})).entrystr);

Figs = Input.Figs;
meanBGGrad = 0;
visuals.colour = Clr;
for w = 1:2
    %-------------------------------------
    % Determine Locations
    %-------------------------------------
    ExpDisp = [];
    [PosLoc1,PosLoc2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v2(FilePosLoc1,FilePosLoc2,'PosLoc',Sys,'',ExpDisp);
    if errorflag == 1
        err.flag = 1;
        err.msg = error;
        return
    end
    glocval = Params.gval + meanBGGrad;
    if strcmp(PlVis,'Full')
        visuals.figno = 100;
        visuals.title = 'Position Location';
    else
        visuals.figno = 0;
    end
    [PH1,PH2,Figs] = PhaseEvolution_v2(PosLoc1,PosLoc2,expT,visuals,Figs);
    if strcmp(PlVis,'Full') || strcmp(PlVis,'Partial') 
        visuals.figno = 100;
        visuals.title = 'Position Location';
    else
        visuals.figno = 0;
    end
    ind1 = find(expT>plstart,1,'first');
    ind2 = find(expT>plstop,1,'first');
    [Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2);
    Loc1 = mean(Bloc1(ind1:ind2))/glocval;
    Loc2 = mean(Bloc2(ind1:ind2))/glocval;
    Sep = Loc2 - Loc1;

    %-------------------------------------
    % Determine Background Fields
    %-------------------------------------
    [BG1,BG2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v2(FileNoGrad1,FileNoGrad2,'BackGrad',Sys,'',ExpDisp);
    if errorflag == 1
        err.flag = 1;
        err.msg = error;
        return
    end
    if strcmp(BGVis,'Full')
        visuals.figno = 200;
        visuals.title = 'Background Field';
    else
        visuals.figno = 0;
    end
    [PH1,PH2,Figs] = PhaseEvolution_v2(BG1,BG2,expT,visuals,Figs);
    if strcmp(BGVis,'Full') || strcmp(BGVis,'Partial') 
        visuals.figno = 200;
        visuals.title = 'Background Field';
    else
        visuals.figno = 0;
    end
    ind1 = 1;
    ind2 = length(expT);    
    [Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2);  

    Output.NGexpT = expT;
    Output.NGBloc1 = smooth(Bloc1,15,'moving');
    Output.NGBloc2 = smooth(Bloc2,15,'moving');
    if strcmp(BGVis,'Full') || strcmp(BGVis,'Partial') 
        figure(210); hold on;
        plot(expT,Output.NGBloc1*1000,'linewidth',2);
        plot(expT,Output.NGBloc2*1000,'linewidth',2);
    end
    
    BGGrad = (Bloc2 - Bloc1)/Sep;
    if strcmp(BGVis,'Full') || strcmp(BGVis,'Partial') 
        handle = figure(220); hold on; plot([0 max(expT)],[0 0],'k:'); plot(expT,BGGrad,Clr); ylim([-max(abs(BGGrad))*1.1 max(abs(BGGrad))*1.1]);
        plot([expT(ind1),expT(ind1)],[-1 1],'k:'); plot([expT(ind2),expT(ind2)],[-1 1],'k:');
        xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(expT)]); title('Background Field (Gradient)');
        n = length(Figs)+1;
        Figs(n).handle = handle;
        Figs(n).name = 'Background Field (Gradient)';
    end
    BGB01 = Bloc1 - BGGrad*Loc1;
    BGB02 = Bloc2 - BGGrad*Loc2;
    %test1 = mean(BGB01(ind1:ind2));     %test1 and test2 should be identical
    %test2 = mean(BGB02(ind1:ind2));
    if strcmp(BGVis,'Full') || strcmp(BGVis,'Partial') 
        handle = figure(221); hold on; plot([0 max(expT)],[0 0],'k:'); plot(expT,BGB01*1000,Clr); plot(expT,BGB02*1000,[Clr,':']); ylim([-max(abs(BGB01*1000))*1.1 max(abs(BGB01*1000))*1.1]);
        plot([expT(ind1),expT(ind1)],[-1 1],'k:'); plot([expT(ind2),expT(ind2)],[-1 1],'k:');
        xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(expT)]); title('Background Field (B0)');
        n = length(Figs)+1;
        Figs(n).handle = handle;
        Figs(n).name = 'Background Field (B0)';
    end
    meanBGGrad = mean(BGGrad(ind1:ind2));
    meanBGB0 = mean([BGB01(ind1:ind2) BGB02(ind1:ind2)]);
end

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Loc1 (cm)','0output',Loc1*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Loc2 (cm)','0output',Loc2*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sep (cm)','0output',Sep*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'BGGrad (mT/m)','0output',meanBGGrad,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'BGB0 (uT)','0output',meanBGB0*1000,'0text');

Output.ExpDisp = ExpDisp;
Output.Figs = Figs;
Output.Loc1 = Loc1;
Output.Loc2 = Loc2;
Output.Sep = Sep;
Output.meanBGGrad = meanBGGrad;
Output.meanBGB0 = meanBGB0;

