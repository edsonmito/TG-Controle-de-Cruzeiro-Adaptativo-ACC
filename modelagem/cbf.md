# Modelagem Matemática do Veículo - Função de Barreira de Controle (CBF) para o ACC

Enquanto a CLF quer levar o estado para um **ponto** específico $$( V_f = V_d )$$, a CBF quer manter o estado **dentro de uma região** segura. 
No ACC, a região segura é definida pela distância entre os carros: ela nunca pode ser negativa (colisão) nem menor que um limite seguro.

## 1. Função de Barreira de Controle (CBF) - Segurança

Para aplicar a CBF, precisamos definir matematicamente o que é "seguro". Definimos o conjunto $\mathcal{C}$$ (safe set) como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cmathcal%7BC%7D%20%3D%20%5C%7B%20x%20%5Cin%20%5Cmathbb%7BR%7D%5E2%20%5C%2C%20%7C%20%5C%2C%20h(x)%20%5Cgeq%200%20%5C%7D">
</div>

A função **$h(x)$** que define a fronteira da segurança no ACC é a distância relativa (distância mínima em relação ao veículo líder) descontada do tempo de reação $\tau_h$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20h(x)%20%3D%20D%20-%20%5Ctau_h%20%5Ccdot%20V_f">
</div>

Onde:
- $$( \tau_h > 0 )$$: Tempo de headway desejado (ex: 1.8 segundos). Garante que a distância seja proporcional à velocidade.
- Se $(h(x) > 0)$: Estamos seguros (distância folgada).
- Se $(h(x) = 0)$: Estamos no limite da segurança (fronteira).
- Se $(h(x) < 0)$: Violamos a segurança (colisão ou distância perigosa).



## 2. A Condição de Invariância do Conjunto Seguro

Para garantir que o carro **nunca** saia da região segura $( h < 0 )$, a teoria da CBF (baseada no Teorema de Nagumo) exige que, quando o carro estiver na fronteira $( h = 0 )$, a derivada de $( h )$ não pode ser negativa (ou seja, não pode estar diminuindo ainda mais).

Vale ressaltar que se você só olhar para $( h )$ como critério de segurança, quando $( h = 0 )$ você já colidiu. Mas se você olhar para $( \dot{h} )$, você pode calcular a frenagem necessária para **impedir** que $( h )$ chegue a zero no futuro.

Para estender essa condição para **todo o conjunto seguro** (e não só na borda), a teoria usa a seguinte desigualdade:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7Bh%7D%20%2B%20%5Cgamma%20%5Ccdot%20h%20%5Cgeq%200">
</div>

Onde $\gamma$ é a taxa de decaimento máxima permitida, e $h$ a função de barreira. 

**Interpretação Física:**
- Se $$( h )$$ está grande (longe do perigo), $$( \dot{h} )$$ pode ser um pouco negativo (distância diminuindo), desde que $$( \gamma h )$$ compense isso.
- Se $$( h )$$ está pequeno (perto do perigo), $$( \dot{h} )$$ **precisa ser positivo** (a distância precisa estar aumentando, ou seja, o carro está freando para abrir espaço).

## 3. Aplicando a Regra da Cadeia

Para o QP usar essa restrição, precisamos explicitar o controle $$( u )$$ em $$( \dot{h} )$$. Aplicamos a Regra da Cadeia:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7Bh%7D%20%3D%20%5Cfrac%7B%5Cpartial%20h%7D%7B%5Cpartial%20D%7D%20%5Ccdot%20%5Cdot%7BD%7D%20%2B%20%5Cfrac%7B%5Cpartial%20h%7D%7B%5Cpartial%20V_f%7D%20%5Ccdot%20%5Cdot%7BV%7D_f">
</div>

Substituindo as derivadas parciais de $$( h = D - \tau_h V_f )$$ e as dinâmicas $$( \dot{D} = V_l - V_f )$$ e $$( \dot{V}_f = -\frac{F_r}{m} + \frac{u}{m} )$$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cdot%7Bh%7D%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)%20-%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7B1%7D%7Bm%7D%20u">
</div>

## 4. Extraindo as Derivadas de Lie da CBF ($L_fh$ e $L_gh$)


Derivadas de Lie da CBF

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fh%20%3D%20%5Cnabla%20h%20%5Ccdot%20f(x)%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)">
</div>
<p>
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_gh%20%3D%20%5Cnabla%20h%20%5Ccdot%20g(x)%20%3D%20-%5Ctau_h">
</div>
<p>
*(Nota: Estes cálculos são exatamente os realizados pelo script `LIE_2026.m` quando ele executa `Lfhacc` e `Lghacc`).*




Para encaixar no QP, separamos o que independe do controle ( $L_fh$ ) e o que multiplica $( u )$ ( $L_gh$ ).

**1. Derivada de Lie em relação a f (parte natural da dinâmica):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fh%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)">
</div>

**2. Derivada de Lie em relação a g (o multiplicador do controle):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_gh%20%3D%20-%5Ctau_h">
</div>




---



### 1.2. Restrição de Segurança (CBF)

A condição para que a distância nunca se torne negativa (invariância do conjunto seguro) é:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h(x)%20%5Cgeq%200">
</div>
<p>
Onde $$( \gamma > 0 )$$: Parâmetro que ajusta a "agressividade" da barreira. Quanto maior, mais cedo o sistema começa a frear para evitar a violação da segurança.

<a href="modelandocbf.md">Ver modelagem do CBF.</a>

a CLF puxa o sistema para $$( V_d )$$, a CBF o segura para que $$( D )$$ não caia abaixo de $$( \tau_h V_f )$$, criando um equilíbrio dinâmico entre desempenho e segurança.










