%   findA
%   This sub-code takes the Si-air data and uses it to find the incident
%   amplitudes. Probably could be done without using matrix method but it
%   serves as a good check to see if there are any problems 

function A = findA(e_1, q_1, theta_1_rad, filename)
%   Variables
e_air = 1; % Precision can be added here
theta_air = asin(sin(theta_1_rad) * sqrt(e_1)/sqrt(e_air));
q_air = sqrt(1/e_air) * cos(theta_air); 
refData = importData(filename);
A = zeros(height(refData), 1);
for ii = 1:height(refData)
    R = sqrt(refData(ii, 2));% this is the measured reflected amplitude. 
    %             It should be the square-root of the measured frequency-
    %             domain data for the reference measurements

    %   Opperations
    TA = [1, -1; q_air, (q_1)];
    RR = [R; q_1 * R];
    a = rref([TA, RR]);
    A(ii, 1) = a(1, end);
end
end
