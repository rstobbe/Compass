%======================================================
% 
%======================================================

function [BLDEXP,err] = BuildExp_ExcelFile_v1a_Func(BLDEXP,INPUT)

Status2('busy','Build Experiment',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Read Excel
%---------------------------------------------
ExpTable = readtable([BLDEXP.ExpExcelFile.path,BLDEXP.ExpExcelFile.file]);
ExpCell = table2cell(ExpTable);
SizeExpCell = size(ExpCell);
NumExps = round((SizeExpCell(1)+1)/8);
if rem(SizeExpCell(1)+1,NumExps)
    err.flag = 1;
    err.msg = 'ExpFile_Excel not organized properly';
    return
end

%---------------------------------------------
% Scans Per Session
%---------------------------------------------
for n = 1:NumExps
    Line = ExpCell((n-1)*8+1,:);
    idx = find(strcmp(Line,'Gave'));
    ScanIdx{n} = idx;
    Scans(n) = length(ScanIdx{n});
end

%---------------------------------------------
% Build Experiment
%---------------------------------------------
for n = 1:NumExps   
    for m = 1:Scans(n)
        EXP{n,m} = SimObj;
        Gave = ExpCell{(n-1)*8+1,ScanIdx{n}(m)+1};
        PCave = ExpCell{(n-1)*8+2,ScanIdx{n}(m)+1};
        PCtype = ExpCell{(n-1)*8+3,ScanIdx{n}(m)+1};
        SS = ExpCell{(n-1)*8+4,ScanIdx{n}(m)+1};
        EXP{n,m}.SetGeneralSequence(Gave,PCave,PCtype,SS);  
        elm = 1;
        while true
            Type(elm) = ExpCell{(n-1)*8+1,ScanIdx{n}(m)+2+elm};
            Dur(elm) = ExpCell{(n-1)*8+2,ScanIdx{n}(m)+2+elm};
            RfShape(elm) = ExpCell{(n-1)*8+3,ScanIdx{n}(m)+2+elm};
            Flip(elm) = ExpCell{(n-1)*8+4,ScanIdx{n}(m)+2+elm};
            Phase(elm) = ExpCell{(n-1)*8+5,ScanIdx{n}(m)+2+elm};
            Grad(elm) = ExpCell{(n-1)*8+6,ScanIdx{n}(m)+2+elm};
            PhaseCyc(elm) = ExpCell{(n-1)*8+7,ScanIdx{n}(m)+2+elm};
            Step(elm) = Dur(elm);
            %Step(elm) = 0.01;
            if Type(elm) == 6
                break
            end
            elm = elm + 1;
        end
        EXP{n,m}.InitializeSequence(length(Type));
        EXP{n,m}.SetSequence(Type,Dur,RfShape,Flip,Phase,Grad,PhaseCyc,Step);       
    end
end   
BLDEXP.EXP = EXP;
BLDEXP.NumExps = NumExps;
BLDEXP.Scans = Scans;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'BuildExp',BLDEXP.method,'Output'};
Panel(3,:) = {'ExpFile',BLDEXP.ExpExcelFile.label,'Output'};
Panel(4,:) = {'Number of Experiments',NumExps,'Output'};
BLDEXP.Panel = Panel;
BLDEXP.PanelOutput = cell2struct(BLDEXP.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);




