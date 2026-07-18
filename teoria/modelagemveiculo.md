# Modelagem Matemática do Veículo e Equações do Controlador CLF-CBF-QP

## 1. Dinâmica do Veículo (Sistema ACC)

Define-se o vetor de estados do veículo controlado como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20x%20%3D%20%5B%20V_f%2C%20D%20%5D%5ET">
</div>

onde:
- \( V_f \): Velocidade do veículo controlado (m/s).
- \( D \): Distância relativa entre o veículo controlado e o veículo líder (m).
- \( V_l \): Velocidade do veículo líder (m/s) – considerada uma entrada exógena.
- \( u \): Força de tração/frenagem (ou aceleração desejada, dependendo da normalização) (m/s²).
- \( m \): Massa do veículo (kg).
- \( F_r(V_f) \): Resistência aerodinâmica (arrasto), geralmente modelada como \( F_r = f_0 + f_1 V_f + f_2 V_f^2 \).

A dinâmica do sistema é descrita pelas equações diferenciais ordinárias:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7BV%7D_f%20%3D%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%2B%20%5Cfrac%7B1%7D%7Bm%7D%20u">
</div>

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7BD%7D%20%3D%20V_l%20-%20V_f">
</div>

Reescrevendo na forma afim padrão para controle \( \dot{x} = f(x) + g(x)u \):

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20f(x)%20%3D%20%5Cbegin%7Bbmatrix%7D%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%5C%5C%20V_l%20-%20V_f%20%5Cend%7Bbmatrix%7D%2C%20%5Cquad%20g(x)%20%3D%20%5Cbegin%7Bbmatrix%7D%20%5Cfrac%7B1%7D%7Bm%7D%20%5C%5C%200%20%5Cend%7Bbmatrix%7D">
</div>

---

## 2. Função de Lyapunov de Controle (CLF) - Desempenho

O objetivo de desempenho é fazer com que a velocidade do veículo \( V_f \) rastreie a velocidade desejada \( V_d \). Define-se a CLF como o quadrado do erro de rastreamento:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20V(x)%20%3D%20(V_f%20-%20V_d)%5E2">
</div>

### 2.1. Derivadas de Lie da CLF

Para construir a restrição linear no QP, calculamos as derivadas de Lie:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fV%20%3D%20%5Cnabla%20V%20%5Ccdot%20f(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%5Cright)">
</div>

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_gV%20%3D%20%5Cnabla%20V%20%5Ccdot%20g(x)%20%3D%202(V_f%20-%20V_d)%20%5Ccdot%20%5Cleft(%20%5Cfrac%7B1%7D%7Bm%7D%20%5Cright)">
</div>

### 2.2. Restrição de Estabilidade (CLF)

A condição de estabilidade exponencial é imposta pela desigualdade:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V(x)%20%2B%20%5Cdelta">
</div>

Onde:
- \( c_V > 0 \): Taxa de decaimento exponencial (quanto maior, mais rápida a resposta).
- \( \delta \): Variável de relaxação (slack), que permite sacrificar a estabilidade temporariamente para priorizar a segurança.

---

## 3. Função de Barreira de Controle (CBF) - Segurança

A segurança no ACC é definida pela manutenção de uma distância mínima em relação ao veículo líder. Define-se a CBF como:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20h(x)%20%3D%20D%20-%20%5Ctau_h%20%5Ccdot%20V_f">
</div>

Onde:
- \( \tau_h > 0 \): Tempo de headway desejado (ex: 1.8 segundos). Garante que a distância seja proporcional à velocidade.

### 3.1. Derivadas de Lie da CBF

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%3D%20%5Cnabla%20h%20%5Ccdot%20f(x)%20%3D%20%5Ctau_h%20%5Ccdot%20%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%2B%20(V_l%20-%20V_f)">
</div>

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_gh%20%3D%20%5Cnabla%20h%20%5Ccdot%20g(x)%20%3D%20-%5Ctau_h">
</div>

*(Nota: Estes cálculos são exatamente os realizados pelo seu script `LIE_2026.m` quando ele executa `Lfhacc` e `Lghacc`).*

### 3.2. Restrição de Segurança (CBF)

A condição para que a distância nunca se torne negativa (invariância do conjunto seguro) é:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h(x)%20%5Cgeq%200">
</div>

Onde:
- \( \gamma > 0 \): Parâmetro que ajusta a "agressividade" da barreira. Quanto maior, mais cedo o sistema começa a frear para evitar a violação da segurança.

---

## 4. Formulação do Problema de Otimização (QP)

O controlador final é obtido resolvendo o seguinte QP a cada instante de tempo:

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cmin_%7Bu%2C%20%5Cdelta%7D%20%5Cquad%20%5Cfrac%7B1%7D%7B2%7D%20u%5ET%20H%20u%20%2B%20p_%5Cdelta%20%5Cdelta%5E2">
</div>

Sujeito às restrições:

**1. Desempenho (CLF):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fV%20%2B%20L_gV%20%5Ccdot%20u%20%5Cleq%20-c_V%20V%20%2B%20%5Cdelta">
</div>

**2. Segurança (CBF):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20L_fh%20%2B%20L_gh%20%5Ccdot%20u%20%2B%20%5Cgamma%20h%20%5Cgeq%200">
</div>

**3. Limites de Atuação (Opcional, mas recomendado para conforto):**

<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20u_%7B%5Cmin%7D%20%5Cleq%20u%20%5Cleq%20u_%7B%5Cmax%7D">
</div>

Onde:
- \( H \): Matriz de ponderação do controle (ex: \( H = 1/m^2 \) para minimizar o esforço de força).
- \( p_\delta \): Peso da relaxação (deve ser um valor alto, ex: \( 10^5 \), para que o QP só use \( \delta > 0 \) em emergências).

---

## 5. Interpretação Física do Sistema de Equações

| Elemento | Equação | Significado Físico |
| :--- | :--- | :--- |
| **Estado** | \( V_f, D \) | Velocidade do carro e distância até o da frente. |
| **Controle** | \( u \) | Força aplicada nas rodas (acelerar/frear). |
| **CLF** | \( V = (V_f - V_d)^2 \) | Mede o "erro" de velocidade. Queremos que ela chegue a zero. |
| **CBF** | \( h = D - \tau_h V_f \) | Mede a "folga" de segurança. Queremos que ela seja sempre positiva. |
| **QP** | Minimiza \( u^2 + p_\delta \delta^2 \) | Encontra a aceleração que satisfaz as restrições com o menor esforço possível. |

---

**Nota Final:** Este sistema de equações é a base teórica implementada no seu modelo Simulink (`ACC_TESTE_2026`) e resolvida numericamente pelo algoritmo de Hildreth (`QPhild.m`). Enquanto a CLF puxa o sistema para \( V_d \), a CBF o segura para que \( D \) não caia abaixo de \( \tau_h V_f \), criando um equilíbrio dinâmico entre desempenho e segurança.
```

---

Este bloco cobre **tudo** que você precisa para a seção de modelagem matemática do seu TCC. Está formatado especificamente para o **Dark Mode do GitHub** (texto branco, fundo escuro, equações centralizadas). 

Se quiser, posso agora gerar a versão com fundo branco (`&bg=white`) para ser universal, ou posso explicar como cada uma dessas equações se traduz diretamente nas linhas do seu código `LIE_2026.m`!
