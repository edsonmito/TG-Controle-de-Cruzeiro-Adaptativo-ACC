# Função Indireta de Lyapunov

## 1. O que é uma Função de Lyapunov? (Estrutura Genérica)

Analogamente ao conceito físico de **energia**, uma Função de Lyapunov $V(x)$ é uma construção matemática escalar utilizada para determinar a estabilidade de um sistema dinâmico sem a necessidade de resolver explicitamente suas equações diferenciais (que muitas vezes são não-lineares e impossíveis de resolver analiticamente). Em outras palavras, Lyapunov generalizou a ideia em que, em vez de "energia física", usamos uma função matemática $V(x)$ que se comporta como uma energia generalizada.

Assim, se conseguirmos mostrar que essa função é sempre positiva (exceto no ponto de equilíbrio, onde é zero), e diminui continuamente ao longo das trajetórias do sistema, então podemos concluir que o sistema é estável, sem precisar resolver a equação diferencial.

## 2. Definição formal (Teorema de Lyapunov para Linearização):

Considere um sistema não-linear autônomo na forma:

![\dot{x} = f(x)](https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bx%7D%20%3D%20f(x))

onde \( x = 0 \) é um ponto de equilíbrio (ou seja, \( f(0) = 0 \)) e \( f \) é continuamente diferenciável.

O método consiste em:

1.  **Linearizar o sistema** em torno do ponto de equilíbrio \( x = 0 \) usando a série de Taylor (desprezando termos de ordem superior):

    $$ \dot{x} \approx A \cdot x $$

    onde \( A \) é a **matriz Jacobiana** avaliada no ponto de equilíbrio:

    $$ A = \left. \frac{\partial f}{\partial x} \right|_{x = 0} $$

2.  **Analisar os autovalores** (\( \lambda_i \)) da matriz \( A \).

3.  **Teorema (Lyapunov)**:
    - Se **todos** os autovalores de \( A \) têm **parte real estritamente negativa** (\( \text{Re}(\lambda_i) < 0 \)), então o ponto de equilíbrio \( x = 0 \) do sistema não-linear original é **assintoticamente estável**.
    - Se **pelo menos um** autovalor tem **parte real positiva** (\( \text{Re}(\lambda_i) > 0 \)), o sistema é **instável**.
    - Se os autovalores têm parte real **zero**, o método é **inconclusivo** (depende das não-linearidades de ordem superior).

### 1.2. Por que "Indireto"?
Porque você não precisa encontrar uma função de Lyapunov \( V(x) \) explicitamente. Em vez disso, estuda-se a dinâmica linearizada (mais fácil) e, a partir dela, "infere-se" indiretamente o comportamento do sistema *nas proximidades* do equilíbrio.















