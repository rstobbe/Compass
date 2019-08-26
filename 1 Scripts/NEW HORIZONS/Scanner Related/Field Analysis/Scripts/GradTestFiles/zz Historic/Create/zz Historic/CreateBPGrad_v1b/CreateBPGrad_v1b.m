%=====================================================
% 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateBPGrad_v1b(SCRPTipt,SCRPTGBL)

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

t = (gstepdur:gstepdur:gmax*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= gmax,1,'first');
grampup = ramp(1:ind-1);
ramp = gmax - gsl*t;
ind = find(ramp <= 0,1,'first');
grampdown = ramp(1:ind-1);

preglen = round(pregdur/gstepdur);
pregdur = preglen*gstepdur;
gatmaxlen = round(gatmaxdur/gstepdur);
gatmaxdur = gatmaxlen*gstepdur;
interglen = round(intergdur/gstepdur);
intergdur = interglen*gstepdur;

G0 = [zeros(1,preglen) grampup gmax*ones(1,gatmaxlen) grampdown...
      zeros(1,interglen) -grampup -gmax*ones(1,gatmaxlen) -grampdown 0];
G = [G0;G0;G0]';

T = (0:gstepdur:gstepdur*(length(G0)-1));
Gvis = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis = [Gvis [G(n) G(n)]];
end

figure(1); hold on; plot(L,Gvis); plot([0 L(length(L))],[0 0],':');

if strcmp(wrgrads,'Yes')
    SCRPTGBL.MatFile.G = G;
    SCRPTGBL.MatFile.T = T;
    SCRPTGBL.MatFile.Gvis = Gvis;
    SCRPTGBL.MatFile.L = L;
    SCRPTGBL.MatFile.gstepdur = gstepdur;
    SCRPTGBL.MatFile.graddur = gstepdur*length(G0);
    SCRPTGBL.MatFile.pnum = 1;
    func = str2func(wrmatfunc);
    [SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
    if err.flag == 1
        ErrDisp(err);
        return
    end   
    label = SCRPTGBL.MatFile.loc;
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
    
    SCRPTGBL.GradFile.G = G;
    SCRPTGBL.GradFile.rdur = ones(1,length(G));
    SCRPTGBL.GradFile.file = SCRPTGBL.MatFile.file;
    func = str2func(wrgradfunc);
    [SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    label = SCRPTGBL.GradFile.loc;
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
    SCRPTipt = AddToPanelOutput(SCRPTipt,'GradFile','0output',label,'0text'); 
    
    SCRPTGBL.ParamFile.graddur = gstepdur*length(G0);
    SCRPTGBL.ParamFile.pnum = 1;
    SCRPTGBL.ParamFile.GradLoc = SCRPTGBL.GradFile.loc;
    func = str2func(wrparamfunc);
    [SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    label = SCRPTGBL.ParamFile.loc;
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

    