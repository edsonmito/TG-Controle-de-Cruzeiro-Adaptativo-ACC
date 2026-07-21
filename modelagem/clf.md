# Modelagem Matemática do Veículo - Função de Lyapunov de Controle (CLF) para ACC

O objetivo é mostrar como saímos do "erro de velocidade" e chegamos na restrição matemática que é implementada dentro do QP (Programação Quadrática). No contexto do ACC, o motorista estabelece uma velocidade desejada $V_d$ (ex: 80 km/h). O trabalho da CLF é garantir que a velocidade real do veículo $V_f$ **convirja** para essa velocidade desejada $V_d$ de forma estável e suave, a menos que a segurança (CBF) impeça.

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

## 2. Definindo o Erro de Rastreamento

O primeiro passo para construir qualquer função de Lyapunov para rastreamento é definir a variável que queremos levar a zero. Definimos o erro de velocidade como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20e%20%3D%20V_f%20-%20V_d">
</div>

O objetivo de desempenho é fazer com que a velocidade do veículo $V_f$ rastreie a velocidade desejada $V_d$. Define-se a CLF como o quadrado do erro de rastreamento:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20V(x)%20%3D%20(V_f%20-%20V_d)%5E2">
</div>

<p>
Se conseguirmos fazer com que $e \to 0$, o carro atingiu a velocidade desejada.

## 3. A Função de Lyapunov Candidata 

A função de Lyapunov mais clássica e intuitiva para erros de rastreamento é o **quadrado do erro**. Ela é sempre positiva (exceto na origem) e mede a "energia" do erro.

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20V(x)%20%3D%20e%5E2%20%3D%20(V_f%20-%20V_d)%5E2">
</div>

**Verificação dos requisitos matemáticos:**
1. **Definida Positiva**: 
   - $V(0) = 0$ (quando $V_f = V_d$).
   - $V(x) > 0$ para todo $V_f \neq V_d$.
2. **Radialmente Ilimitada**: 
   - Quando $V_f \to \infty$, $V(x) \to \infty$. Isso garante estabilidade global (não importa se o carro está a 10 m/s ou 100 m/s, a função funciona).


## 4. Calculando a Derivada Temporal ($\dot{V}$)

Aplicando a regra da cadeia para derivar $V$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D%20%3D%20%5Cfrac%7Bd%7D%7Bdt%7D(e%5E2)%20%3D%202%20%5Ccdot%20e%20%5Ccdot%20%5Cfrac%7Bde%7D%7Bdt%7D">
</div>
<p>
Derivando o erro $e = V_f - V_d$ em relação ao tempo.
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cfrac%7Bde%7D%7Bdt%7D%20%3D%20%5Cdot%7BV%7D_f%20-%20%5Cdot%7BV%7D_d%20%3D%20%5Cdot%7BV%7D_f%20-%200%20%3D%20%5Cdot%7BV%7D_f">
</div>
<p>
Lembrando da dinâmica do veículo (vinda da modelagem anterior):
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D_f%20%3D%20-%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20%5Cfrac%7B1%7D%7Bm%7D%20u">
</div>
<p>
Substituindo $\dot{V}_f$ pela equação do veículo, temos a derivada completa expandida:
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20-%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20%5Cfrac%7B1%7D%7Bm%7D%20u%20%5Cright)">
</div>


## 5. Extraindo as Derivadas de Lie ($L_fV$ e $L_gV$)

Para que o controlador (QP) consiga usar essa equação, precisamos separar a parte que **não depende** do controle $u$ (chamada de $L_fV$) e a parte que **multiplica** o controle $u$ (chamada de $L_gV$).

Expandindo a equação anterior:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D%20%3D%20%5Cunderbrace%7B%5Cleft(%20-%5Cfrac%7B2(V_f%20-%20V_d)F_r%7D%7Bm%7D%20%5Cright)%7D_%7BL_fV%7D%20%2B%20%5Cunderbrace%7B%5Cleft(%20%5Cfrac%7B2(V_f%20-%20V_d)%7D%7Bm%7D%20%5Cright)%7D_%7BL_gV%7D%20%5Ccdot%20u">
</div>

Portanto, as duas partes são:

**1. Derivada de Lie em relação a f (arrasto e cinemática):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%3D%20-%5Cfrac%7B2(V_f%20-%20V_d)%20%5Ccdot%20F_r%7D%7Bm%7D">
</div>

**2. Derivada de Lie em relação a g (o multiplicador do controle):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_gV%20%3D%20%5Cfrac%7B2(V_f%20-%20V_d)%7D%7Bm%7D">
</div>








---



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










