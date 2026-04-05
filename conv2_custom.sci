function out = conv2_custom(img, kernel)

    [m, n] = size(img);
    [km, kn] = size(kernel);

    pad_m = floor(km/2);
    pad_n = floor(kn/2);

    // Zero padding
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
