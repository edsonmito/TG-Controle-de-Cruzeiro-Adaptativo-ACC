close all
clear all
clc

% Modelo ACC
syms m Vf Vd xr Vl Fr Td Ds
x = [Vf;xr]
f = [-Fr/m;Vl-Vf]
g = [1;0]

hacc = xr - Td*Vf

Vacc = (Vf-Vd)^2

Lfhacc = transpose(gradient(hacc,[Vf;xr]))*f
LfLfhacc = transpose(gradient(Lfhacc,[Vf;xr]))*f
Lghacc = transpose(gradient(hacc,[Vf;xr]))*g
LgLfhacc = transpose(gradient(Lfhacc,[Vf;xr]))*g

LfVacc = transpose(gradient(Vacc,[Vf,xr]))*f
LgVacc = transpose(gradient(Vacc,[Vf,xr]))*g