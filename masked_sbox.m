function result = masked_sbox(x)

global no_shares no_elements sbox range

T = zeros(no_shares, no_elements);
Tprime = zeros(no_shares, no_elements);


T(1,:) = sbox;
for i=2:no_shares
   T(i,:) = zeros(1,no_elements); 
end


for i=1:no_shares-1
   for u=range
       for j=1:no_shares
          Tprime(j, u + 1) = T(j, bitxor(u, x(i)) + 1);
       end
   end

   for u=range
       T(:, u+1) = refresh_masks(Tprime(:, u+1)'); 
   end

end

result = refresh_masks(T(:, x(no_shares) + 1)');




end