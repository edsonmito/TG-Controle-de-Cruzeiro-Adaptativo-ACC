# Modelando a Função de Barreira de Controle (CBF) para o ACC


## Objetivo da CBF

Enquanto a CLF quer levar o estado para um **ponto** específico $$( V_f = V_d )$$, a CBF quer manter o estado **dentro de uma região** segura. 
No ACC, a região segura é definida pela distância entre os carros: ela nunca pode ser negativa (colisão) nem menor que um limite seguro.

## 1: Definindo a Região Segura (O Conjunto $$( \mathcal{C} )$$)

Para aplicar a CBF, precisamos definir matematicamente o que é "seguro". Definimos o conjunto $$( \mathcal{C} )$$ (safe set) como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cmathcal%7BC%7D%20%3D%20%5C%7B%20x%20%5Cin%20%5Cmathbb%7BR%7D%5E2%20%5C%2C%20%7C%20%5C%2C%20h(x)%20%5Cgeq%200%20%5C%7D">
</div>

**A Função $$( h(x) )$$:**
A função que define a fronteira da segurança no ACC é a distância relativa descontada do tempo de reação $$\( \tau_h )$$):

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20h(x)%20%3D%20D%20-%20%5Ctau_h%20%5Ccdot%20V_f">
</div>

- Se $$( h(x) > 0 )$$: Estamos seguros (distância folgada).
- Se $$( h(x) = 0 )$$: Estamos no limite da segurança (fronteira).
- Se $$( h(x) < 0 )$$: Violamos a segurança (colisão ou distância perigosa).

## 2. A Condição de Invariância

Para garantir que o carro **nunca** saia da região segura ($$( h < 0 )$$), a teoria da CBF (baseada no Teorema de Nagumo) exige que, quando o carro estiver na fronteira ($$( h = 0 )$$), a derivada de $$( h )$$ não pode ser negativa (ou seja, não pode estar diminuindo ainda mais).

Para estender essa condição para **todo o conjunto seguro** (e não só na borda), a teoria usa a seguinte desigualdade:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bh%7D%20%2B%20%5Cgamma%20%5Ccdot%20h%20%5Cgeq%200">
</div>

**Interpretação Física:**
- Se $$( h )$$ está grande (longe do perigo), $$( \dot{h} )$$ pode ser um pouco negativo (distância diminuindo), desde que $$( \gamma h )$$ compense isso.
- Se $$( h )$$ está pequeno (perto do perigo), $$( \dot{h} )$$ **precisa ser positivo** (a distância precisa estar aumentando, ou seja, o carro está freando para abrir espaço).

## 3. Aplicando a Regra da Cadeia

Para o QP usar essa restrição, precisamos explicitar o controle $$( u )$$ em $$( \dot{h} )$$. Aplicamos a Regra da Cadeia:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bh%7D%20%3D%20%5Cfrac%7B%5Cpartial%20h%7D%7B%5Cpartial%20D%7D%20%5Ccdot%20%5Cdot%7BD%7D%20%2B%20%5Cfrac%7B%5Cpartial%20h%7D%7B%5Cpartial%20V_f%7D%20%5Ccdot%20%5Cdot%7BV%7D_f">
</div>

Substituindo as derivadas parciais de $$( h = D - \tau_h V_f )$$ e as dinâmicas $$( \dot{D} = V_l - V_f )$$ e $$( \dot{V}_f = -\frac{F_r}{m} + \frac{u}{m} )$$:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bh%7D%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)%20-%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7B1%7D%7Bm%7D%20u">
</div>

## 4. Extraindo as Derivadas de Lie da CBF ($$ L_fh $$ e $$ L_gh $$)

Para encaixar no QP, separamos o que independe do controle ( $$ L_fh $$ ) e o que multiplica $$( u )$$ ( $$ L_gh $$ ).

**1. Derivada de Lie em relação a f (parte natural da dinâmica):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)">
</div>

**2. Derivada de Lie em relação a g (o multiplicador do controle):**
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_gh%20%3D%20-%5Ctau_h">
</div>

## 5. A Restrição da CBF no QP (A Desigualdade ($$ \geq ) $$)

Substituindo $$( \dot{h} = L_fh + L_gh \cdot u )$$ na condição de invariância, obtemos a restrição final que será usada no QP:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h%20%5Cgeq%200">
</div>

**Perceba a diferença fundamental da CLF:**
- **CLF**: $$( L_fV + L_gV \cdot u \leq -c_V V + \delta )$$ (queremos ser **menores ou iguais** a zero para estabilidade).
- **CBF**: $$( L_fh + L_gh \cdot u + \gamma h \geq 0 )$$ (queremos ser **maiores ou iguais** a zero para segurança).

---

## 6. O Parâmetro $$( \gamma )$$ (O "Gatilho" da Segurança)

Assim como $$( c_V )$$ define a agressividade da CLF, $$( \gamma )$$ define a "sensibilidade" da CBF.

- **$$( \gamma )$$ alto**: O carro começa a frear **muito antes** de chegar perto do carro da frente. A segurança é priorizada, mas o carro pode ser excessivamente cauteloso, irritando os motoristas de trás.
- **$$( \gamma )$$ baixo**: O carro só freia no **último segundo** possível. A segurança ainda é garantida, mas a frenagem será muito brusca (desconfortável e perigosa para o carro de trás).
- **Valor típico na literatura**: Geralmente entre 1 e 5, ajustado para equilibrar conforto e segurança.

---

## Passo 7: Conexão Direta com o seu Código (`LIE_2026.m`)

Toda essa dedução matemática está implementada no seu script. Veja a correspondência:

| Matemática (Teoria) | Código (MATLAB) | O que faz |
| :--- | :--- | :--- |
| \( h = D - \tau_h V_f \) | `hacc = xr - Td*Vf` | Define a função de barreira. |
| \( L_fh \) | `Lfhacc = transpose(gradient(hacc,[Vf;xr]))*f` | Calcula a derivada independente do controle. |
| \( L_gh \) | `Lghacc = transpose(gradient(hacc,[Vf;xr]))*g` | Calcula o coeficiente que multiplica o controle \( u \). |

---

## Resumo para o seu TCC (Como escrever esta análise)

> "A CBF foi definida como \( h = D - \tau_h V_f \), representando a distância de segurança ajustada pelo tempo de reação do motorista. A condição de invariância do conjunto seguro, \( \dot{h} + \gamma h \geq 0 \), garante que o veículo nunca viole a distância mínima em relação ao líder. Separando a dinâmica em \( L_fh \) e \( L_gh \), obteve-se a restrição linear \( L_fh + L_gh u + \gamma h \geq 0 \). 
> 
> Enquanto a CLF impõe uma desigualdade de 'menor ou igual' (\( \leq \)) para garantir a convergência da velocidade, a CBF impõe uma desigualdade de 'maior ou igual' (\( \geq \)) para garantir a manutenção da distância. O QP resolve este conflito priorizando a restrição da CBF (rígida), relaxando a CLF (\( \delta \)) quando necessário."

---

**Agora você tem os dois lados da mesma moeda:** 
- **CLF**: puxa o carro para frente (velocidade). 
- **CBF**: segura o carro para trás (distância). 
O **QP** (com a ajuda do \(\delta\) e do \(p_\delta\)) é o árbitro que decide, a cada instante, qual dos dois vai vencer a queda de braço!

Quando você for escrever o TCC, essa estrutura lado a lado (CLF vs CBF) impressiona muito, porque mostra que você domina o duelo teórico por trás do método. 🚀

Quer agora dar o próximo passo e ver como essas duas restrições se encontram dentro do **bloco do QP** (e como o algoritmo de Hildreth, do seu `QPhild.m`, resolve essa briga na prática)?
