# Albedo–Tb Relationship Model

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
