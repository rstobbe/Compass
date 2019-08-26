%======================================================
% 
%======================================================

function [MODTST,err] = ModTest_2CompJ0J0_v1a_Func(MODTST,INPUT)

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
    CompDist = ModelStartCell{1,4}; 

    %---------------------------------------------
    % Test
    %---------------------------------------------    
    if not(strcmp(dist(2),'None'))
        err.flag = 1;
        err.msg = 'First compartment model must have no RQI';
        return
    end
    if not(strcmp(dist(2),'None'))
        err.flag = 1;
        err.msg = 'Second compartment model must have no RQI';
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
    MODTST.iEst(1) = J0(1);                 % J0 (C1)
    MODTST.iEst(2) = J0(2);                 % J0 (C2)
    MODTST.iEst(3) = CompDist;              % distribution of compartments
    
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
            EXP{n,m}.MOD(2).SetJ0(Model(2));
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
    Model = INPUT.Model;
    REG = INPUT.REG;
    clear INPUT    
    
    %---------------------------------------------
    % Set Distribution
    %---------------------------------------------
    MODTST.Vals = Vals(:,:,1)*Model(3) + Vals(:,:,2)*(1-Model(3));
    
    %---------------------------------------------
    % Plot
    %---------------------------------------------
    ValArr = [];
    for n = 1:REG.NumExps
        ValArr = [ValArr Vals(n,1:REG.Scans(n),:)];
    end
    ValArr = squeeze(ValArr);
    
    h = figure(1000); clf(h); hold on;
    plot(squeeze(ValArr(:,1)),'b*');
    plot(squeeze(ValArr(:,2)),'g*');
    plot([0 length(ValArr)],[0 0],'k:');
    ylim([-10 1.2*max(ValArr(:,2))]);
    ylabel('Unscaled Sim Values');
end 





