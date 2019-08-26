%==============================================
% (v1c)
%      - include 'effect decay'
%==============================================

function [SCRPTipt,SCRPTGBL,err] = DefLocalComp_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Define Local (not on magnet) Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
COMP.method = SCRPTGBL.CurrentTree.Func;
COMP.gcoil = SCRPTGBL.CurrentTree.('gcoil');
COMP.xgraddel = str2double(SCRPTGBL.CurrentTree.('xgraddel'));
COMP.ygraddel = str2double(SCRPTGBL.CurrentTree.('ygraddel'));
COMP.zgraddel = str2double(SCRPTGBL.CurrentTree.('zgraddel'));
COMP.xgradoffset = str2double(SCRPTGBL.CurrentTree.('xgradoff'));
COMP.ygradoffset = str2double(SCRPTGBL.CurrentTree.('ygradoff'));
COMP.zgradoffset = str2double(SCRPTGBL.CurrentTree.('zgradoff'));
xtc = SCRPTGBL.CurrentTree.('xTc');
xmag = SCRPTGBL.CurrentTree.('xMag');
xeffdec = SCRPTGBL.CurrentTree.('xEffDec');
ytc = SCRPTGBL.CurrentTree.('yTc');
ymag = SCRPTGBL.CurrentTree.('yMag');
yeffdec = SCRPTGBL.CurrentTree.('yEffDec');
ztc = SCRPTGBL.CurrentTree.('zTc');
zmag = SCRPTGBL.CurrentTree.('zMag');
zeffdec = SCRPTGBL.CurrentTree.('zEffDec');

%---------------------------------------------
% Get Values (x)
%---------------------------------------------
inds1 = strfind(xtc,',');
inds2 = strfind(xmag,',');
inds3 = strfind(xeffdec,',');
if isempty(inds1)
    inds1 = strfind(xtc,' ');
    inds2 = strfind(xmag,' ');
    inds3 = strfind(xeffdec,' ');
end
if length(inds1) ~= length(inds2) || length(inds1) ~= length(inds3)
    err.flag = 1;
    err.msg = '''xTc'' and ''xMag'' and ''xEffDec'' must all be the same length';
    return
end
if isempty(inds1)
    COMP.xtc = str2double(xtc);
    COMP.xmag = str2double(xmag);
    COMP.xeffdec = str2double(xeffdec);    
else
    COMP.xtc(1) = str2double(xtc(1:inds1(1)-1));
    COMP.xmag(1) = str2double(xmag(1:inds2(1)-1));    
    COMP.xeffdec(1) = str2double(xeffdec(1:inds3(1)-1));   
    for n = 2:length(inds1)
        COMP.xtc(n) = str2double(xtc(inds1(n-1)+1:inds1(n)-1));
        COMP.xmag(n) = str2double(xmag(inds2(n-1)+1:inds2(n)-1));
        COMP.xeffdec(n) = str2double(xeffdec(inds3(n-1)+1:inds3(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    COMP.xtc(length(inds1)+1) = str2double(xtc(inds1(n)+1:length(xtc)));
    COMP.xmag(length(inds1)+1) = str2double(xmag(inds2(n)+1:length(xmag)));     
    COMP.xeffdec(length(inds1)+1) = str2double(xeffdec(inds3(n)+1:length(xeffdec)));    
end

%---------------------------------------------
% Get Values (y)
%---------------------------------------------
inds1 = strfind(ytc,',');
inds2 = strfind(ymag,',');
inds3 = strfind(yeffdec,',');
if isempty(inds1)
    inds1 = strfind(ytc,' ');
    inds2 = strfind(ymag,' ');
    inds3 = strfind(yeffdec,' ');
end
if length(inds1) ~= length(inds2) || length(inds1) ~= length(inds3)
    err.flag = 1;
    err.msg = '''yTc'' and ''yMag'' and ''yEffDec'' must all be the same length';
    return
end
if isempty(inds1)
    COMP.ytc = str2double(ytc);
    COMP.ymag = str2double(ymag);
    COMP.yeffdec = str2double(yeffdec);    
else
    COMP.ytc(1) = str2double(ytc(1:inds1(1)-1));
    COMP.ymag(1) = str2double(ymag(1:inds2(1)-1));    
    COMP.yeffdec(1) = str2double(yeffdec(1:inds3(1)-1));   
    for n = 2:length(inds1)
        COMP.ytc(n) = str2double(ytc(inds1(n-1)+1:inds1(n)-1));
        COMP.ymag(n) = str2double(ymag(inds2(n-1)+1:inds2(n)-1));
        COMP.yeffdec(n) = str2double(yeffdec(inds3(n-1)+1:inds3(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    COMP.ytc(length(inds1)+1) = str2double(ytc(inds1(n)+1:length(ytc)));
    COMP.ymag(length(inds1)+1) = str2double(ymag(inds2(n)+1:length(ymag)));     
    COMP.yeffdec(length(inds1)+1) = str2double(yeffdec(inds3(n)+1:length(yeffdec)));    
end

%---------------------------------------------
% Get Values (z)
%---------------------------------------------
inds1 = strfind(ztc,',');
inds2 = strfind(zmag,',');
inds3 = strfind(zeffdec,',');
if isempty(inds1)
    inds1 = strfind(ztc,' ');
    inds2 = strfind(zmag,' ');
    inds3 = strfind(zeffdec,' ');
end
if length(inds1) ~= length(inds2) || length(inds1) ~= length(inds3)
    err.flag = 1;
    err.msg = '''zTc'' and ''zMag'' and ''zEffDec'' must all be the same length';
    return
end
if isempty(inds1)
    COMP.ztc = str2double(ztc);
    COMP.zmag = str2double(zmag);
    COMP.zeffdec = str2double(zeffdec);    
else
    COMP.ztc(1) = str2double(ztc(1:inds1(1)-1));
    COMP.zmag(1) = str2double(zmag(1:inds2(1)-1));    
    COMP.zeffdec(1) = str2double(zeffdec(1:inds3(1)-1));   
    for n = 2:length(inds1)
        COMP.ztc(n) = str2double(ztc(inds1(n-1)+1:inds1(n)-1));
        COMP.zmag(n) = str2double(zmag(inds2(n-1)+1:inds2(n)-1));
        COMP.zeffdec(n) = str2double(zeffdec(inds3(n-1)+1:inds3(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    COMP.ztc(length(inds1)+1) = str2double(ztc(inds1(n)+1:length(ztc)));
    COMP.zmag(length(inds1)+1) = str2double(zmag(inds2(n)+1:length(zmag)));     
    COMP.zeffdec(length(inds1)+1) = str2double(zeffdec(inds3(n)+1:length(zeffdec)));    
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Local (off-line) Comp:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Comp_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {COMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'COMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

