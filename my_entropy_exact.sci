function E = my_entropy_octave_fast(IM, NBINS)

    if argn(2) < 2 then
        NBINS = 256;
    end

    IM = double(IM);
    pixels = IM(:);

    min_val = min(pixels);
    max_val = max(pixels);

    // Scale pixels into bin indices [1, NBINS]
    scaled = floor((pixels - min_val) ./ (max_val - min_val) * (NBINS - 1)) + 1;

    // Handle edge case
    scaled(scaled < 1) = 1;
    scaled(scaled > NBINS) = NBINS;

    // Histogram
    histo = zeros(1, NBINS);
    for i = 1:length(scaled)
        histo(scaled(i)) = histo(scaled(i)) + 1;
    end

    // Probability
    P = histo / sum(histo);
    P = P(P > 0);

    E = -sum(P .* log2(P));

endfunction
