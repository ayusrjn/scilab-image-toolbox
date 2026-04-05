function [BW, THRESH] = edge_sobel(IM, thresh)

    IM = double(IM);

    // Sobel kernels
    Gx = [-1 0 1;
          -2 0 2;
          -1 0 1];

    Gy = [-1 -2 -1;
           0  0  0;
           1  2  1];

    // Gradient
    Ix = conv2_custom(IM, Gx);
    Iy = conv2_custom(IM, Gy);

    // Magnitude
    mag = sqrt(Ix.^2 + Iy.^2);

    // Auto threshold (like Octave style)
    if argn(2) < 2 then
        THRESH = mean(mag)/2;
    else
        THRESH = thresh;
    end

    // Binary edge map
    BW = mag > THRESH;

endfunction
