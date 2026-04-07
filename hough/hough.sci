function [H, theta, rho] = hough(BW, varargin)
    // HOUGH Computes the Hough transform to find lines in a binary image.
    // Inputs:
    //   BW: Binary image (matrix of 0s and 1s)
    //   varargin: Optional 'Theta' or 'ThetaResolution' properties
    
    // 1. Set Default Parameters
    theta = -90:89; // Default Theta as per Octave docs
    
    // 2. Parse Optional Arguments (varargin)
    i = 1;
    while i <= length(varargin)
        if type(varargin(i)) == 10 then // Check if it's a string
            prop = convstr(varargin(i), 'l'); // Convert to lowercase for safety
            
            if prop == 'theta' then
                theta = varargin(i+1);
                i = i + 2;
            elseif prop == 'thetaresolution' then
                res = varargin(i+1);
                // Create vector excluding +90 deg
                theta = -90:res:89.999; // Cap it just below 90 to match Octave behavior
                i = i + 2;
            else
                error('hough: Unknown property ''' + varargin(i) + '''');
            end
        else
            error('hough: Property names must be strings.');
        end
    end
    
    // 3. Setup Coordinate System and Parameter Space
    [rows, cols] = size(BW);
    
    // Find non-zero pixels (edges)
    [y, x] = find(BW <> 0);
    
    // Adjust coordinates to use 0-based indexing for accurate mathematical distance 
    // from the top-left origin, which is standard for image processing Hough transforms.
    x = x - 1; 
    y = y - 1;
    
    // Convert Theta to radians for trigonometric functions
    theta_rad = theta * %pi / 180;
    num_thetas = length(theta);
    
    // Calculate the maximum possible Rho (diagonal of the image)
    diagonal_len = norm([rows, cols]);
    rho_max = ceil(diagonal_len);
    
    // Create Rho vector
    rho = -rho_max:rho_max;
    num_rhos = length(rho);
    
    // Initialize Accumulator Matrix
    H = zeros(num_rhos, num_thetas);
    
    // 4. Compute the Hough Transform
    // For every angle, calculate the rho for all edge pixels simultaneously
    for i = 1:num_thetas
        // Calculate rho:  rho = x*cos(theta) + y*sin(theta)
        r = x * cos(theta_rad(i)) + y * sin(theta_rad(i));
        
        // Round to nearest integer to find the matrix bin
        r_idx = round(r) + rho_max + 1; // +1 for 1-based matrix indexing in Scilab
        
        // Accumulate votes in the H matrix
        for j = 1:length(r_idx)
            if r_idx(j) >= 1 & r_idx(j) <= num_rhos then
                H(r_idx(j), i) = H(r_idx(j), i) + 1;
            end
        end
    end
endfunction
