function [  ] = plot_landing(h, dT,s_l,  h_obs, c_l_max_landing)
%% Landing performance

global_constants();

% standard atmosphere
% h               = 0;                        % runway from sealevel
T               = 90;                       % F
T_std           = 59;                       % F
[rho,a,~,~,~,~] = stdatmo(h,dT,'US');
g0              = 32.17;                    % ft/s

alpha           = 0.0;
%beta            = 0.78;
[~,~,temp]      =  initial_fuel_fraction();
beta = temp(11) % second climb  after cruise forward

mu_b            = 0.18;
time_fr         = 3.0;
% h_obs           = 50;

k_td            = 1.15;
k_obs           = 1.15;
%s_l =5000;

% lift-drag polar
%c_l_max_landing = 1.0;                     % Mattingly page 35  1.6 with leading edge slat
c_l_max_to      = 0.8*c_l_max_landing;     % Mattingly page 30

c_l_to          = 0.8*c_l_max_to;           % Mattingly page 35
c_l_landing     = 0.8*c_l_max_landing;      % Mattingly page 35

% Mattingly equation for takeoff
t_w             = thrust_loading();

denom           = (-alpha*t_w/beta +mu_b)*c_l_max_landing/k_td^2;
%c_d = 0.014+0.18*(0.8*1/1.15/1.15)^2

c_dr            = 0 ;
c_d             = cd0 + k1*(c_l_landing)^2;

zeta_l          = c_d + c_dr -mu_b*c_l_landing;

A               = (beta./rho*g0*zeta_l).*log( 1+  zeta_l./denom);
B               = time_fr * k_td*( (2*beta) / (rho*c_l_max_landing) )^0.5;


s_a             = 2*c_l_landing/(g0*(c_d+c_dr))* (k_obs^2 - k_td^2)/(k_obs^2 + k_td^2) + c_l_max_landing * 2 *h_obs/((c_d+c_dr)*(k_obs^2 + k_td^2) );
s_l             = s_l-s_a;         % subtract the approach distance from total distance for rolling and trans

C               = s_l;

%A               = (k_to .*beta).^2./(rho.*g0.*c_l_max_to.*alpha*t_w);
%B               = time_rot * k_to*( (2*beta) / (rho*c_l_max_to) )^0.5;
%C               = s_l;

w_s             = ( (-B+(B.^2+4.*A.*C).^0.5) ./ (2.*A) ).^2;
draw_constraint(w_s,t_w);
%plot(w_s,t_w)

end
%%