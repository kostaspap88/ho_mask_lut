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
sbox = [99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];

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



