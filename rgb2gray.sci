function gray = rgb2gray(img)
    [h, w, c] = size(img);
    
    if c <> 3 then
        error("Input must be RGB image");
    end
    
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    
    gray = 0.2989 * R + 0.5870 * G + 0.1140 * B;

endfunction
