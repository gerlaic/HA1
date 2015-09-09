%   import function
%   note that for our test data, it's too small for Matlab to think it's
%   significant. Matlab will automatically think x = 0 if x < 0.00005. One
%   way to solve this problem is multiply a reasonable factor to the data
%   we want. 

function [freq, amplitude] = importData(filename)
data = xlsread(filename);
freq = data(:,1);
amplitude = data(:,2);