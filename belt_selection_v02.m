%Selection of Belts
%for Timing Pulley (2 mm (GT2) Pitch,36 Teeth, 6mm Bore, 6mm Wide)
%%
%required input data
    %1. Power to be transmitted
	%2. Transmission Ratio
    %3. Center Distance
%%
%1. Determination of design load
%parameters
F = 0.3; %[kg] max load
SF = 2; %service factor (generally recommended between 1.5 and 2)
d_cr = 0.1; %[m] distance from center of load to rotation axis

T = F*9.81*d_cr; %[N-m]
T_peak = T*SF; %[N-m] Design Load

%%
%2. Choice of Belt Pitch
%parameters
alpha = 2*pi; %[rad/s] angular velocity
P = T_peak*alpha; %[Watt] Power
P_hp = P/745.7; %[hp] Watt to horsepower
one = input('Step. 2 Would you like to see Figure 1-1? y or n\n', 's');
figure1_1 = imread('figure1-1.png');
if one == 'y'
    imshow(figure1_1);
elseif one == 'n'
    fprintf('Moving On!\n');
end

%%
%3. Check belt pitch selection based on individual graphs
two = input('Step. 3 Would you like to see Figure 1-2? y or n\n', 's');
figure1_2 = imread('figure1-2.png');
if two == 'y'
    imshow(figure1_2);
elseif two == 'n'
    fprintf('Moving On!\n');
end
%%
%4. Determine speed ratio
%parameters
D_small = 22.4; %[mm] smaller pulley diameter
D_large = 22.4; %[mm] larger pulley diameter
sr = D_small/D_large; 

%%
%5. Check belt speed
%generally belt speeds up to 6500 fpm (33.02 m/s) do not require special pulleys
%parameters
pitch = 23; %[mm] pulley pitch diameter
alpha_rpm = alpha*60/(2*pi);
v = 0.0000524 * pitch * alpha_rpm; %[m/s] belt speed

%%
%6. Determine belt length
cd_initial = 80; %[mm] initial center distance based on model design
D = 23; %[mm] large pulley pitch diameter
d = 23; %[mm] large pulley pitch diameter

PL = 2*cd_initial + (1.57*(D+d))+(D-d)^2/(4*cd_initial); %[mm] belt pitch length

b = 2*PL - pi*(D+d);
CD = (b+sqrt(b^2-(8*(D-d)^2)))/8; %[mm] new center distance

%%
%7. Determine belt width
%Use SDP-SI Rated Torque Table 33 - 42 from page T-67
%For HTD and GT3 drives, torque ratings must be multiplied by the length correction factor
wm = 1.0; %width multiplier: depends on the selected belt width (top right corner); belt width = 9mm
tf = 2.89; %torque factor
lcf = 1.0; %length correction factor: depends on the belt length (PL)

RT = wm*tf*lcf; %[N-m] Rated Torque

if RT < T_peak
    fprintf('Step. 7 Does not satisfy the requirement\n');
    return
else
    fprintf('Step. 7 Does satisfy the requirement\n');
end

%%
%8. Check the number of teeth in mesh
%parameters
Nd = 36; %number of teeth on small pulley

TIM = (0.5 - ((D-d)/(6*CD)))*Nd; %teeth in mesh
RT_new = TIM*1;

if 5 <= TIM && TIM < 6
    RT_new = TIM*0.8;
elseif 4 <= TIM && TIM < 5
    RT_new = TIM*0.6;
elseif 3 <= TIM && TIM < 4
    RT_new = TIM*0.4;
elseif TIM < 3 
    fprintf('Step. 8 Redesign suggested\n');
    return
end

if RT_new < T_peak
    fprintf('Step. 8 Does not satisfy the requirement\n');
    return
else
    fprintf('Step. 8 Does satisfy the requirement\n');
end