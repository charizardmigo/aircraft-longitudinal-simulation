% Loads parameters, opens and runs the Simulink model

clear; clc;

% Step 1: Load parameters
run('aircraft_parameters.m');

% Step 2: Open and run the Simulink model
open_system('aircraft_simulation.slx');
sim('aircraft_simulation');