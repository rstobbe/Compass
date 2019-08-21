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
%         if not(exist(CellArray{m,1}.entrystr,'file'))
%             CellArray{m,1}.entrystr = 'Select';
%         end
        test = exist([CellArray{m,1}.entrystr,'_Default2'],'file');
        if not(test == 2 || test == 6)
            err.flag = 1;
            err.msg = [CellArray{m,1}.entrystr,' function not present'];
            return
        end
        func = str2func([CellArray{m,1}.entrystr,'_Default2']);
        CellArray{m,2} = func(SCRPTPATHS.(tab)(panelnum));
        for n = 1:length(CellArray{m,2}(:,1))
            if not(isempty(CellArray{m,2}{n,1}))
                CellArray{m,2}{n,2} = cell(1);
                CellArray{m,2}{n,1}.altval = 0;
                if strcmp(CellArray{m,2}{n,1}.entrytype,'ScrptFunc')
%                     if not(exist(CellArray{m,2}{n,1}.entrystr,'file'))
%                         CellArray{m,2}{n,1}.entrystr = 'Select';
%                     end
                    test = exist([CellArray{m,2}{n,1}.entrystr,'_Default2'],'file');
                    if not(test == 2 || test == 6)
                        err.flag = 1;
                        err.msg = [CellArray{m,2}{n,1}.entrystr,' function not present'];
                        return
                    end
                    func = str2func([CellArray{m,2}{n,1}.entrystr,'_Default2']);
                    CellArray{m,2}{n,2} = func(SCRPTPATHS.(tab)(panelnum));
                    for p = 1:length(CellArray{m,2}{n,2}(:,1))
                        if not(isempty(CellArray{m,2}{n,2}{p,1}))
                            CellArray{m,2}{n,2}{p,2} = cell(1);
                            CellArray{m,2}{n,2}{p,1}.altval = 0;
                            if strcmp(CellArray{m,2}{n,2}{p,1}.entrytype,'ScrptFunc')
%                                 if not(exist(CellArray{m,2}{n,2}{p,1}.entrystr,'file'))
%                                     CellArray{m,2}{n,2}{p,1}.entrystr = 'Select';
%                                 end
                                test = exist([CellArray{m,2}{n,2}{p,1}.entrystr,'_Default2'],'file');
                                if not(test == 2 || test == 6)
                                    err.flag = 1;
                                    err.msg = [CellArray{m,2}{n,2}{p,1}.entrystr,' function not present'];
                                    return
                                end
                                func = str2func([CellArray{m,2}{n,2}{p,1}.entrystr,'_Default2']);
                                CellArray{m,2}{n,2}{p,2} = func(SCRPTPATHS.(tab)(panelnum));
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




