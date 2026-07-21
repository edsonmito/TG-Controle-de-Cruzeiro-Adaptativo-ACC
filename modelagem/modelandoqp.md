# Modelando QP

O QP recebe as duas restrições (CLF e CBF) e calcula o controle $$( u )$$ que satisfaz ambas da melhor forma possível.

## 1. O que o QP precisa decidir?

A cada instante de tempo, o QP recebe:

- **O desejo da CLF**: Acelerar para chegar em $$( V_d )$$.
- **A obrigação da CBF**: Frear para não colidir.

O QP deve encontrar um valor para **$$( u )$$ (aceleração)** e para **$$( \delta )$$ (relaxação)** que minimize uma função de custo, respeitando as duas restrições.

## 2. As Variáveis do QP

O QP resolve um problema de otimização com duas variáveis de decisão:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20z%20%3D%20%5Cbegin%7Bbmatrix%7D%20u%20%5C%5C%20%5Cdelta%20%5Cend%7Bbmatrix%7D">
</div>

Onde:
- **$$( u )$$** = Aceleração/frenagem comandada (m/s²).
- **$$( \delta )$$** = Relaxação da CLF (adimensional). Quanto maior, mais a CLF é "ignorada".

## 3. A Função de Custo (O que o QP minimiza?)

O QP minimiza a seguinte função custo quadrática:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20J%20%3D%20%5Cfrac%7B1%7D%7B2%7D%20u%5E2%20%2B%20p_%5Cdelta%20%5Ccdot%20%5Cdelta%5E2">
</div>

**Interpretação:**
- **$$( \frac{1}{2} u^2 )$$**: Penaliza acelerações/frenagens muito fortes (conforto e eficiência).
- **$$( p_\delta \delta^2 )$$**: Penaliza a relaxação da CLF. O peso $$( p_\delta )$$ é altíssimo (ex: $$( 10^5 )$$), então o QP **odeia** usar $$( \delta > 0 )$$. Só usa em emergências.

## 4. As Restrições (As "Regras do Jogo")

O QP deve obedecer a duas restrições lineares (afins em $$( u )$$).

### Restrição 1: A CLF (Desempenho - Flexível)

Como vimos, a CLF exige:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V%20%2B%20%5Cdelta">
</div>

Reescrevendo para encaixar no formato \( A z \leq b \):

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_gV%20%5Ccdot%20u%20-%20%5Cdelta%20%5Cleq%20-L_fV%20-%20c_V%20V">
</div>

**Linha da CLF na matriz $$( A )$$:** $$( [L_gV, \ -1] )$$

### Restrição 2: A CBF (Segurança - Rígida)

A CBF exige:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h%20%5Cgeq%200">
</div>

Reescrevendo para encaixar no formato $$( A z \leq b )$$ (multiplicando por -1 para inverter a desigualdade):

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20-L_gh%20%5Ccdot%20u%20%5Cleq%20L_fh%20%2B%20%5Cgamma%20h">
</div>

**Linha da CBF na matriz $$( A )$$:** $$( [-L_gh, \ 0] )$$

## 5. O Sistema Completo (Forma Matricial $$( Az \leq b )$$)

Juntando tudo, o QP resolve o seguinte problema a cada iteração:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cmin_%7Bu%2C%20%5Cdelta%7D%20%5Cfrac%7B1%7D%7B2%7D%20u%5E2%20%2B%20p_%5Cdelta%20%5Cdelta%5E2">
</div>

Sujeito a:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cbegin%7Bbmatrix%7D%20L_gV%20%26%20-1%20%5C%5C%20-L_gh%20%26%200%20%5Cend%7Bbmatrix%7D%20%5Cbegin%7Bbmatrix%7D%20u%20%5C%5C%20%5Cdelta%20%5Cend%7Bbmatrix%7D%20%5Cleq%20%5Cbegin%7Bbmatrix%7D%20-L_fV%20-%20c_V%20V%20%5C%5C%20L_fh%20%2B%20%5Cgamma%20h%20%5Cend%7Bbmatrix%7D">
</div>

## 6. Como o QP "Medeia" o Conflito? (A Mecânica da Decisão)

O QP analisa as duas restrições e toma a decisão em 3 passos:

1.  **Tenta $$( \delta = 0 )$$**: O QP primeiro verifica se existe algum $$( u )$$ que satisfaça **ambas** as restrições com $$( \delta = 0 )$$. Se existir, ótimo! A CLF é respeitada integralmente, e o carro acelera/freia para seguir $$( V_d )$$ sem relaxação.

2.  **Conflito (A CBF Vence)**: Se não existe $$( u )$$ que satisfaça as duas ao mesmo tempo (ex: a CLF quer acelerar, mas a CBF exige frenagem forte), o QP **aumenta o valor de $$( \delta )$$**. Isso "alivia" a restrição da CLF (o lado direito fica menos negativo ou positivo), permitindo que o QP escolha um $$( u )$$ que satisfaça a CBF.

3.  **O $$( \delta )$$ é penalizado**: Como $$( p_\delta )$$ é altíssimo, o QP calcula o **menor $$( \delta )$$ possível** que ainda permite satisfazer a CBF. Assim que o perigo passa, o QP reduz $$( \delta )$$ a zero.

**Geometricamente:** O QP encontra o ponto mais próximo da origem (no espaço $$( u \times \delta )$$) que ainda está dentro da região viável definida pelas duas retas (restrições).


## 7. Conexão com seu Código (`QPhild.m` e Simulink)

No seu bloco `CLF_CBF_QP` do Simulink, você monta as matrizes:

| Variável | O que contém | De onde vem |
| :--- | :--- | :--- |
| **$$( H )$$** | $$( [1, 0; 0, p_\delta] )$$ | Parâmetros do projeto. |
| **$$( f )$$** | $$( [0, 0]^T )$$ (ou vetor de custo linear) | Geralmente zero para ACC básico. |
| **$$( A )$$** | $$( [L_gV, -1; -L_gh, 0] )$$ | Do `LIE_2026.m`. |
| **$$( b )$$** | $$( [-L_fV - c_V V; L_fh + \gamma h] )$$ | Do `LIE_2026.m`. |

E chama o `QPhild.m`, que resolve este sistema $$( Az \leq b )$$ usando o algoritmo de Hildreth, retornando $$( u )$$ e $$( \delta )$$.

## 8. Conclusão

"O QP atua como um mecanismo de mediação entre a CLF e a CBF, resolvendo um problema de otimização quadrática que minimiza o esforço de controle $$( u^2 )$$ e a relaxação da CLF $$( \delta^2 )$$. As restrições da CLF e da CBF são formuladas como desigualdades lineares afins em $$( u )$$, resultando em um problema convexo de rápida solução. Quando as restrições entram em conflito, o QP prioriza a CBF (rígida) e eleva o valor de $$( \delta )$$ (relaxação da CLF) apenas o suficiente para garantir a factibilidade. Esta estrutura garante que a segurança nunca seja violada, enquanto o desempenho é otimizado sempre que possível."

**Agora você tem o quadro completo:** 
- CLF puxa para frente (desempenho). 
- CBF segura para trás (segurança). 
- QP é o juiz que calcula o equilíbrio perfeito a cada milésimo de segundo, usando $$( \delta $$) como o "termo de ajuste" para evitar que o problema fique sem solução.





