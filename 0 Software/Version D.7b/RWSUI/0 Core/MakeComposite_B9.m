%====================================================
%
%====================================================

function MakeComposite_B9(panelnum,tab,scrptnum)

Status('busy','Make Composite');

global SCRPTPATHS

if isempty(SCRPTPATHS.(tab)(panelnum).defloc)
    SCRPTPATHS.(tab)(panelnum).defloc = SCRPTPATHS.(tab)(panelnum).defrootloc;
end
if SCRPTPATHS.(tab)(panelnum).defloc == 0
    SCRPTPATHS.(tab)(panelnum).defloc = '';
end

%---------------------------------------------
% Test that all previously saved
%---------------------------------------------
for n = 1:4
    [SCRPTipt] = LabelGet(tab,n);
    if length(SCRPTipt) == 1
        continue
    end
    inds = strcmp('Script_Name',{SCRPTipt.labelstr});
    indnum = find(inds==1);
    if length(indnum) > 1
        error;                                  % shouldn't get here - only one script per panel
    end
    if not(isempty(indnum))
        if isempty(SCRPTipt(indnum).entrystr)   
            err.flag = 1;
            err.msg = 'Save individual scripts first';
            ErrDisp(err);
            return
        end
    end
end

%----------------------------------------------------
% Select Output Data
%----------------------------------------------------
[file,path] = uiputfile('*.mat','Name Composite',SCRPTPATHS.(tab)(panelnum).defloc);
if path == 0
    err.flag = 4;
    err.msg = 'Composite not created';
    ErrDisp(err);
    return
end
defloc = path;
SCRPTPATHS.(tab)(panelnum).defloc = defloc;

%---------------------------------------------
% Write Naming
%---------------------------------------------
Options.scrptnum = scrptnum;
Options.makelocalcurrent = 'yes';
Options.excludelocaloutput = 'yes';
for n = 1:4
    [SCRPTipt] = LabelGet(tab,n);
    CompCellArray(n,:,:) = PANlab2CellArray_B9(SCRPTipt,Options);
end
    
%--------------------------------------------
% Save
%--------------------------------------------
save([path,file],'CompCellArray');

Status('done','Composite Created');
