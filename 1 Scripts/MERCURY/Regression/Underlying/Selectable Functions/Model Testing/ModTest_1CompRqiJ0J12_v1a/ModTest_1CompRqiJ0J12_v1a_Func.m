%======================================================
% 
%======================================================

function [MODTST,err] = ModTest_1CompRqiJ0J12_v1a_Func(MODTST,INPUT)

err.flag = 0;
err.msg = '';

Op = INPUT.Op;
%=================================================================
% Setup
%=================================================================
if strcmp(Op,'Setup')

    Status2('busy','Define Model for Testing',3);
    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    EXP = INPUT.EXP;
    clear INPUT    
    
    %---------------------------------------------
    % Get ModelStart
    %---------------------------------------------
    ModelStartTable = readtable([MODTST.ModelStartFile.path,MODTST.ModelStartFile.file]);
    ModelStartCell = table2cell(ModelStartTable);
    SizeModelStartCell = size(ModelStartCell);
    if SizeModelStartCell(2) ~= 2
        err.flag = 1;
        err.msg = 'ModelStart file should have only 1 model';
        return
    end
    Compartments = 1;
    for n = 1:Compartments
        J0(n) = str2double(ModelStartCell{1,n+1});
        J1(n) = str2double(ModelStartCell{2,n+1});
        J2(n) = str2double(ModelStartCell{3,n+1});
        dist{n} = ModelStartCell{4,n+1};       
        p1(n) = str2double(ModelStartCell{5,n+1});
        p2(n) = str2double(ModelStartCell{6,n+1});
        Nave(n) = str2double(ModelStartCell{7,n+1});  
    end    

    %---------------------------------------------
    % Test
    %---------------------------------------------    
    if not(strcmp(dist(1),'Gaussian'))
        err.flag = 1;
        err.msg = 'Model must have Gaussian RQI distribution';
        return
    end
    
    %---------------------------------------------
    % Initialize
    %---------------------------------------------
    SizeExp = size(EXP);
    for n = 1:SizeExp(1)
        for m = 1:SizeExp(2)
            if isempty(EXP{n,m})
                continue
            end
            %---------------------------------------------
            % Initialize Model
            %---------------------------------------------
            Compartments = 1;
            EXP{n,m}.InitializeModel(Compartments);            
            for p = 1:Compartments
                EXP{n,m}.MOD(p).SetModel(J0(p),J1(p),J2(p),dist(p),p1(p),p2(p),Nave(p))
            end
        end
    end   

    %---------------------------------------------
    % Initial Estimates
    %---------------------------------------------    
    MODTST.iEst(1) = J0(1);         
    MODTST.iEst(2) = J1(1);                
    MODTST.iEst(3) = p2(1);  
    
    %----------------------------------------------------
    % Panel Items
    %----------------------------------------------------
    Panel(1,:) = {'','','Output'};
    Panel(2,:) = {'ModTest',MODTST.method,'Output'};
    Panel(3,:) = {'ModelStartFile',MODTST.ModelStartFile.label,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    MODTST.Panel = Panel;
    MODTST.PanelOutput = PanelOutput;    
    Status2('done','',3);
    
%=================================================================
% SetModel
%=================================================================    
elseif strcmp(Op,'SetModel')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    EXP = INPUT.EXP;
    Model = INPUT.Model;
    clear INPUT    
    
    %---------------------------------------------
    % Set New Values
    %---------------------------------------------
    SizeExp = size(EXP);
    for n = 1:SizeExp(1)
        for m = 1:SizeExp(2)
            if isempty(EXP{n,m})
                continue
            end
            EXP{n,m}.MOD(1).SetJ0(Model(1));
            EXP{n,m}.MOD(1).SetJ12(Model(2));
            EXP{n,m}.MOD(1).SetP2(Model(3));
        end
    end     

%=================================================================
% Distribution
%=================================================================    
elseif strcmp(Op,'Distribution')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    Vals = INPUT.Vals;
    clear INPUT    
    
    %---------------------------------------------
    % Set Distribution
    %---------------------------------------------
    MODTST.Vals = Vals;
end 





