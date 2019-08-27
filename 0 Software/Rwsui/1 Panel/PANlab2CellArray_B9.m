%=========================================================
% 
%=========================================================

function [CellArray] = PANlab2CellArray_B9(SCRPTipt,Options)

if not(isfield(Options,'makeglobalcurrent'))
    Options.makeglobalcurrent = 'no';
end
if not(isfield(Options,'makelocalcurrent'))
    Options.makelocalcurrent = Options.makeglobalcurrent;
end
if not(isfield(Options,'excludeglobaloutput'))
    Options.excludeglobaloutput = 'no';
end
if not(isfield(Options,'excludelocaloutput'))
    Options.excludelocaloutput = Options.excludeglobaloutput;
end
if not(isfield(Options,'scrptnum'))
    Options.scrptnum = 1;
end

if not(isfield(SCRPTipt,'entrystruct'))
    CellArray{1,1} = [];
    CellArray{1,2} = [];
    return
end
    
m = 0;
for a = 1:length(SCRPTipt)
    level = SCRPTipt(a).entrystruct.funclevel;
    if level == 1
        m = m+1;
        CellArray{m,1} = SCRPTipt(a).entrystruct;
        CellArray{m,2} = cell(1);
        n = 0;
    elseif level == 2
        if ((not(strcmp(SCRPTipt(a).entrystruct.entrytype,'Output')) && not(strcmp(SCRPTipt(a).entrystruct.entrytype,'OutputWarn'))) || ...
        (strcmp(Options.excludeglobaloutput,'no') && (Options.scrptnum ~= m)) || ...
        (strcmp(Options.excludelocaloutput,'no') && (Options.scrptnum == m))) && ...
        not(strcmp(SCRPTipt(a).entrystruct.entrytype,'Space'))
            n = n+1;
            CellArray{m,2}{n,1} = SCRPTipt(a).entrystruct;
            CellArray{m,2}{n,1}.entrystr = SCRPTipt(a).entrystr;
            CellArray{m,2}{n,1}.entryvalue = SCRPTipt(a).entryvalue;
            if strcmp(Options.makeglobalcurrent,'yes') || (strcmp(Options.makelocalcurrent,'yes') && (Options.scrptnum == m))
                CellArray{m,2}{n,1}.altval = 0;
                if strcmp(SCRPTipt(a).entrystruct.entrytype,'Choose')
                    if iscell(SCRPTipt(a).entrystr)
                        CellArray{m,2}{n,1}.entrystr = SCRPTipt(a).entrystr{SCRPTipt(a).entryvalue};
                    end
                end
            end
            CellArray{m,2}{n,2} = cell(1);
            p = 0;
        end
    elseif level == 3
        p = p+1;
        CellArray{m,2}{n,2}{p,1} = SCRPTipt(a).entrystruct;
        CellArray{m,2}{n,2}{p,1}.entrystr = SCRPTipt(a).entrystr;
        CellArray{m,2}{n,2}{p,1}.entryvalue = SCRPTipt(a).entryvalue;
        if strcmp(Options.makeglobalcurrent,'yes') || (strcmp(Options.makelocalcurrent,'yes') && (Options.scrptnum == m))
            CellArray{m,2}{n,2}{p,1}.altval = 0;
            if strcmp(SCRPTipt(a).entrystruct.entrytype,'Choose')
                if iscell(SCRPTipt(a).entrystr)
                    CellArray{m,2}{n,2}{p,1}.entrystr = SCRPTipt(a).entrystr{SCRPTipt(a).entryvalue};
                end
            end   
        end
        CellArray{m,2}{n,2}{p,2} = cell(1);
        d = 0;
    elseif level == 4
        d = d+1;
        CellArray{m,2}{n,2}{p,2}{d,1} = SCRPTipt(a).entrystruct;
        CellArray{m,2}{n,2}{p,2}{d,1}.entrystr = SCRPTipt(a).entrystr;
        CellArray{m,2}{n,2}{p,2}{d,1}.entryvalue = SCRPTipt(a).entryvalue;
        if strcmp(Options.makeglobalcurrent,'yes') || (strcmp(Options.makelocalcurrent,'yes') && (Options.scrptnum == m))
            CellArray{m,2}{n,2}{p,2}{d,1}.altval = 0;
            if strcmp(SCRPTipt(a).entrystruct.entrytype,'Choose')
                if iscell(SCRPTipt(a).entrystr)
                    CellArray{m,2}{n,2}{p,2}{d,1}.entrystr = SCRPTipt(a).entrystr{SCRPTipt(a).entryvalue};
                end
            end   
        end
        CellArray{m,2}{n,2}{p,2}{d,2} = cell(1);
        e = 0;
    elseif level == 5
        e = e+1;
        CellArray{m,2}{n,2}{p,2}{d,2}{e,1} = SCRPTipt(a).entrystruct;
        CellArray{m,2}{n,2}{p,2}{d,2}{e,1}.entrystr = SCRPTipt(a).entrystr;
        CellArray{m,2}{n,2}{p,2}{d,2}{e,1}.entryvalue = SCRPTipt(a).entryvalue;
        if strcmp(Options.makeglobalcurrent,'yes') || (strcmp(Options.makelocalcurrent,'yes') && (Options.scrptnum == m))
            CellArray{m,2}{n,2}{p,2}{d,2}{e,1}.altval = 0;
            if strcmp(SCRPTipt(a).entrystruct.entrytype,'Choose')
                if iscell(SCRPTipt(a).entrystr)
                    CellArray{m,2}{n,2}{p,2}{d,2}{e,1}.entrystr = SCRPTipt(a).entrystr{SCRPTipt(a).entryvalue};
                end
            end   
        end
        CellArray{m,2}{n,2}{p,2}{d,2}{e,2} = cell(1);
    end    
end
