# Modelagem Matemática e Análise das EDOs do Sistema ACC

Dduzindo passo a passo das Equações Diferenciais Ordinárias (EDOs) que modelam a dinâmica longitudinal do veículo no problema de Controle de Cruzeiro Adaptativo (ACC), bem como a análise matemática dessas equações para fins de controle.

## 1. Definição das Variáveis de Estado

Para descrever o sistema, definimos o vetor de estados $x \in \mathbb{R}^2$ como:

$$ x = [V_f, D]^T $$

Onde:
- **$V_f$** : Velocidade longitudinal do veículo controlado (seguidor) em m/s.
- **$D$** : Distância relativa entre o veículo seguidor e o veículo líder em m.

Consideramos também as seguintes variáveis exógenas e parâmetros:
- **$V_l$** : Velocidade do veículo líder (m/s), a entrada externa (distúrbio).
- **$u$** : Força de tração/frenagem aplicada ao veículo (N), a variável de controle.
- **$m$** : Massa do veículo (kg).

## 2. Dinâmica da Velocidade ($\dot{V}_f$)

Aplicando a Segunda Lei de Newton na direção longitudinal do movimento, temos que a massa vezes a aceleração é igual à soma das forças externas:

$$ \sum F = m a = m \cdot \dot{V}_f  $$

As forças atuantes são:
1. **Força de Tração/Frenagem ($u$)**: positiva para aceleração, negativa para frenagem.
2. **Força de Arrasto Aerodinâmico ($F_r$)**: atua contra o movimento (sentido negativo).

Portanto:

$$ m \cdot \dot{V}_f = -F_r(V_f) + u $$

Isolando a derivada da velocidade (aceleração):

$$ \dot{V}_f = -\frac{F_r(V_f)}{m} + \frac{1}{m} u $$


## 3. Dinâmica da Distância ($\dot{D}$) - Cinemática Relativa

A distância entre os dois veículos varia conforme a diferença de velocidade entre eles.

- Se $V_l > V_f$ (líder mais rápido), a distância $D$ aumenta ($\dot{D} > 0$).
- Se $V_l < V_f$ (seguidor mais rápido), a distância $D$ diminui ($\dot{D} < 0$).

A taxa de variação é a diferença das velocidades:

$$ \dot{D} = V_l - V_f $$


## 4. Modelagem da Força de Arrasto Aerodinâmica ($F_r$)

Para tornar o modelo realista, a força de arrasto é uma função não-linear da velocidade. A formulação empírica mais comum é um polinômio quadrático:

$$ F_r(V_f) = f_0 + f_1 \cdot V_f + f_2 \cdot V_f^2 $$

Onde:
- $f_0$: Coeficiente de atrito de rolamento (resistência constante).
- $f_1$: Coeficiente de atrito viscoso (linear com a velocidade).
- $f_2$: Coeficiente de arrasto aerodinâmico (dominante em altas velocidades, proporcional a $V_f^2$).

**Observação:** O termo $V_f^2$ é o grande responsável pela **não-linearidade** do sistema.


## 5. Sistema Completo de EDOs (Modelo no Espaço de Estados)

Substituindo $F_r$ nas equações, obtemos o sistema de duas EDOs de primeira ordem acopladas:

$$
\begin{aligned}
\dot{V}_f &= -\frac{f_0 + f_1 V_f + f_2 V_f^2}{m} + \frac{1}{m} u \\[0.5ex]
\dot{D} &= V_l - V_f
\end{aligned} 
$$

## 6. Destrinchando as EDOs: Passo a Passo para Análise

Para projetar o controlador e analisar a estabilidade, precisamos extrair informações dessas equações.

### 6.1. Passo 1: Pontos de Equilíbrio
O ponto de equilíbrio ocorre quando as derivadas se anulam ($\dot{V}_f = 0$ e $\dot{D} = 0$).

- Da equação de distância: $\dot{D} = 0 \Rightarrow V_l = V_f$. (O carro iguala a velocidade do líder).
- Da equação de velocidade: $\dot{V}_f = 0 \Rightarrow u = F_r(V_f)$. (O controle aplicado deve equilibrar exatamente a força de arrasto).

### 6.2. Passo 2: Matriz Jacobiana (para análise local - Método Indireto)
Se quiséssemos analisar a estabilidade local (próximo ao equilíbrio), calcularíamos a matriz Jacobiana $A = \frac{\partial f}{\partial x}$:

$$ 
A = \begin{bmatrix} 
\dfrac{\partial \dot{V}_f}{\partial V_f} & \dfrac{\partial \dot{V}_f}{\partial D} \\[1.2ex]
\dfrac{\partial \dot{D}}{\partial V_f} & \dfrac{\partial \dot{D}}{\partial D}
\end{bmatrix}
= \begin{bmatrix} 
-\dfrac{f_1 + 2f_2 V_f}{m} & 0 
\\ [1.2ex]
-1 & 0
\end{bmatrix} 
$$

**Interpretação:** Como a matriz é triangular inferior, os autovalores são os elementos da diagonal principal. Isso mostra que a estabilidade local varia com a velocidade $V_f$, comprovando a necessidade de um controle não-linear (Método Direto).

### 6.3. Passo 3: Forma Afim para o QP ($\dot{x} = f(x) + g(x)u$)
O controlador QP exige que o sistema esteja na forma afim (linear no controle $u$). Separando os termos:

$$ 
f(x) = \begin{bmatrix} 
-\dfrac{F_r(V_f)}{m} \\[1ex]
V_l - V_f
\end{bmatrix}, 
\qquad 
g(x) = \begin{bmatrix} 
\dfrac{1}{m} \\[1ex]
0
\end{bmatrix} 
$$

Esta é exatamente a estrutura utilizada no seu script `LIE_2026.m` para calcular as derivadas de Lie:

```matlab
syms m Vf Vd xr Vl Fr Td Ds
x = [Vf; xr];
f = [-Fr/m; Vl - Vf];
g = [1; 0];
7. Implementação Numérica no MATLAB (Função das EDOs)
Se você quiser simular este sistema sem o Simulink (apenas com MATLAB), pode criar a seguinte função para usar com ode45:

matlab
function dx = modelo_veiculo(t, x, u, Vl, m, f0, f1, f2)
    % Entradas:
    %   t: tempo (s)
    %   x: vetor de estados [Vf; D]
    %   u: controle (força aplicada) - pode ser uma função do tempo ou estado
    %   Vl: velocidade do líder (m/s)
    % Parâmetros: m, f0, f1, f2
    
    Vf = x(1);
    D  = x(2);
    
    % Calcula a força de arrasto
    Fr = f0 + f1 * Vf + f2 * Vf^2;
    
    % Equações diferenciais
    dVf = -Fr/m + u/m;
    dD  = Vl - Vf;
    
    % Vetor de derivadas
    dx = [dVf; dD];
end
