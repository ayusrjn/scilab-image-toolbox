function E = entropy(IM, NBINS)

    // Handle default bins

    if argn(2) < 2 then
        if typeof(IM) == "boolean" then
            NBINS = 2;
        else
            NBINS = 256;
        end
    end

    // Convert to double
    IM = double(IM);

    // Flatten the pixels 
    pixels = IM(:);

    // Handle constant image
    min_val = min(pixels);
    max_val = max(pixels);

    // Check if Image is same color constant image

    if max_val == min_val then
        E = 0;
        return;
    end

    // Scale into [0, NBINS-1]
    scaled = (pixels - min_val) ./ (max_val - min_val) * (NBINS - 1);

    scaled = floor(scaled);

    // Fix boundary issues
    scaled(scaled < 0) = 0;
    scaled(scaled > NBINS-1) = NBINS-1;

    // Build histogram
    histo = zeros(1, NBINS);

    for i = 1:length(scaled)
        idx = scaled(i) + 1; // Scilab indexing
        histo(idx) = histo(idx) + 1;
    end

    // Convert to probability
    P = histo / sum(histo);

    // Remove 0 bins because log(0) will be undefined in the entropy formula
    P = P(P > 0);

    // Shannon Entropy Formula
    E = -sum(P .* log2(P));

endfunction
