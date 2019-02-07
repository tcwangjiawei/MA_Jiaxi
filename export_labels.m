function [outputArg1] = export_labels(path2csvfile)

%% Export labels over time
%write header to file
load('true_label.mat');

fid = fopen(path2csvfile,'w'); 
% fid = fopen('..\SimInput\ground_truth_label.csv','w'); 
fprintf(fid,'%s\n','#Time label_ego_long label_ego_lat label_TObj_long label_TObj_lat label_ObjId'  );
fclose(fid);
%write data to end of file
export_array = [Time', label.ego.long' label.ego.lat' label.TObj.long' label.TObj.lat' label.ObjId'];
dlmwrite('..\SimInput\ground_truth_label.csv',export_array,'-append');

 end