# Modelagem Matemática do Veículo - Função de Lyapunov de Controle (CLF)

## 1. Dinâmica do Veículo (Sistema ACC)

Define-se o vetor de estados do veículo controlado como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20x%20%3D%20%5B%20V_f%2C%20D%20%5D%5ET">
</div>

onde:
- $V_f$: Velocidade do veículo controlado [m/s].
- $D$: Distância relativa entre o veículo controlado e o veículo líder [m].
- $V_l$: Velocidade do veículo líder [m/s].
- $u$: Força de tração/frenagem (ou aceleração desejada) [m/s²].
- $m$: Massa do veículo [kg].
- $F_r(V_f)$: Resistência aerodinâmica (arrasto), geralmente modelada como $F_r = f_0 + f_1 V_f + f_2 V_f^2$.

A dinâmica do sistema é descrita pelas equações diferenciais ordinárias:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D_f%20%3D%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%2B%20%5Cfrac%7B1%7D%7Bm%7D%20u">
</div>
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BD%7D%20%3D%20V_l%20-%20V_f">
</div>
<p>

Reescrevendo na forma afim padrão para controle $\dot{x} = f(x) + g(x)u$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20f(x)%20%3D%20%5Cbegin%7Bbmatrix%7D%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%5C%5C%20V_l%20-%20V_f%20%5Cend%7Bbmatrix%7D%2C%20%5Cquad%20g(x)%20%3D%20%5Cbegin%7Bbmatrix%7D%20%5Cfrac%7B1%7D%7Bm%7D%20%5C%5C%200%20%5Cend%7Bbmatrix%7D">
</div>

<a href="modelandosistema.md">Ver modelagem do sistema.</a>


## 2. Função de Lyapunov de Controle (CLF) - Desempenho

O objetivo de desempenho é fazer com que a velocidade do veículo $$( V_f )$$ rastreie a velocidade desejada $$( V_d )$$. Define-se a CLF como o quadrado do erro de rastreamento:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20V(x)%20%3D%20(V_f%20-%20V_d)%5E2">
</div>

### 2.1. Derivadas de Lie da CLF

Para construir a restrição linear no QP, calculamos as derivadas de Lie:
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%3D%20%5Cnabla%20V%20%5Ccdot%20f(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%5Cright)">
</div>
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_gV%20%3D%20%5Cnabla%20V%20%5Ccdot%20g(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20%5Cfrac%7B1%7D%7Bm%7D%20%5Cright)">
</div>

### 2.2. Restrição de Estabilidade (CLF)

A condição de estabilidade exponencial é imposta pela desigualdade:
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V(x)%20%2B%20%5Cdelta">
</div>

Onde:
- $$( c_V > 0 )$$: Taxa de decaimento exponencial (quanto maior, mais rápida a resposta).
- $$( \delta \)$$: Variável de relaxação (slack), que permite sacrificar a estabilidade temporariamente para priorizar a segurança.

<a href="modelandoclf.md">Ver modelagem do CLF.</a>










