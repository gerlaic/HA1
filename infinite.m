%   This program is for testing infinite thick film
%   Hassan Arbab Group
%   Bing, Zac
%   This program only calculate for r1 with different frequency and reflect
%   inputs. Please note this program uses helper functions like getN12 as
%   well as the Main program "general_handler.m". It cannot run
%   individually. 
%   Contact Bing at gb1701@163.com or Skype "gerlaic" to edit the program. 

%init
clear all; clc; close all;

%   parameters
%   Remember to change them into proper values before sending in inputs.
theta_1_deg = 60;
k_0 = 100; %calulate from different frequencies
e_1 = 1; %check it on riken.jp/Thzdatabase
h_2 = 1; %thickness <-- no need
p_1 = 1; %calculate from theta_1 & e_1
e_theory = 1; % <-- no need
threshold = 0.001; % <-- no need

%   input part.
%   When importing datam make sure to comment out the overide test input
%   commands like "input_freq = 1:1:input_size;" and change "input_freq =
%   [];" to "input_freq = $some_proper_input_format"
input_size = 100
input_freq = 1:1:input_size;
%input_freq = [];   %actual cmd for test

input_r = zeros(input_size,1);
%input_r = [];  %actual cmd for test

output_e = zeros(input_size,1);

%basic calculation
theta_1_rad = theta_1_deg /180 * pi;

%r1 calculation: r1 = ru/rb
%N matrix
n11 = 1;
n12 = getN12(k_0,h_2);
n21 = getN21(k_0,h_2,theta_1_rad,e_1);
n22 = 1;

%r1 calulation: r1 = ru/rb
rr = p_1*n22 - p_1*n11 - p_1*p_1*n12;
ru = n21 + rr;

rr = p_1*n11 - p_1*p_1*n12 + p_1*n22;
rb = rr - n21;

%   solve for different input frequency and reflect
for i=1:length(input_r)
    syms r1;
    output_e(i) = solve((ru(1)*r1^2+ru(2)*r1+ru(3)*r1)/(rb(1)*r1^2+ru(2)*r1+ru(3)*r1) == output_e(i));
    %   this currently throws an error due to there is no solution for
    %   current parameters.
end

%   plot part
figure;
subplot(211);
plot(input_freq, real(output_e));%plot freq vs real e2
subplot(212);
plot(input_freq, imag(output_e));%plot freq vs imag e2
