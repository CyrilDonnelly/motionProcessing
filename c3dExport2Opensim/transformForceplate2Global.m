function transformForceplate2Global(structData)






% The corners of the forceplates are written in a particular order. The
% first column (corner 1) is the bottom left corner of the plate. The
% fourth column (corner 4) is the bottom right. 
%
% Using this convention, we can get the direction of the forceplate in the
% global frame. If the forceplate is NOT in the same direction as the
% global frame, we can rotate it accordingly. 
%
% xGlobal = 1,0,0
% yGlobal = 0,1,0
% zGlobal = 0,0,1
%

% Get teh number of forceplates
nFp = size(structData.fp_data);

xGlobal = [1 0 0];

% Loop through the forceplates 
for i = 1 : nFp

    corners = structData.fp_data.FP_data(i).corners;


    xDirection = (corners(:,2)-corners(:,1))';
    yDirection = (corners(:,1)-corners(:,4))';

    x = xDirection./abs(xDirection);
    y = yDirection./abs(yDirection);

    % Get rid of the nan's in the matrix
    for u = 1:3
        if isnan(x(u)) 
           x(u) = 0;
        end
    end


    angle = rad2deg(atan2(norm(cross(xGlobal,x)),dot(xGlobal,x)));

    % Determine the sense of the z axis created from crossing the
    % global X with the forceplate X. If the z axis is positive, that
    % implies the forceplate X is an anit-clockise roation away from
    % the Global X. Therefore, we will have to apply a clockwise (-)
    % rotation to the forceplate X to align it with global. 
    if angle == 90
        rotation = -sum(cross(xGlobal,x)) * angle;
    elseif angle == 180
        rotation = 180;
    elseif angle == 0
        
    end

    
    if angle > 0
    
      % Dump out the forces and moments into an nX3 matrix
      forces = eval(['[structData.fp_data.FP_data(i).channels.Fx'  num2str(i) ' structData.fp_data.FP_data(i).channels.Fy' num2str(i) ' structData.fp_data.FP_data(i).channels.Fz' num2str(i) '];'])
      moments = eval(['[structData.fp_data.FP_data(i).channels.Mx'  num2str(i) ' structData.fp_data.FP_data(i).channels.My' num2str(i) ' structData.fp_data.FP_data(i).channels.Mz' num2str(i) '];'])
       
      % rotate the forces and moments
      [forces]  = rotateCoordinateSys(forces,  rotAxis, rotation);
      [moments] = rotateCoordinateSys(moments, rotAxis, rotation);
      
      % Reconstitute the forces and moment data in the structure
      eval(['structData.fp_data.FP_data(i).channels.Fx' num2str(i) ' = forces(:,1);'])
      eval(['structData.fp_data.FP_data(i).channels.Fy' num2str(i) ' = forces(:,2);'])
      eval(['structData.fp_data.FP_data(i).channels.Fz' num2str(i) ' = forces(:,3);'])
      
      eval(['structData.fp_data.FP_data(i).channels.Mx' num2str(i) ' = forces(:,1);'])
      eval(['structData.fp_data.FP_data(i).channels.My' num2str(i) ' = forces(:,2);'])
      eval(['structData.fp_data.FP_data(i).channels.Mz' num2str(i) ' = forces(:,3);'])
      
    end
    
end












