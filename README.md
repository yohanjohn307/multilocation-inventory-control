# Multi-Location Inventory Control

MATLAB code accompanying the paper:

> **The Price of Simplicity: Analyzing Decoupled Policies for Multi-Location Inventory Control**
> Yohan John\*, Vade Shah\*, James A. Preiss, Mahnoosh Alizadeh, and Jason R. Marden
> *2025 IEEE 64th Conference on Decision and Control (CDC)*, Rio de Janeiro, Brazil.
> DOI: [10.1109/CDC57313.2025.11312244](https://doi.org/10.1109/CDC57313.2025.11312244)

## Overview

This repository reproduces the numerical results in the paper, which studies the performance cost of using simple, decoupled control policies in multi-location inventory systems with nonlinear (coupled) ordering costs. The main findings are:

- **Theorem 1** — Optimal stationary base-stock levels for individual locations are unchanged by coupling; they can be found independently.
- **Theorem 2** — For sector-bounded ordering costs `lz ≤ c(z) ≤ hz`, the worst-case cost ratio of the optimal decoupled base-stock policy over the globally optimal policy equals `h/l`.
- **Proposition 3** — The dual-balancing online algorithm applied location-by-location achieves a cost ratio of at most `2h/l`.

## Code Structure

```
Motivating Examples/    # Generates Figure 1 in the paper
Simulations/            # Generates Figure 2 in the paper
```

### Motivating Examples

Reproduces Figure 1: a 2-location problem with horizon N=2 and integer-valued states, comparing the optimal policy under linear vs. nonlinear ordering costs and showing the resulting cost increase.

| File | Description |
|------|-------------|
| `main.m` | Entry point. Configure parameters here and run to produce all plots. |
| `precompute_coupled.m` | Builds the state-action-state probability matrix (SASPM) and state-action-cost matrix (SACM) for the full 2D coupled problem. |
| `finite_horizon_dp.m` | Finite-horizon backward dynamic programming solver. Works for both 1D (single location) and 2D (two locations). |
| `exhaustive_base_stock_evaluation.m` | Evaluates every candidate decoupled base-stock policy over the coupled problem to find the best one. |
| `base_stock_selection.m` | Selects the optimal base-stock level from the exhaustive evaluation. |
| `decoupled_policy_evaluation.m` | Evaluates the cost of a decoupled policy on the coupled SASPM/SACM. |
| `order_cost.m` | Implements the ordering cost function (sector-bounded or affine, in 1D or 2D). |
| `state_cost.m` | Implements the per-location holding/backlog cost `r(x) = α max{0,x} + β max{0,−x}`. |
| `visualize.m` | Plots optimal and base-stock policy heatmaps and the cost comparison (Figure 1). |

### Simulations

Reproduces Figure 2: a 2-location problem with horizon N=20 and continuous-valued states, comparing three policies via Monte Carlo simulation under a sector-bounded ordering cost exhibiting economies of scale.

| File | Description |
|------|-------------|
| `main_sector.m` | Entry point for the sector-bounded ordering cost case (Figure 2 in the paper). |
| `main_affine.m` | Entry point for the affine ordering cost variant. |
| `precompute_coupled.m` | Builds SASPM and SACM for the full 2D coupled problem. |
| `precompute_decoupled.m` | Builds SASPM and SACM for the single-location (1D) decoupled problem. |
| `finite_horizon_dp.m` | Finite-horizon backward DP solver (1D and 2D). |
| `decoupled_policy_evaluation.m` | Evaluates a decoupled policy's cost on the coupled SASPM/SACM. |
| `dual_balancing_policy.m` | Implements the dual-balancing online algorithm (π_Δ, Section IV of the paper) for a single location using bisection to balance expected holding and backlog costs. |
| `randomized_balancing_policy.m` | Implements the randomized balancing policy for affine ordering costs (fixed + variable costs). |
| `monte_carlo_policy_evaluation.m` | Runs Monte Carlo rollouts from every initial state for all three policies: coupled DP, decoupled DP, and the online algorithm. |
| `expected_holding_cost.m` | Computes the expected holding cost over the remaining horizon for a given order quantity (used by the balancing policies). |
| `expected_backlog_cost.m` | Computes the one-step expected backlog cost for a given order quantity (used by the balancing policies). |
| `order_cost.m` | Ordering cost function (sector-bounded or affine, 1D or 2D). |
| `state_cost.m` | Per-location holding/backlog cost function. |
| `terminal_cost.m` | Terminal stage cost for the DP backward recursion. |
| `visualize.m` | Produces heatmaps of the cost ratios J_π / J_π\* for the decoupled policy and online algorithm (Figure 2). |

## Reproducing the Paper Results

### Figure 1 (Motivating Examples)

Open and run `Motivating Examples/main.m`. Key parameters match the paper:

| Parameter | Value | Description |
|-----------|-------|-------------|
| `N` | 2 | Finite horizon length |
| `dx` | 1 | State/action discretization |
| `x_left`, `x_right` | -2, 2 | Inventory level bounds |
| `alpha`, `beta` | 1, 10 | Per-unit holding/backlog costs |
| `order_flag` | `'sector'` | Ordering cost type |
| `l`, `h` | 2, 4 | Sector bounds of the ordering cost |

The nonlinear ordering cost from equation (6) in the paper is defined in `order_cost.m`.

### Figure 2 (Simulations)

Open and run `Simulations/main_sector.m`. Key parameters match the paper:

| Parameter | Value | Description |
|-----------|-------|-------------|
| `N` | 20 | Finite horizon length |
| `N_sims` | 1000 | Monte Carlo simulations per initial state |
| `dx` | 0.5 | State/action discretization |
| `x_left`, `x_right` | -2, 8 | Inventory level bounds |
| `alpha`, `beta` | 0.1, 10 | Per-unit holding/backlog costs |
| `l`, `h` | 2, 4 | Sector bounds (`h/l = 2` is the worst-case bound) |
| `x_switch` | 6 | Breakpoint of the piecewise-linear ordering cost |

The sector-bounded ordering cost from equation (15) in the paper is:

```
c(z) = 4z,       z ≤ 6
c(z) = 2z + 12,  z > 6
```

Demand is binomially distributed: `w_k ∈ {0, 0.5, 1, 1.5}` with `w_k ~ Bin(3, 0.5)`.

`visualize.m` prints the mean and max cost ratios for both the decoupled policy and online algorithm, which correspond to the values reported in Section V of the paper (mean ≈ 1.13 and 1.15; max ≈ 1.18 and 1.21, well below the worst-case bounds of 2 and 4).

## Requirements

- MATLAB (tested with R2023a or later)
- No additional toolboxes are required

## Citation

```bibtex
@inproceedings{john2025price,
  title     = {The Price of Simplicity: Analyzing Decoupled Policies for Multi-Location Inventory Control},
  author    = {John, Yohan and Shah, Vade and Preiss, James A. and Alizadeh, Mahnoosh and Marden, Jason R.},
  booktitle = {2025 IEEE 64th Conference on Decision and Control (CDC)},
  pages     = {6177--6182},
  year      = {2025},
  doi       = {10.1109/CDC57313.2025.11312244}
}
```

## Funding

This work was supported by the California Energy Commission, project #EPIC-24-012.
