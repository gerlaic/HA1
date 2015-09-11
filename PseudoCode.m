%   This is pseudo-code/incomplete code to outline the steps of our
%   problem. It is partially based on the code written by Bing (infinite.m)
%   but should not depend on it to work.
tol 

%init
clear all; clc; close all;

%   Specified parameters
%   Remember to change them into proper values before sending in inputs.
refDataFile = '[REFERENCE DATA FILE NAME]';
testDataFile = '[TEST DATA FILE NAME]';

theta_1_deg = 57; % this figure was given by Wenwei [degrees]
e_1 = 3.42; % Si permitivity check it on riken.jp/Thzdatabase [unitless]
h_2 = 15; % Nominal thickness of the sample [
c = 3E8;% Speed of light m/s
threshold = 0.001; % maximum allowable error

%   Calculated parameters
%   From given
theta_1_rad = theta_1_deg /180 * pi;
q_1 = sqrt(1/e_1) * cos(theta_1_rad);

%   Imported parameters
A_all = findA(e_1, q_1, theta_1_rad, refDataFile);
testData = importData(testDataFile);
R_tot = sqrt(testData(ii, 2));% this is the measured reflected amplitude.
%                 It should be the square-root of the measured frequency-
%                 domain data for the sample measurements


for ii = 1:height(testData)
    A = A_all(ii);
    R = R_tot(ii);
    k_0 = testData(ii, 1) * 1E12/c;
    %   Start Calculating refractive index
    %   Zeroth Order
    qT = [1, 0; 0, 1 / q_1];
    AR = [A + R); R - A];
    transmit = rref([qT, AR]);
    q_2 = transmit(2, end) / transmit(1, end); %transmit(1, end) is T
    n_2 = sqrt(sin(theta_1_rad) * sqrt(e_1) / q_2);
    e_2 = sqrt(n_2);
    order = 0;% initializing order
    e_error = inf; %initializing error

    %   Multiple order
    while e_error > threshold
        %   Handle previous loop's values
        order = order + 1; %increment number of reflections off of Au side
        e_prev = e_2;
        e_error_prev = e_error;

        %   Calculation Starts Here
        %       TODO-Zac: figure out the way to set this up
        %           [formula for]R_tot_prev + T_next = R_tot
        %   Calculation Ends Here

        %   Error Calculation and tolerance check
        e_error = abs(e_2 - e_prev);% TODO-Zac: should this be percent?
        if e_error_prev > e_error % this means non-converging
            %throw error or otherwise handle
        end % any other error types to handle?


    end
end

%Store e_2 and other values where they are going to be stored and handle
%anything else that needs to be handled for an individual frequency value.

% Here is where a frequency loop would end

%Handle complete data set and plot 
