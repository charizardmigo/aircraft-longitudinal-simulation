% --- Aircraft (from Fig. 2) ---
m_aircraft = 3.9;      % [kg] Total mass (3900 g)
CdA = 0.0;             % [m^2] (Placeholder for advanced drag)

% --- Battery (from Fig. 2) ---
V_nom_cell = 3.7;      % [V] Nominal LiPo cell voltage
Ns = 5;                % [-] 5s battery configuration
V_batt_nom = Ns*V_nom_cell;  % [V] Total nominal voltage (18.5V)
Q_Ah = 5.0;            % [Ah] 5000 mAh capacity
Q_C = Q_Ah*3600;       % [C] Capacity in Coulombs

% --- Physics Constants Tuned for 20-28 m/s Cruise) ---
% These values represent the Parameter Fitting requested 
k_thrust = 0.05;       % [N/(rad/s)] Thrust coefficient
c_visc = 0.45;         % [N/(m/s)] Aerodynamic damping

% --- Simulation Timing (from Fig. 5) ---
t_end = 600;           % [s] Total simulation time
thr_t = [0 40 60 600];           % [s] Time breakpoints
thr_u = [1.0 0.5 0.35 0.35];     % [-] Throttle levels