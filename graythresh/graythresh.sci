function [level] = graythresh(img)
    // Handle edge case of an entirely constant image (no classes to split)
    img_min = min(img);
    img_max = max(img);
    if img_min == img_max then
        level = 0.0;
        return;
    end
    
    // Scale image values to 0-255 integer range if they are fractions
    if img_max <= 1 then
        img_int = round(img * 255);
    else
        img_int = round(img);
    end
    
    // Count how many pixels have each color value (creating a histogram)
    [ind, counts] = dsearch(img_int(:), -0.5:255.5);
    p = counts(:) / sum(counts); // Probability of each color
    pixel_vals = (0:255)';
    
    // Apply Otsu's Method (calculates the best threshold to separate foreground and background)
    
    // Track the cumulative probability (weight) up to each pixel value
    omega = cumsum(p); 
    
    // Track the cumulative mean up to each pixel value
    mu = cumsum(pixel_vals .* p); 
    mu_t = mu(256); // Mean of the entire image
    
    // Avoid dividing by zero at the extremely dark or bright ends
    omega(omega == 0) = %eps;
    omega(omega == 1) = 1 - %eps;
    
    // Calculate the variance between the two classes for all 256 possible thresholds
    sigma_b_squared = ((mu_t .* omega) - mu).^2 ./ (omega .* (1 - omega));
    
    // The best threshold is the one where this variance is highest
    // If the variance creates a flat plateau, average the indices to find the center!
    max_var = max(sigma_b_squared);
    max_indices = find(sigma_b_squared == max_var);
    max_idx = mean(max_indices);
    
    // Subtract 1 because Scilab arrays start at 1 but pixel intensities start at 0
    optimal_threshold = max_idx - 1;
    
    // Return the final threshold normalized between 0 and 1
    level = optimal_threshold / 255;
endfunction

