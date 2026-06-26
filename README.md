# Longitudinal Flight Dynamics Simulation (3-Metre Glider)

A MATLAB/Simulink digital twin of the longitudinal flight dynamics of a 3-metre RC glider, modelling the electromechanical coupling between a 5s LiPo battery, a BLDC drivetrain, and the aircraft's translational motion under a multi-phase throttle profile.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [System Architecture](#2-system-architecture)
3. [Model Parameters](#3-model-parameters)
4. [Repository Structure](#4-repository-structure)
5. [Requirements](#5-requirements)
6. [How to Run](#6-how-to-run)
7. [Results](#7-results)
8. [Known Limitations](#8-known-limitations)
9. [Author](#9-author)
10. [Project Context](#10-project-context)
11. [License](#11-license)

---

## 1. Project Overview

This project implements a Lumped Parameter Model of a 3-metre glider's longitudinal flight dynamics using MATLAB/Simulink and Simscape. The simulation integrates three physical domains into a single coupled model:

- **Electrical domain:** 5s LiPo battery and ESC modelled as a controlled voltage source
- **Mechanical rotational domain:** BLDC motor and propeller aerodynamic load
- **Mechanical translational domain:** 1D thrust-to-drag force balance on the airframe

The model reproduces a realistic 10-minute flight mission profile, predicting aircraft speed and battery current consumption across three throttle phases. Parameter fitting of the aerodynamic constants (`k_thrust`, `c_visc`) was performed manually to match the expected cruise velocity of a 3.9 kg glider (20–28 m/s).

---

## 2. System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ELECTRICAL DOMAIN                       │
│     5s LiPo Battery + ESC → Controlled Voltage Source       │
│              Throttle signal (0–1) → 0–18.5 V               │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│               MECHANICAL ROTATIONAL DOMAIN                  │
│         BLDC Motor (D-Power AL42-07 equivalent)             │
│       Torque → Shaft speed (ω) via rotational damper        │
└─────────────────────────────┬───────────────────────────────┘
                              │  F_thrust = k_thrust × ω
┌─────────────────────────────▼───────────────────────────────┐
│              MECHANICAL TRANSLATIONAL DOMAIN                │
│         F_net = F_thrust − F_drag   (F_drag = c_visc × v)   │
│              a = F_net / m_aircraft  →  v(t)                │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Model Parameters

### 3.1 Aircraft and Battery

| Parameter | Value | Unit | Source |
|---|---|---|---|
| Total mass | 3.9 | kg | Task specification |
| Battery voltage | 18.5 | V | 5s LiPo (5 × 3.7 V) |
| Battery capacity | 5.0 | Ah | Task specification |

### 3.2 Drivetrain and Aerodynamics

| Parameter | Symbol | Value | Unit | Description |
|---|---|---|---|---|
| Motor resistance | R | 0.05 | Ω | Low-resistance outrunner (D-Power AL42-07) |
| Thrust coefficient | k_thrust | 0.05 | N/(rad/s) | Fitted to match 20–28 m/s cruise |
| Aerodynamic damping | c_visc | 0.45 | N/(m/s) | Fitted viscous drag coefficient |

### 3.3 Throttle Profile (Load Scheme)

| Phase | Time | Throttle | Description |
|---|---|---|---|
| Takeoff / Climb | 0 – 40 s | 100% | Full power acceleration |
| Transition | 40 – 60 s | 50% | Power reduction, deceleration |
| Cruise | 60 – 600 s | 35% | Steady horizontal flight |

---

## 4. Repository Structure

```
aircraft-longitudinal-simulation/
│
├── aircraft_simulation.slx     # Simulink/Simscape model
├── aircraft_parameters.m       # All model parameters (single source of truth)
├── run_project.m               # Entry point: loads parameters and runs simulation
├── LICENSE
└── README.md
```

---

## 5. Requirements

| Tool | Version / Notes |
|---|---|
| MATLAB | R2023b or later recommended |
| Simulink | Required |
| Simscape | Required (Multibody not needed) |
| Simscape Electrical | Required for motor and battery blocks |

> **Note:** No additional toolboxes beyond Simscape and Simscape Electrical are required to run this model.

---

## 6. How to Run

1. Open MATLAB and navigate to the project folder.
2. Run the entry-point script:

```matlab
run('run_project.m')
```

This will:
- Load all parameters from `aircraft_parameters.m` into the MATLAB workspace
- Open `aircraft_simulation.slx`
- Run the simulation automatically

3. Observe the results in the Simulink Scopes:
   - **Throttle Input Profile** — staircase command signal
   - **Battery Current** — electrical load over the 10-minute mission
   - **Aircraft Speed** — velocity step response and cruise convergence

> **Tip:** To modify the throttle profile or aerodynamic constants, edit `aircraft_parameters.m` and re-run `run_project.m`. Do not hardcode values directly in the Simulink model.

---

## 7. Results

| Phase | Steady-State Speed | Battery Current |
|---|---|---|
| 100% Throttle (0–40 s) | ~28 m/s | ~360 A |
| 50% Throttle (40–60 s) | ~18 m/s | ~180 A |
| 35% Throttle (60–600 s) | ~10 m/s | ~80 A |

Key observations:
- The velocity response follows a **first-order exponential** profile, consistent with a lumped mass-damper system (time constant τ = m / c_visc ≈ 8.7 s)
- Battery current responds instantaneously to throttle steps, confirming that the electrical time constant is negligible compared to the mechanical time constant
- Steady-state cruise velocity at 35% throttle converges stably, validating the parameter fitting of `k_thrust` and `c_visc`

---

## 8. Known Limitations

- **Linear drag model:** Real aerodynamic drag scales with v². A quadratic model would improve accuracy at higher speeds.
- **Constant altitude assumption:** Lift and weight are assumed balanced. Climb and descent dynamics are not modelled.
- **Ideal battery:** Voltage sag and capacity depletion over the 600-second mission are not accounted for.
- **High peak current:** The ~360 A peak at full throttle is a theoretical maximum of the lumped model. A real ESC would apply current limiting.

---

## 9. Author

**Priestley Fomeche Njukang**  
Elektro- und Informationstechnik (Electrical and Computer Engineering)  
Hochschule Anhalt (Anhalt University of Applied Sciences)

📧 **Email:** fomechepriestly7@gmail.com  
🔗 **LinkedIn:** [Priestley Fomeche](https://linkedin.com/in/priestley-fomeche)  
💻 **GitHub:** [@charizardmigo](https://github.com/charizardmigo)

---       

## 10. Project Context

**Course:** Mechatronics  
**Institution:** Hochschule Anhalt, Department of Electrical, Mechanical and Industrial Engineering  
**Date:** March 2026  
**Supervisors:** Prof. Dr. Marc Enzmann | Prof. Dr. Klaus Günzel

**Skills Demonstrated:**
- Lumped parameter modelling of multi-domain physical systems
- MATLAB/Simulink and Simscape modelling
- Electromechanical system integration (electrical, rotational, translational)
- Parameter identification and manual fitting
- Throttle profile design and transient response analysis
- Technical documentation

---

## 11. License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

**⭐If you find this project useful, please consider giving it a star!**                                                      