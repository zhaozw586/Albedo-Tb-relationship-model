# Albedo–Tb Relationship Model

This repo provides:
1) **Trained MATLAB models** (in `model/`, tracked by **Git LFS**)
2) **Train scripts** (`train_month.m`)
3) **Inference scripts** (`inference.m`) to estimate albedo from new passive microwave/aux inputs.

## 1. Contents
.
├─ model/ # pre-trained models: overall model (Net.mat) and monthly models (e.g., Maynet.mat, Junnet.mat)
├─ inference.m # run inference on new data
├─ train_month.m # training per month (Monthly models)
├─ .gitattributes # LFS tracking for .mat
└─ README.md

## 2. Requirements
- MATLAB (tested on R2020b)  
- OS: Windows 10/11

## 3. **Public Dataset** 
Gap-Free Arctic Sea Ice Albedo Dataset (2000–2024; Daily, May–September) 
➡ Download & Public datasets generated based on the model on Zenodo: https://doi.org/10.5281/zenodo.15307663
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15307663.svg)](https://doi.org/10.5281/zenodo.15307663)
