function [BW, THRESH] = edge(IM, varargin)
    // Wrapper function to mimic Octave's edge() behavior
    [lhs, rhs] = argn(0);
    
    if rhs < 1 then
        error("edge: Requires at least one input argument (the image).");
    end

    METHOD = "sobel";
    if rhs >= 2 then
        METHOD = convstr(varargin(1), "l");
    end

    thresh_provided = %f;
    thresh_val = 0;
    if rhs >= 3 then
        thresh_provided = %t;
        thresh_val = varargin(2);
    end

    select METHOD
        case "sobel" then
            if thresh_provided then
                [BW, THRESH] = edge_sobel(IM, thresh_val);
            else
                [BW, THRESH] = edge_sobel(IM);
            end
        case "prewitt" then
            if thresh_provided then
                [BW, THRESH] = edge_prewitt(IM, thresh_val);
            else
                [BW, THRESH] = edge_prewitt(IM);
            end
        case "roberts" then
            if thresh_provided then
                [BW, THRESH] = edge_roberts(IM, thresh_val);
            else
                [BW, THRESH] = edge_roberts(IM);
            end
        else
            error("edge: Method '" + varargin(1) + "' is not fully implemented yet.");
    end
endfunction

// ==========================================
// Edge Thinning (Non-Maximum Suppression)
// ==========================================
function nms = non_max_suppression(mag, Ix, Iy)
    [m, n] = size(mag);
    
    // Calculate angle of the gradient in degrees (0 to 180)
    angle = atan(Iy, Ix) * 180 / %pi;
    angle(angle < 0) = angle(angle < 0) + 180;
    
    // Create shifted matrices to look at neighbors
    mag_L  = [zeros(m,1), mag(:, 1:n-1)];
    mag_R  = [mag(:, 2:n), zeros(m,1)];
    mag_U  = [zeros(1,n); mag(1:m-1, :)];
    mag_D  = [mag(2:m, :); zeros(1,n)];
    mag_UL = [zeros(1,n); [zeros(m-1,1), mag(1:m-1, 1:n-1)]];
    mag_UR = [zeros(1,n); [mag(1:m-1, 2:n), zeros(m-1,1)]];
    mag_DL = [[zeros(m-1,1), mag(2:m, 1:n-1)]; zeros(1,n)];
    mag_DR = [[mag(2:m, 2:n), zeros(m-1,1)]; zeros(1,n)];
    
    // Angle masks
    m0   = (angle >= 0 & angle < 22.5) | (angle >= 157.5 & angle <= 180);
    m45  = (angle >= 22.5 & angle < 67.5);
    m90  = (angle >= 67.5 & angle < 112.5);
    m135 = (angle >= 112.5 & angle < 157.5);
    
    // Initialize neighbor values
    q = zeros(m, n);
    r = zeros(m, n);
    
    // Select neighbors based on gradient direction
    q(m0) = mag_R(m0);      r(m0) = mag_L(m0);
    q(m45) = mag_DR(m45);   r(m45) = mag_UL(m45);
    q(m90) = mag_D(m90);    r(m90) = mag_U(m90);
    q(m135) = mag_DL(m135); r(m135) = mag_UR(m135);
    
    // Suppress non-maximums
    keep = (mag >= q) & (mag >= r);
    nms = mag .* keep;
endfunction

// ==========================================
// Custom Convolution
// ==========================================
function out = conv2_custom(img, kernel)
    [m, n] = size(img);
    [km, kn] = size(kernel);

    pad_m = floor(km/2);
    pad_n = floor(kn/2);

    padded = zeros(m + 2*pad_m, n + 2*pad_n);
    padded(1+pad_m:m+pad_m, 1+pad_n:n+pad_n) = img;
    out = zeros(m, n);

    for i = 1:m
        for j = 1:n
            region = padded(i:i+km-1, j:j+kn-1);
            out(i,j) = sum(region .* kernel);
        end
    end
endfunction

// ==========================================
// Algorithm Implementations
// ==========================================
function [BW, THRESH] = edge_sobel(IM, thresh)
    IM = double(IM);
    Gx = [-1 0 1; -2 0 2; -1 0 1];
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];

    Ix = conv2_custom(IM, Gx);
    Iy = conv2_custom(IM, Gy);
    mag = sqrt(Ix.^2 + Iy.^2);

    if argn(2) < 2 then
        THRESH = 2 * sqrt(mean(mag.^2)); 
    else
        THRESH = thresh;
    end

    nms = non_max_suppression(mag, Ix, Iy);
    BW = nms > THRESH;
endfunction

function [BW, THRESH] = edge_prewitt(IM, thresh)
    IM = double(IM);
    Gx = [-1 0 1; -1 0 1; -1 0 1];
    Gy = [-1 -1 -1; 0 0 0; 1 1 1];

    Ix = conv2_custom(IM, Gx);
    Iy = conv2_custom(IM, Gy);
    mag = sqrt(Ix.^2 + Iy.^2);

    if argn(2) < 2 then
        THRESH = 2 * sqrt(mean(mag.^2));
    else
        THRESH = thresh;
    end

    nms = non_max_suppression(mag, Ix, Iy);
    BW = nms > THRESH;
endfunction

function [BW, THRESH] = edge_roberts(IM, thresh)
    IM = double(IM);
    Gx = [1 0; 0 -1];
    Gy = [0 1; -1 0];

    Ix = conv2_custom(IM, Gx);
    Iy = conv2_custom(IM, Gy);
    mag = sqrt(Ix.^2 + Iy.^2);

    if argn(2) < 2 then
        THRESH = 2 * sqrt(mean(mag.^2)) * sqrt(1.5); 
    else
        THRESH = thresh;
    end

    // Rotate gradients 45 degrees so NMS understands the diagonal edges
    Ix_standard = Ix - Iy;
    Iy_standard = Ix + Iy;

    nms = non_max_suppression(mag, Ix_standard, Iy_standard);
    BW = nms > THRESH;
endfunction
