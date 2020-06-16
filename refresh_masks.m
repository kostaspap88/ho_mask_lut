function z = refresh_masks(x)

global no_shares no_elements

z = zeros(1, no_shares);
z(no_shares) = x(no_shares);
for i=1:no_shares-1
    
    tmp = randi(no_elements) - 1;
    z(i) = bitxor(x(i), tmp);
    z(no_shares) = bitxor(z(no_shares), tmp);
    
end

end