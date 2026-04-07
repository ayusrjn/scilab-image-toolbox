function [level] = graythresh(img)
    // 1. Handle CSV double arrays and scale properly
    if max(img) <= 1 then
        img_int = round(img * 255);
    else
        img_int = round(img); // Ensure exact integers for CSV inputs
    end
    
    // 2. Compute Histogram and force column vectors
    [ind, counts] = dsearch(img_int(:), -0.5:255.5);
    p = counts(:) / sum(counts); // Force 'p' to be a column vector
    pixel_vals = (0:255)';       // Force pixel values to be a column vector
    
    // =========================================================
    // 3. VECTORIZED OTSU'S METHOD (No for-loops!)
    // =========================================================
    
    // Calculate weights using cumulative sum
    omega = cumsum(p); 
    
    // Calculate running mean using cumulative sum
    mu = cumsum(pixel_vals .* p); 
    mu_t = mu(256); // The total mean of the entire image
    
    // Protect against division by zero at the extreme edges
    omega(omega == 0) = %eps;
    omega(omega == 1) = 1 - %eps;
    
    // Calculate Between-Class Variance for ALL 256 thresholds instantly
    sigma_b_squared = ((mu_t .* omega) - mu).^2 ./ (omega .* (1 - omega));
    
    // Find the threshold that produced the highest variance
    [max_var, max_idx] = max(sigma_b_squared);
    
    // max_idx is 1-based (1 to 256), so subtract 1 to get pixel value (0 to 255)
    optimal_threshold = max_idx - 1; 
    
    // Normalize to [0, 1] to match Octave
    level = optimal_threshold / 255;
    
endfunction
