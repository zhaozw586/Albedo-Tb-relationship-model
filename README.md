# Albedo–Tb Relationship Model (Arctic sea ice)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15307663.svg)](https://doi.org/10.5281/zenodo.15307663)
**Public dataset:** 
**Gap-Free Arctic Sea-Ice Albedo Dataset (2000–2024; Daily, May–September)**  
➡ Dataset & model-generated derivatives on Zenodo: https://doi.org/10.5281/zenodo.15307663


This repo provides:
1) **Trained MATLAB models** (in `model/`, pre-trained models: overall model (Net.mat) and monthly models (e.g., Maynet.mat, Junnet.mat), tracked by **Git LFS**)
2) **Training script** (`train_month.m`)
3) **Inference scripts** (`inference.m`) to estimate albedo from new passive microwave/aux inputs.

## Requirements
- MATLAB (tested on R2020b)  
- OS: Windows 10/11

## Input features 
Passive microwave brightness temperature (Tb, DMSP SSM/I-SSMIS daily polar gridded brightness temperatures (Version 6)) from 19.3 GHz (H/V polarizations), 22.2 GHz (V polarization), and 37.0 GHz (H/V polarizations), Tb differences between channels, polarization ratios, gradient ratios, SIC, longitude, latitude, solar zenith angle, and temporal encoding of the day-of-year (DOY). 

## Output
Predicted shortwave BSA for Arctic sea ice.
