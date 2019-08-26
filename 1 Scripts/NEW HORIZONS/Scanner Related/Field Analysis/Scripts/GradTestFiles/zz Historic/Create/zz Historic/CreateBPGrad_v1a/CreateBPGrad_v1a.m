%=====================================================
% 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateBPGrad_v1a(SCRPTipt,SCRPTGBL)

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

figure(1); hold on; plot(L,Gvis);

if strcmp(wrgrads,'Yes')
    Input.G = G;
    Input.rdur = ones(1,length(G));
    func = str2func(wrgradfunc);
    [SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    Input.GradLoc = Output.GradLoc;
    Input.graddur = gstepdur*length(G0);
    func = str2func(wrparamfunc);
    [SCRPTipt,Output,err] = func(SCRPTipt,SCRPTGBL,Input);
    if err.flag == 1
        ErrDisp(err);
        return
    end
    
end

%save('GTST7','Glen','step','Gsl','Gmax','timarr','G');
%addpath('D:\8 Programs\A9 ECCTool\Write Gradients\');
%WriteGrads2(name,G,rdur);

    






















































