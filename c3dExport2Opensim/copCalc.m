function [structData] = copCalc(structData)
% Calculates the COP from force and moment data 
%   Assumes all forces, moments and forceplate coordinates

% Written by Thor Besier, James Dunne, Cyril (Jon) Donnelly, 2008
% Last Modified; James Dunne, May (2014).     

for i = 1 : length(structData.fp_data.GRF_data)
        
        % Place these data into their variable Name. This is slower but is
        % easier to read and make ajustments later.
        
        fx = structData.fp_data.GRF_data(i).F(:,1);
        fy = structData.fp_data.GRF_data(i).F(:,2);
        fz = structData.fp_data.GRF_data(i).F(:,3);
        mx = structData.fp_data.GRF_data(i).M(:,1);
        my = structData.fp_data.GRF_data(i).M(:,2);
        mz = structData.fp_data.GRF_data(i).M(:,3);

        % Dump out the forceplate X&Y coordinates
        xCorners = structData.fp_data.FP_data(i).corners(:,1);
        yCorners = structData.fp_data.FP_data(i).corners(:,2); 
        
        fpCenter = ...
        (structData.fp_data.FP_data(i).corners(1,:) +...
        structData.fp_data.FP_data(i).corners(2,:) +...
        structData.fp_data.FP_data(i).corners(3,:) +...
        structData.fp_data.FP_data(i).corners(4,:))/4
        
        
        % get the height of the forceplate below ground
        h = mean(round(structData.fp_data.FP_data(i).corners(:,3)));
        if h == 0
            h  = 1;
        end

        % Calculate the COP from the forces and moments
        COPx = ((-h*fx - my)./fz) + fpCenter(1);
        COPy = fpCenter(2) - ((-h*fy - mx)./fz) ;
        COPz = zeros(length(COPx),1);
              
        % Calculate the free moment (Tz) of the forceplate
        a  =  mz;
        b  =  fy.*(COPx-xlength/2);
        c  =  (COPy-ylength/2).*fx;
        Tz =  (a-b+c)./1000;
            
        Tx = zeros(1,length(Tz))';
        Ty = Tx;
            
        % take out any Nans
        nNaN    = find(isnan(COPx));
        COPx(nNaN) = 0;
        COPy(nNaN) = 0;
        COPz(nNaN) = 0;
        Ty(nNaN)   = 0;
        Tz(nNaN)   = 0;
        Tx(nNaN)   = 0;
        
        % Plot the calculated COP vs the original COP
        % hold on 
        % plot(structData.fp_data.GRF_data(i).P,'k')
        % plot(COPx,'b')
        % plot(COPy,'r')

        % back up the original COP in the struct
        structData.fp_data.GRF_data(i).P_old = structData.fp_data.GRF_data(i).P;
        % save the processed COP to the structure
        structData.fp_data.GRF_data(i).P(:,1:2) = [COPx COPy COPz];  
        % save the processed Z torque to the structure
        structData.fp_data.GRF_data(i).M = [Tx Ty Tz];  
         
end
       
end