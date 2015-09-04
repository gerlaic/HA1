%   This program is for testing infinite thick film
%   Hassan Arbab Group
%   Bing, Zac
%   This is the program designed to analyze the first test data set. It's 
%   an improved version of "general_handler.m".
%   Please note this program uses helper functions like getN12 as
%   well as the Main program "general_handler.m". It cannot run
%   individually. 
%   Contact Bing at gb1701@163.com or Skype "gerlaic" to edit the program. 

clear all; clc; close all;

%parameters
max_length = 100;
theta_1_deg = 60;
c = 3E8; %speed of light
e_1 = 1;
h_2 = 1;
p_1 = 1;
%e_theory = 1;
threshold = 0.000001;

%   input part.
%   When importing datam make sure to comment out the overide test input
%   commands like "input_freq = 1:1:input_size;" and change "input_freq =
%   [];" to "input_freq = $some_proper_input_format"
input_size = 100;
input_freq = 1:1:input_size;
%input_freq = [];   %actual cmd for test

input_r = zeros(input_size,1);
%input_r = [];  %actual cmd for test

output_r = zeros(input_size,1);

%basic calculation
theta_1_rad = theta_1_deg /180 * pi;

for i=1:length(input_freq)
    %start of solving
    k_0 = 2*pi*input_freq(i);
    
    %N matrix
    n11 = 1;
    n12 = getN12(k_0,h_2);
    n21 = getN21(k_0,h_2,theta_1_rad,e_1);
    n22 = 1;

    %r1 calulation: r1 = ru/rb
    rr = p_1*n22-p_1*n11-p_1*p_1*n12;
    rr = expand(rr,3);
    ru = n21 + rr;

    rr = p_1*n11 - p_1*p_1*n12+p_1*n22;
    rr = expand(rr,3);
    rb = rr - n21;
    
    %calculate r2 from Q1
    %I tested once and there is a problem here. There are multiple
    %solutions to this equation. Need a way to figure out which one we
    %want.
    syms r1;
    e2 = solve((ru(1)*r1^2+ru(2)*r1+ru(3)*r1)/(rb(1)*r1^2+ru(2)*r1+ru(3)...
        *r1) == input_r(i));
    
    j = 0;
    diff = 100000;
    
    while diff > threshold
        j = j+1;
        
        level = 2*j;
        
        %N^j...something I cannot make it a function

        old11 = n11;
        old12 = n12;
        old21 = n21;
        old22 = n22;

        nn11 = n11;
        nn12 = n12;
        nn21 = n21;
        nn22 = n22;
        ii = level;
        while ii>1
            %nn11...
            nn111 = old11*n11;
            nn112 = old12*n21;

            if length(nn111)<length(nn112)
                nn111 = expand(nn111,length(nn112));
            elseif length(nn111)>length(nn112)
                nn112 = expand(nn112,length(nn111));
            end

            nn11 = nn111+nn112;

            %nn12...
            nn121 = old11*n12;
            nn122 = old12*n22;

            if length(nn121)<length(nn122)
                nn121 = expand(nn121,length(nn122));
            elseif length(nn121)>length(nn122)
                nn122 = expand(nn122,length(nn121));
            end

            nn12 = nn121+nn122;

            %nn21
            nn211 = old21*n11;
            nn212 = old22*n21;

            if length(nn211)<length(nn212)
                nn211 = expand(nn211,length(nn212));
            elseif length(nn211)>length(nn212)
                nn212 = expand(nn212,length(nn211));
            end

            nn21 = nn211+nn212;

            %nn22
            nn221 = old21*n12;
            nn222 = old22*n22;

            if length(nn221)<length(nn222)
                nn221 = expand(nn221,length(nn222));
            elseif length(nn221)>length(nn222)
                nn222 = expand(nn222,length(nn221));
            end

            nn22 = nn221+nn222;

            %update old-s
            old_11 = nn11;
            old_12 = nn12;
            old_21 = nn21;
            old_22 = nn22;

            ii = ii-1;
        end
        
        %solve e_2 from it
        %I'm double checking the dimension of the equation. It looks
        %unsolvable right now...
        
        %get the difference 
        diff = e2_new - e2;
        e2 = e2_new;
    end

    output_e(i) = e2;
end


%   plot part
figure;
subplot(211);
plot(input_freq, real(output_r));%plot freq vs real e2
subplot(212);
plot(input_freq, imag(output_r));%plot freq vs imag e2



