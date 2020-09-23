%=========================================================
% 
%=========================================================

function AccomodateOld

return

% if not(exist('saveSCRPTcellarray','var'))
%     if not(exist('saveSCRPTipt','var'))
%         saveSCRPTipt = SCRPTipt;
%     end
%     [SCRPTipt] = LabelGet_B9(panel);
%     Options.scrptnum = scrptnum;
%     [Current] = PANlab2CellArray_B9(SCRPTipt,Options);
%     Current{scrptnum,1}.entrystr = file;
%     Current{scrptnum,1}.path = path;
%     [SCRPTipt] = PanelRoutine_B9(Current,panel,panelnum);
%     m = 1;
%     for n = 2:length(saveSCRPTipt)+1
%         SCRPTipt(n).number = n;
%         SCRPTipt(n).entrystlye = '0text';
%         SCRPTipt(n).entrystr = saveSCRPTipt(m).entrystr;
%         SCRPTipt(n).entryvalue = saveSCRPTipt(m).entryvalue;        
%         SCRPTipt(n).labelstyle = '0labellvl1';   
%         SCRPTipt(n).labelstr = saveSCRPTipt(m).labelstr;
%         SCRPTipt(n).selstyle = '0lockpushbutton';
%         SCRPTipt(n).selstr = saveSCRPTipt(m).selstr;
%         SCRPTipt(n).selfunction1 = '';
%         SCRPTipt(n).selfunction2 = ''; 
%         SCRPTipt(n).entrystruct.funclevel = 2; 
%         SCRPTipt(n).entrystruct.entrytype = 'StatInput';
%         SCRPTipt(n).entrystruct.labelstr = saveSCRPTipt(m).labelstr;
%         m = m+1;
%     end
%     saveSCRPTcellarray = PANlab2CellArray_B9(SCRPTipt,Options);    
%     err.flag = 1;
%     err.msg = ['''',file,''' is too old to run with current RWSUI'];
% end


