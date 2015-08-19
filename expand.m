function r = expand(x,len)
    r = zeros(1,len);
    xl = length(x);
    for i = 1:xl
        r(i+len-xl) = x(i);
    end
end