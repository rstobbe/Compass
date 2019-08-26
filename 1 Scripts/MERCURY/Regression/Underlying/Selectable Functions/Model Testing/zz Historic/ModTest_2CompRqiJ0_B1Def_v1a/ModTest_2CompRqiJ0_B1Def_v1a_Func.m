%======================================================
% 
%======================================================

function [MODTST,err] = ModTest_2CompRqiJ0_B1Def_v1a_Func(MODTST,INPUT)

Status2('busy','Define Model for Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EXP = INPUT.EXP;
Op = INPUT.Op;
clear INPUT

%=================================================================
% Setup
%=================================================================
if strcmp(Op,'Setup')
    %---------------------------------------------
    % Get Defined B1 Info
    %---------------------------------------------
    B1Table = readtable([MODTST.B1File.path,MODTST.B1File.file]);
    B1Cell = table2cell(B1Table);
    LengthB1Cell = length(B1Cell);
    SizeExp = size(EXP);
    if LengthB1Cell ~= SizeExp(1)
        err.flag = 1;
        err.msg = 'B1 file should have correct number of experiments';
        return
    end
    for n = 1:LengthB1Cell
        B1(n) = B1Cell{n};
    end

    %---------------------------------------------
    % Get ModelStart
    %---------------------------------------------
    ModelStartTable = readtable([MODTST.ModelStartFile.path,MODTST.ModelStartFile.file]);
    ModelStartCell = table2cell(ModelStartTable);
    SizeModelStartCell = size(ModelStartCell);
    if SizeModelStartCell(2) ~= 4
        err.flag = 1;
        err.msg = 'ModelStart file should have 2 models';
        return
    end
    for n = 1:2
        J0(n) = str2double(ModelStartCell{1,n+1});
        J1(n) = str2double(ModelStartCell{2,n+1});
        J2(n) = str2double(ModelStartCell{3,n+1});
        dist{n} = ModelStartCell{4,n+1};       
        p1(n) = str2double(ModelStartCell{5,n+1});
        p2(n) = str2double(ModelStartCell{6,n+1});
        Nave(n) = str2double(ModelStartCell{7,n+1});  
    end    
    Dist = str2double(ModelStartCell{1,4}); 
    
    %---------------------------------------------
    % Initialize
    %---------------------------------------------
    for n = 1:LengthB1Cell 
        for m = 1:SizeExp(2)
            if isempty(EXP{n,m})
                continue
            end
            
            %---------------------------------------------
            % Update B1
            %---------------------------------------------
            EXP{n,m}.SetB1(B1(n));
  
            %---------------------------------------------
            % Initialize Model
            %---------------------------------------------
            Compartments = 2;
            EXP{n,m}.InitializeModel(Compartments);            
            for p = 1:Compartments
                EXP{n,m}.MOD(p).SetModel(J0(p),J1(p),J2(p),dist(p),p1(p),p2(p),Nave(p))
            end
        end
    end   

    %---------------------------------------------
    % Initial Estimates
    %---------------------------------------------    
    MODTST.iEst(1) = p2(1);                 % RQIsdv (C1)
    MODTST.iEst(2) = J0(2);                 % J0 (C2)
    MODTST.iEst(3) = Dist;                  % distribution of compartments
    
    %----------------------------------------------------
    % Panel Items
    %----------------------------------------------------
    Panel(1,:) = {'','','Output'};
    Panel(2,:) = {'B1File',MODTST.B1File.loc,'Output'};
    Panel(2,:) = {'ModelStartFile',MODTST.ModelStartFile.loc,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    MODTST.PanelOutput = PanelOutput;    
    
%=================================================================
% Regression
%=================================================================    
elseif strcmp(Op,'Regression')

end  

Status2('done','',2);
Status2('done','',3);




