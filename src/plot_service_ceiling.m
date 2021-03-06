function [  ] = plot_max_speed(v_kts,h,power_setting)
%% CLIMB
global_constants();
%h               = 47550;
dT              = 0;
%power_setting   = 'max';

%v_kts           = 536;
v_fts           = v_kts*kts_to_fts;                 % cruise velocity [ft/s]

k2              = 0;
[k1, cd0]       = drag_polar(h,dT,v_fts);

%beta            = 0.7;                     % assumed

[~,~,temp]      =  initial_fuel_fraction();
beta = temp(6); % first climb before cruise

alpha           = thrust_lapse(v_fts,h,dT,power_setting);

dh_dt           = 100/60; %ft/s

[w_s, t_w]      = cruise(h,v_fts,dh_dt, alpha,beta,k1,k2,cd0);

%plt = plot(w_s,t_w);
draw_constraint(w_s,t_w);
%end
end