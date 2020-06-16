function result = unmask(x)

global no_shares

result = zeros(size(x,1),1);
for i=1:no_shares
    result = bitxor(result, x(:,i));
end

end