function [  ] = plot_cruise_climb(v_cruise_kts, h1, h2, r_cruise_nm)
%% CRUISE CLIMB (alpha, beta, rho are treated here as constants)
% Conversion factors and constants
global_constants();
% v_cruise_kts    = 458;                      % cruise velocity [kts]
v_cruise_fts    = v_cruise_kts*kts_to_fts;  % cruise velocity [ft/s]

%altitude changes as it is cruise climb
% h1              = 35400;                    % ft
% h2              = 38700;                    % ft

%range covered during cc
% r_cruise_nm     = 550;                      % nautical miles
r_cruise_ft     = r_cruise_nm*nm_to_ft;

[~,~,temp]      =  initial_fuel_fraction();
beta = temp(3); % first climb before cruise
alpha           = thrust_lapse(v_cruise_fts,(h1+h2)/2,0,'mil');

[w_s, t_w] = cruise_climb(h1,h2,v_cruise_fts,r_cruise_ft,alpha,beta,k1,k2,cd0);

draw_constraint(w_s,t_w);


end