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

<a href="teoria/funcaodiretalyapunov.md">Ver Função Direta de Lyapunov</a><br>
<a href="teoria/funcaoindiretalyapunov.md">Ver Função Direta de Lyapunov</a><br>
<a href="teoria/lyapunovparaacc.md">Função de Lyapunov para ACC</a>

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

Para construir a restrição linear no QP, calculamos as derivadas de Lie:
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%3D%20%5Cnabla%20V%20%5Ccdot%20f(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%5Cright)">
</div>
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_gV%20%3D%20%5Cnabla%20V%20%5Ccdot%20g(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20%5Cfrac%7B1%7D%7Bm%7D%20%5Cright)">
</div>


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




## 6. A Condição de Estabilidade Exponencial (A Desigualdade da CLF)

Para garantir que o erro de velocidade caia exponencialmente para zero (ou seja, $e^{-\alpha t}$), a teoria de Lyapunov exige que a derivada de $V$ seja negativa e proporcional à própria $V$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7BV%7D%20%5Cleq%20-c_V%20%5Ccdot%20V">
</div>

Substituindo $\dot{V}$ pela forma $L_fV + L_gV \cdot u$, obtemos a **restrição linear** que será usada no QP:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V">
</div>

Onde $c_V > 0$ é a **taxa de convergência (ou taxa de decaimento exponencial)**. Quanto maior o $c_V$, mais rápido o carro acelera/freia para atingir a velocidade desejada, e quanto menor o $c_V$, a aceleração é mais lenta. A taxa de convergência deve ser configurada para encontrar um valor intermediário. 

$\delta \$: Variável de relaxação (slack), que permite sacrificar a estabilidade temporariamente para priorizar a segurança.



## 7. A Relaxação ($\delta$) e sua relação com a segurança

A condição de estabilidade exponencial é imposta pela desigualdade:
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V(x)%20%2B%20%5Cdelta">
</div>

Se a restrição acima for muito rígida, pode não existir solução quando a segurança (CBF) exigir frenagem forte. Para resolver isso, a teoria introduz a **variável de relaxação ($\delta$)**

**Interpretação Física:**
- Se $\delta = 0$: A CLF é respeitada. O carro converge exponencialmente para $V_d$.
- Se $\delta > 0$: A CLF é relaxada. O carro **prioriza a segurança** (freia) em vez de seguir $V_d$. O QP minimiza $\delta^2$ com um peso altíssimo para que isso só aconteça em emergências.


## 8. Conexão Direta com o seu Código MATLAB (`LIE_2026.m`)

Toda essa dedução matemática está implementada no seu script de Lie. Abra o arquivo `LIE_2026.m` e veja a correspondência:

| Matemática (Teoria) | Código (MATLAB) | O que faz |
| :--- | :--- | :--- |
| $V = (V_f - V_d)^2$ | `Vacc = (Vf-Vd)^2` | Define a função de Lyapunov. |
| $L_fV$ | `LfVacc = transpose(gradient(Vacc,[Vf,xr]))*f` | Calcula a derivada independente do controle. |
| $L_gV$ | `LgVacc = transpose(gradient(Vacc,[Vf,xr]))*g` | Calcula o coeficiente que multiplica o controle $u$. |


## 9. Conclusão

A Função de Lyapunov de Controle (CLF) foi definida como o quadrado do erro de velocidade, $V(e) = (V_f - V_d)^2$, assegurando que a função seja positiva definida e radialmente ilimitada. Calculando a derivada temporal e separando-a em $L_fV$ e $L_gV$, obteve-se a condição de estabilidade exponencial $L_fV + L_gV u \le -c_V V$. Para integrar esta condição ao QP e permitir a priorização da segurança, a restrição foi relaxada pela variável $\delta$, resultando na forma final $L_fV + L_gV u \le -c_V V + \delta$. Portanto, a CLF atua como um 'desejo' de desempenho que é temporariamente suspenso (via $\delta$) sempre que a segurança (CBF) está em risco.

A relaxação $\delta$ permite que a derivada da CLF seja temporariamente positiva, o que, à primeira vista, violaria as condições clássicas do Teorema Direto de Lyapunov. Entretanto, essa violação é estritamente temporária e ocorre apenas quando a restrição de segurança (CBF) está ativa. A teoria de estabilidade entrada-estado (ISS) garante que, enquanto 
$\delta$ for limitado e penalizado na função custo do QP, o erro de velocidade permanecerá uniformemente limitado. Assim que a situação de risco cessa, o QP força $\delta$ a zero, restaurando a condição de estabilidade exponencial <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V">
​ e garantindo a convergência da velocidade para o valor desejado.



