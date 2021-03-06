function [  ] = plot_climb(v_cruise_kts, h, dT, dh_dt, power_setting)
%% CLIMB

global_constants();

%%v_cruise_kts    = 458;                      % cruise velocity [kts]
v_cruise_fts    = v_cruise_kts*kts_to_fts;  % cruise velocity [ft/s]

%altitude changes as it is cruise climb
%%h               = 35400;                    % ft
%%dh_dt           = 90;                       % ft/s
%dT              = 0;
%[fuel_frac,wni_wn, beta] = initial_fuel_fraction();
% beta            = [fuel_frac,wni_wn, beta] = initial_fuel_fraction%0.98;                     % assumed

[~,~,temp]      =  initial_fuel_fraction();
if (h< 40000) 
    beta = temp(2); % first climb before cruise
else 
    beta = temp(5); % second climb  after cruise forward
end

alpha           = thrust_lapse(v_cruise_fts,h,dT,power_setting);
[k1, cd0]       = drag_polar(h,dT,v_cruise_fts);
k2              = 0 ;

[w_s, t_w]      = climb(h,v_cruise_fts,dh_dt,alpha,beta,k1,k2,cd0);

draw_constraint(w_s,t_w);

%plot(w_s,t_w,'linewidth',2);
end