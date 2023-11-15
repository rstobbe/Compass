%=========================================================
%
%=========================================================

function [CellArray,err] = GetSubFunctions_B9(CellArray,tab,panelnum)

global SCRPTPATHS
err.flag = 0;
err.msg = '';

for m = 1:length(CellArray)
    CellArray{m,2} = cell(1);
    CellArray{m,1}.altval = 0;
    if strcmp(CellArray{m,1}.entrytype,'ScrptFunc')
        try
            func = str2func([CellArray{m,1}.entrystr,'_Default2']);
            CellArray{m,2} = func(SCRPTPATHS.(tab)(panelnum));
        catch
            func = str2func(CellArray{m,1}.entrystr);
            Temp = func();
            CellArray{m,2} = Temp.CompassInterface(SCRPTPATHS.(tab)(panelnum));
        end
        for n = 1:length(CellArray{m,2}(:,1))
            if not(isempty(CellArray{m,2}{n,1}))
                CellArray{m,2}{n,2} = cell(1);
                CellArray{m,2}{n,1}.altval = 0;
                if strcmp(CellArray{m,2}{n,1}.entrytype,'ScrptFunc')
                    test = exist([CellArray{m,2}{n,1}.entrystr,'_Default2'],'file');
                    if not(test == 2 || test == 6)
                        err.flag = 1;
                        err.msg = [CellArray{m,2}{n,1}.entrystr,' function not present'];
                        return
                    end
                    try
                        func = str2func([CellArray{m,2}{n,1}.entrystr,'_Default2']);
                        CellArray{m,2}{n,2} = func(SCRPTPATHS.(tab)(panelnum));
                    catch
                        func = str2func(CellArray{m,2}{n,1}.entrystr);
                        Temp = func();
                        CellArray{m,2}{n,2} = Temp.CompassInterface(SCRPTPATHS.(tab)(panelnum));
                    end
                    for p = 1:length(CellArray{m,2}{n,2}(:,1))
                        if not(isempty(CellArray{m,2}{n,2}{p,1}))
                            CellArray{m,2}{n,2}{p,2} = cell(1);
                            CellArray{m,2}{n,2}{p,1}.altval = 0;
                            if strcmp(CellArray{m,2}{n,2}{p,1}.entrytype,'ScrptFunc')
                                test = exist([CellArray{m,2}{n,2}{p,1}.entrystr,'_Default2'],'file');
                                if not(test == 2 || test == 6)
                                    err.flag = 1;
                                    err.msg = [CellArray{m,2}{n,2}{p,1}.entrystr,' function not present'];
                                    return
                                end
                                try
                                    func = str2func([CellArray{m,2}{n,2}{p,1}.entrystr,'_Default2']);
                                    CellArray{m,2}{n,2}{p,2} = func(SCRPTPATHS.(tab)(panelnum));
                                catch
                                    func = str2func(CellArray{m,2}{n,2}{p,1}.entrystr);
                                    Temp = func();
                                    CellArray{m,2}{n,2}{p,2} = Temp.CompassInterface(SCRPTPATHS.(tab)(panelnum));
                                end
                                for d = 1:length(CellArray{m,2}{n,2}{p,2}(:,1))
                                    if not(isempty(CellArray{m,2}{n,2}{p,2}{d,1}))
                                        CellArray{m,2}{n,2}{p,2}{d,1}.altval = 0;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end




