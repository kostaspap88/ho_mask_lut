% Computing the lookup tables for higher order masking of the AES Sbox
% operation
% Based on "Higher Order Masking of Look-up Tables" by Coron

clear all
close all

% PARAMETERS---------------------------------------------------------------

% number of shares
global no_shares
no_shares = 6;

% number of traces
global no_traces
no_traces = 10;

% table element size in bits
global bitsize range no_elements
bitsize = 8;
% table range and number of elements
range = 0:2^bitsize-1;
no_elements = 2^bitsize;

% Sbox LUT
global sbox
sbox = ones(1,256);

% key value (must be in correct range)
global key
key = 10;


% INPUT SIMULATION---------------------------------------------------------

% simulate random input x_unmasked
x_unmasked = randi(no_elements, no_traces, 1) - 1;

% generate no_shares - 1 random numbers to split x into the shares
% x0, x1, x2, ... , x_(no_shares-1). Store all shares in matrix x

x = zeros(no_traces, no_shares);
temp = x_unmasked;
for i=1:no_shares-1
   
    % generate random number
    r = randi(no_elements, no_traces, 1) - 1;
    % store as a share
    x(:,i) = r;
    % mask the x_unmasked
    temp = bitxor(temp, r);
    
end

x(:,no_shares) = temp;

% correctness check
check_input = isequal(unmask(x), x_unmasked); 


% UNMASKED ADDROUNDKEY COMPUTATION-----------------------------------------

% perform the operation x_unmasked XOR key 

y_unmasked = bitxor(x_unmasked, key);


% MASKED ADDROUNDKEY COMPUTATION-------------------------------------------

% perform the operation (x0, x1, x2, ... ) XOR key

y(:,1) = bitxor(x(:,1), key);
for i=2:no_shares
    y(:,i) = x(:,i);
end

% correctness check
check_addrk = isequal(unmask(y), y_unmasked);


% UNMASKED SBOX LUT COMPUTATION--------------------------------------------

z_unmasked = zeros(no_traces, 1);
for trace_index = 1:no_traces
 
    z_unmasked(trace_index) = sbox(y_unmasked(trace_index) + 1);
    
end


% MASKED SBOX LUT COMPUTATION----------------------------------------------

z = zeros(no_traces, no_shares);
for trace_index = 1:no_traces
    
    z(trace_index, :) = masked_sbox(y(trace_index, :));

end

% correctness check
check_sbox = isequal(unmask(z), z_unmasked);



