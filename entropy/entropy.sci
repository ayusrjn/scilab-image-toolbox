function E = entropy(IM, NBINS)

    // --- 1. Handle default bins ---
    if argn(2) < 2 then
        if typeof(IM) == "boolean" then
            NBINS = 2;
        else
            NBINS = 256;
        end
    end

    // --- 2. Convert to double ---
    IM = double(IM);
    pixels = IM(:);

    // --- 3. Handle constant image ---
    min_val = min(pixels);
    max_val = max(pixels);

    if max_val == min_val then
        E = 0;
        return;
    end

    // --- 4. Octave-style binning (range-based) ---
    // Scale into [0, NBINS-1]
    scaled = (pixels - min_val) ./ (max_val - min_val) * (NBINS - 1);

    // IMPORTANT: use floor like histogram binning
    scaled = floor(scaled);

    // Fix boundary issues
    scaled(scaled < 0) = 0;
    scaled(scaled > NBINS-1) = NBINS-1;

    // --- 5. Build histogram ---
    histo = zeros(1, NBINS);

    for i = 1:length(scaled)
        idx = scaled(i) + 1; // Scilab indexing
        histo(idx) = histo(idx) + 1;
    end

    // --- 6. Convert to probability ---
    P = histo / sum(histo);

    // --- 7. Remove zero bins ---
    P = P(P > 0);

    // --- 8. Compute entropy ---
    E = -sum(P .* log2(P));

endfunction
