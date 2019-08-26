%======================================================
% 
%======================================================

function [E] = Regression_Standard_v1a_Reg(P0,EXP,MODTST,REG,Data)

%---------------------------------------------
% Regression Values
%---------------------------------------------
P = P0./REG.Scale;
charout = num2str(P,'%8.4f');
Status2('busy',charout,3);
ExpScale = P(end-REG.NumExps+1:end);
ExpB1 = P(end-2*REG.NumExps+1:end-REG.NumExps);
Model = P(1:end-2*REG.NumExps);

%---------------------------------------------
% Set Magnet Related
%---------------------------------------------
OffRes = 0;
for n = 1:REG.NumExps
    for m = 1:REG.Scans(n)
        EXP{n,m}.SetMagnetRelated(ExpB1(n),OffRes);
    end
end

%---------------------------------------------
% Set Model
%---------------------------------------------
func = str2func([MODTST.method,'_Func']);  
INPUT.Model = Model;
INPUT.EXP = EXP;
INPUT.Op = 'SetModel';
[MODTST] = func(MODTST,INPUT);

%---------------------------------------------
% Simulate Sequence
%---------------------------------------------
for n = 1:REG.NumExps
    for m = 1:REG.Scans(n)
        EXP{n,m}.BuildSequence;
        EXP{n,m}.Simulate;
        Vals(n,m,:) = EXP{n,m}.TeT11s;
    end
end

%---------------------------------------------
% Model Distribution
%---------------------------------------------
func = str2func([MODTST.method,'_Func']);  
INPUT.Model = Model;
INPUT.Vals = Vals;
INPUT.REG = REG;
INPUT.Op = 'Distribution';
[MODTST] = func(MODTST,INPUT);
SimVals = MODTST.Vals;

%---------------------------------------------
% Scale
%---------------------------------------------
for n = 1:REG.NumExps
    SimScaleVals(n,:) = SimVals(n,:)*ExpScale(n);
end

%---------------------------------------------
% Compare
%---------------------------------------------
SimScaleValsArr = [];
DataArr = [];
for n = 1:REG.NumExps
    SimScaleValsArr = [SimScaleValsArr SimScaleVals(n,1:REG.Scans(n))];
    DataArr = [DataArr Data(n,1:REG.Scans(n))];
end
E = SimScaleValsArr - DataArr;

%---------------------------------------------
% Plot
%---------------------------------------------
h = figure(100); clf(h); hold on;
plot(DataArr,'k*');
plot(SimScaleValsArr,'r*');
ylim([0 1.2*max(DataArr)]);
ylabel('Measured Data Value');



