# Modelagem Matemática do Veículo - Formulação do Problema de Otimização (QP)

<a href=modelandoqp.md>Modelagem</a>

O controlador final é obtido resolvendo a seguinte Programação Quadrática (QP) a cada instante de tempo:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20%5Cmin_%7Bu%2C%20%5Cdelta%7D%20%5Cquad%20%5Cfrac%7B1%7D%7B2%7D%20u%5ET%20H%20u%20%2B%20p_%5Cdelta%20%5Cdelta%5E2">
</div>

Sujeito às restrições:

**1. Desempenho (CLF):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V%20%2B%20%5Cdelta">
</div>

**2. Segurança (CBF):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h%20%5Cgeq%200">
</div>

**3. Limites de Atuação (Opcional, mas recomendado para conforto):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bblack%7D%20u_%7B%5Cmin%7D%20%5Cleq%20u%20%5Cleq%20u_%7B%5Cmax%7D">
</div>

Onde:
- $H$: Matriz de ponderação do controle (ex: $H = 1/m^2$ para minimizar o esforço de força).
- $p_\delta$: Peso da relaxação (deve ser um valor alto, ex: $10^5$, para que o QP só use $\delta > 0$ em emergências).


## 4. Interpretação Física do Sistema de Equações

| Elemento | Equação | Significado Físico |
| :--- | :--- | :--- |
| **Estado** | $V_f, D$ | Velocidade do carro e distância até o da frente. |
| **Controle** | $u$ | Força aplicada nas rodas (acelerar/frear). |
| **CLF** | $V = (V_f - V_d)^2$ | Mede o "erro" de velocidade. Queremos que ela chegue a zero. |
| **CBF** | $h = D - \tau_h V_f$ | Mede a "folga" de segurança. Queremos que ela seja sempre positiva. |
| **QP** | Minimiza $u^2 + p_\delta \delta^2$ | Encontra a aceleração que satisfaz as restrições com o menor esforço possível. |


**Nota Final:** Este sistema de equações é a base teórica implementada no seu modelo Simulink (`ACC_TESTE_2026`) e resolvida numericamente pelo algoritmo de Hildreth (`QPhild.m`). Enquanto 
