function [fuel_frac] = initial_fuel_fraction(v_cruise_kts, R_nm, loiter_time_min,p_res, C_cruise, C_loiter, C_combat, time_combat)
nm_to_ft   = 6.0761e+03;
kts_to_fts = 1.6878;
v_cruise_fts = v_cruise_kts*kts_to_fts;
R = R_nm*nm_to_ft;
loiter_time = loiter_time_min*60;
% loiter_time
%% 0-1 Warmup and Takeoff
ff_to    =  0.9703; % Raymer Table 2.1
%% 1-2 Climb
ff_climb1 = 0.985;    
%% 2-3 Cruise
C_cruise = C_cruise/3600; %;1.45/3600;
L_D_max_est = 7;
%R  = 550*nm_to_ft;
%v_cruise_fts = 458*kts_to_fts;
ff_cruise1= exp(-(R*C_cruise)/(L_D_max_est*v_cruise_fts));
%% 3-4  loiter
%loiter_time    = 10*60; %[s] 10 min loiter reserve fuel
L_D_loiter_est = 9; % Table 2.2 Raymer
C_loiter = C_loiter/3600; % Table 2.2 Raymer
ff_loiter1 =exp(-(loiter_time)*C_loiter/(L_D_loiter_est));
%% 4-5 Climb to combat altitude
ff_climb2 = 0.985;
%% 5-6 Combat: 5min 536 kts max power
time_combat    = time_combat*60; %[s] 10 min loiter reserve fuel
L_D_combat_est = 5; % Table 2.2 Raymer
C_combat = C_combat/3600; % Engine at max power
ff_combat =exp(-(time_combat)*C_combat/(L_D_combat_est));
%% 2, 3 ,4 ,5 are repeated
ff_descent1=1.0;       % no fuel burnt 6-7
ff_cruise2=ff_cruise1; % 7-8
ff_descent2=1.0;       % 8-9 no fuel burnt
ff_loiter2=ff_loiter1; % 9 -10
%% 10 - 11 Landing and shutoff
ff_landing = 0.995;
%% Put together the legs
fuel_frac= ff_to*ff_climb1*ff_cruise1*ff_loiter1*ff_climb2*ff_combat*ff_descent1...
    *ff_cruise2*ff_descent2*ff_loiter2*ff_landing;
fuel_frac=(1+p_res/100)*1.06*(1-fuel_frac); % 10 percent reserve fuel RFP , 6% trapped
end