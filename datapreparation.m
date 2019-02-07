function [outputArg1] = datapreparation(path2ergfile)

% ---This is for preparing the recorded data for following analysis steps



%% load CM data


% data=cmread('C:\CM_Projects\CM7_Highway\SimOutput\Ground_truth_data.erg');
data=cmread(path2ergfile);


%% Channel Selection
Time = data.Time.data;
%% Ground Truth Ego Maneuvers

Ego.Car.ax = data.Car_ax.data;
Ego.Lane.Act_LaneId = data.Car_Road_Lane_Act_LaneId.data;
Ego.Lane.Act_width = data.Car_Road_Lane_Act_Width.data;
Ego.Lane.Left_width = data.Car_Road_Lane_OnLeft_Width.data;
Ego.Lane.Right_width = data.Car_Road_Lane_OnRight_Width.data;
Ego.Lane.DevDist = data.Car_Road_Path_DevDist.data;




%% Ground Truth Dynamic Objects Maneuvers

%--------------------------------------------------------------------------
%Identificate Object
%Column 1: if there is a target exist
%Column 2: determine the target ID
%--------------------------------------------------------------------------
TObj.Flag = data.Sensor_Object_OB01_relvTgt_dtct.data';  
TObj.ObjID = data.Sensor_Object_OB01_relvTgt_ObjId.data';
for n=1:length(Time)
     if TObj.Flag(n) == 1 
        TObj.ObjID(n,2) = TObj.ObjID(n,1)-241;
     else 
          TObj.ObjID(n,2) =TObj.ObjID(n,1);
     end
  
end

%Load Data based on Objct ID
for n=1:length(Time)
    if TObj.ObjID(n,2) ~= -1 && TObj.ObjID(n,2) ~= 0
        ObjID = TObj.ObjID(n,2);
       
        name_string1 = ['TObj.Car.ax(n) = data.Traffic_T' num2str(ObjID) '_a_1_x.data(n) ' ];
        eval(name_string1);
        %TObj.Car.ax(n) = data.Traffic_T ObjID_a_1_x.data;
        
        name_string2 = ['TObj.Lane.Act_LaneId(n) = data.Traffic_T' num2str(ObjID) '_Lane_Act_LaneId.data(n) ' ];
        eval(name_string2);
        %T00.Lane.Act_LaneId = data.Traffic_T00_Lane_Act_LaneId.data;
       
        name_string3 = ['TObj.Lane.t2Ref(n) = data.Traffic_T' num2str(ObjID) '_t2Ref.data(n) ' ];
        eval(name_string3);
        %TObj.Lane.t2Ref = data.Traffic_T00_t2Ref.data;
    elseif TObj.ObjID(n,2) ~= -1 && TObj.ObjID(n,2) == 0
        %% Attention! here should care the Init Objct ID: T00 or T0?
         % Maximal munber of the Car: 241
        TObj.Car.ax(n) = data.Traffic_T0_a_1_x.data(n);
        TObj.Lane.Act_LaneId(n) = data.Traffic_T0_Lane_Act_LaneId.data(n);
        TObj.Lane.t2Ref(n) = data.Traffic_T0_t2Ref.data(n);      
    else
        TObj.Car.ax(n) = 0;
        TObj.Lane.Act_LaneId(n) = 2;
        TObj.Lane.t2Ref(n) = 0;
    end
    
end


%save selected Data in mat file
clear ('data', 'path2ergfile','n','ObjID','name_string','name_string1');
clear('name_string2');
clear('name_string3');
save('prepdata.mat')
end
