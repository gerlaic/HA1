

clear all; clc; close all;

%parameters
max_length = 100;
theta_1_deg = 60;
k_0 = 100;
e_1 = 1;
h_2 = 1;
p_1 = 1;
e_theory = 1;
threshold = 0.001;

%basic calculation
theta_1_rad = theta_1_deg /180 * pi;

%start of solving
r = zeros(1,length(bigR));
for ii = 1:length(bigR)
    r(ii) = bigR(ii)/bigA(1);
end

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

%N^j...something I cannot make it a function
level = 2;

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

t_list = zeros(max_length,1);

%solve 1st e_2 from r
%I will find a way to do it in matlab.... 
%solution 1: make this part in another function, using solve()
%solution 2: transfer it into some expansion form. Check 227/228
equ = zeros(length(ru),1);
equ = deconv(ru,rb);
%temp%
e_2 = 0.5;

%solve for e_2
ii = 0;
while e_theory-e_2 > threshold
    ii = ii+1;
    
    %solve t_j (j = ii*2+1)
    t_list(ii) = nn11 + deconv(conv(nn11,ru),rb) + conv(nn12, p_1)...
        +deconv(conv(conv(nn12,p_1),ru),rb);
    
    %solve for e_2
    %check if we need to expand our equation or t_j...
    if length(equ)<length(t_list(ii))
        equ=expand(equ,length(t_list(ii)));
    elseif length(equ)>length(t_list(ii))
        t_list(ii) = expand(t_list,length(equ));
    end
    
    %get the new equ
    equ = equ + t_list(ii);
    
    %solve
    %same problem.. make this part in another function using solve()
    %or find a way to expand it.
end

%output result
output_list = zeros(max_length, 1);
csvwrite('output_list.dat', output_list);




