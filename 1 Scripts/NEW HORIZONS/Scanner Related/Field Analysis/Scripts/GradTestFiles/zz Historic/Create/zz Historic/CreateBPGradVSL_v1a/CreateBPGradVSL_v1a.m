%=====================================================
% 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateBPGradVSL_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

pregdur = str2double(SCRPTipt(strcmp('PreGDur (ms)',{SCRPTipt.labelstr})).entrystr);
gatmaxdur = str2double(SCRPTipt(strcmp('GatMaxDur (ms)',{SCRPTipt.labelstr})).entrystr);
intergdur = str2double(SCRPTipt(strcmp('InterGDur (ms)',{SCRPTipt.labelstr})).entrystr);
gstepdur = str2double(SCRPTipt(strcmp('GStepDur (us)',{SCRPTipt.labelstr})).entrystr);
gstepdur = gstepdur/1000;
gsl = str2double(SCRPTipt(strcmp('Gsl (mT/m/ms)',{SCRPTipt.labelstr})).entrystr);
gmax = str2double(SCRPTipt(strcmp('Gmax (mT/m)',{SCRPTipt.labelstr})).entrystr);
wrgrads = SCRPTipt(strcmp('Write Grads',{SCRPTipt.labelstr})).entrystr;
if iscell(wrgrads)
    wrgrads = SCRPTipt(strcmp('Write Grads',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Write Grads',{SCRPTipt.labelstr})).entryvalue};
end
wrgradfunc = SCRPTipt(strcmp('WrtGradFnc',{SCRPTipt.labelstr})).entrystr;
wrparamfunc = SCRPTipt(strcmp('WrtParamFnc',{SCRPTipt.labelstr})).entrystr;
wrmatfunc = SCRPTipt(strcmp('WrtMatFnc',{SCRPTipt.labelstr})).entrystr;

preglen = ceil(pregdur/gstepdur);
pregdur = preglen*gstepdur;
[SCRPTipt] = UpdatePanelValue(SCRPTipt,'PreGDur (ms)',num2str(pregdur),'');
gatmaxlen = ceil(gatmaxdur/gstepdur);
gatmaxdur = gatmaxlen*gstepdur;
ramptime = 1.1*gmax/gsl;
if gatmaxdur < ramptime
    [SCRPTipt] = UpdatePanelValue(SCRPTipt,'GatMaxDur (ms)',num2str(gatmaxdur),'0error');
    err.flag = 1;
    err.msg = 'Expand time at maximum to accomodate gradient slew';
    return
end
[SCRPTipt] = UpdatePanelValue(SCRPTipt,'GatMaxDur (ms)',num2str(gatmaxdur),'');
interglen = ceil(intergdur/gstepdur);
intergdur = interglen*gstepdur;
if intergdur < 2*ramptime
    [SCRPTipt] = UpdatePanelValue(SCRPTipt,'InterGDur (ms)',num2str(intergdur),'0error');
    err.flag = 1;
    err.msg = 'Expand time beween gradient to accomodate gradient slew';
    return
end
[SCRPTipt] = UpdatePanelValue(SCRPTipt,'InterGDur (ms)',num2str(intergdur),'');


G0 = [zeros(1,preglen) gmax*ones(1,gatmaxlen) zeros(1,interglen)... 
      -gmax*ones(1,gatmaxlen) 0];
G = [G0;G0;G0]';

T = (0:gstepdur:gstepdur*(length(G0)-1));
Gvis = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis = [Gvis [G(n) G(n)]];
end
L = [L T(n+1)];
Gvis = [Gvis G(n+1)];

figure(1); hold on; plot(L,Gvis); plot([0 L(length(L))],[0 0],':');

if strcmp(wrgrads,'Yes')
    Input.G = G;
    Input.T = T;
    Input.Gvis = Gvis;
    Input.L = L;
    Input.gstepdur = gstepdur;
    Input.graddur = gstepdur*length(G0);
    Input.pnum = 1;
    func = str2func(wrmatfunc);
    [SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);
    if err.flag == 1
        ErrDisp(err);
        return
    end   
    label = Output.MatLoc;
    loc = label;
    if length(label) > 62
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n)+1:length(loc))];
            if length(label) < 62
                break
            end
            n = n+1;
        end
    end
    SCRPTipt = AddToPanelOutput(SCRPTipt,'MatFile','0output',label,'0text');
    
    Input.rdur = ones(1,length(G));
    Input.file = Output.MatFile;
    func = str2func(wrgradfunc);
    [SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    label = Output.GradLoc;
    loc = label;
    if length(label) > 62
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n)+1:length(loc))];
            if length(label) < 62
                break
            end
            n = n+1;
        end
    end
    SCRPTipt = AddToPanelOutput(SCRPTipt,'GradLoc','0output',label,'0text'); 
    
    Input.GradLoc = Output.GradLoc;
    func = str2func(wrparamfunc);
    [SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    label = Output.ParamLoc;
    loc = label;
    if length(label) > 62
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n)+1:length(loc))];
            if length(label) < 62
                break
            end
            n = n+1;
        end
    end
    SCRPTipt = AddToPanelOutput(SCRPTipt,'ParamFile','0output',label,'0text'); 
    
end








    






















































