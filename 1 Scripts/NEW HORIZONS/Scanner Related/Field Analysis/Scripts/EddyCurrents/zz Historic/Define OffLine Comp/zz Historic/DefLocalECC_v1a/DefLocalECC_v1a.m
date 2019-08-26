%==============================================
% (v1a)
%       
%==============================================

function [SCRPTipt,SCRPTGBL,err] = DefLocalECC_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Define Eddy Currents for Local (not on magnet) Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
LECC.method = SCRPTGBL.CurrentTree.Func;
LECC.gcoil = SCRPTGBL.CurrentTree.('gcoil');
LECC.graddel = str2double(SCRPTGBL.CurrentTree.('graddel'));
tc = SCRPTGBL.CurrentTree.('Tc');
mag = SCRPTGBL.CurrentTree.('Mag');

%---------------------------------------------
% Get Values
%---------------------------------------------
inds1 = strfind(tc,',');
inds2 = strfind(mag,',');
if isempty(inds1)
    inds1 = strfind(tc,' ');
    inds2 = strfind(mag,' ');
end
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''Tc Estimate'' and ''Mag Estimate'' must be the same length';
    return
end
if isempty(inds1)
    LECC.tc = str2double(tc);
    LECC.mag = str2double(mag);
else
    LECC.tc(1) = str2double(tc(1:inds1(1)-1));
    LECC.mag(1) = str2double(mag(1:inds2(1)-1));    
    for n = 2:length(inds1)
        LECC.tc(n) = str2double(tc(inds1(n-1)+1:inds1(n)-1));
        LECC.mag(n) = str2double(mag(inds2(n-1)+1:inds2(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    LECC.tc(length(inds1)+1) = str2double(tc(inds1(n)+1:length(tc)));
    LECC.mag(length(inds1)+1) = str2double(mag(inds2(n)+1:length(mag)));     
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Local (off-line) ECC:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('LECC_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {LECC};
SCRPTGBL.RWSUI.SaveVariableNames = {'LECC'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

