# Função Indireta de Lyapunov

## 1. O que é uma Função de Lyapunov? (Estrutura Genérica)

Analogamente ao conceito físico de **energia**, uma Função de Lyapunov $V(x)$ é uma construção matemática escalar utilizada para determinar a estabilidade de um sistema dinâmico sem a necessidade de resolver explicitamente suas equações diferenciais (que muitas vezes são não-lineares e impossíveis de resolver analiticamente). Em outras palavras, Lyapunov generalizou a ideia em que, em vez de "energia física", usamos uma função matemática $V(x)$ que se comporta como uma energia generalizada.

Assim, se conseguirmos mostrar que essa função é sempre positiva (exceto no ponto de equilíbrio, onde é zero), e diminui continuamente ao longo das trajetórias do sistema, então podemos concluir que o sistema é estável, sem precisar resolver a equação diferencial.

## 2. Definição formal (Teorema de Lyapunov para Linearização):

Considere um sistema não-linear autônomo na forma:
<div align="center">
  <img src="https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bx%7D%20%3D%20f(x)">
</div>

onde `x = 0` é um ponto de equilíbrio (ou seja, `f(0) = 0`) e `f` é continuamente diferenciável.

O método consiste em:

1.  **Linearizar o sistema** em torno do ponto de equilíbrio `x = 0` usando a série de Taylor (desprezando termos de ordem superior):
  
    ![\color{white} \dot{x} \approx A \cdot x](https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Bx%7D%20%5Capprox%20A%20%5Ccdot%20x)

    onde `A` é a **matriz Jacobiana** avaliada no ponto de equilíbrio:

    ![\color{white} A = \left. \frac{\partial f}{\partial x} \right|_{x = 0}](https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20A%20%3D%20%5Cleft.%20%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20x%7D%20%5Cright%7C_%7Bx%20%3D%200%7D)

2.  **Analisar os autovalores** (`λ_i`) da matriz `A`.

3.  **Teorema Indireto de Lyapunov**:
    - Se **todos** os autovalores de `A` têm **parte real estritamente negativa** (`Re(λ_i) < 0`), então o ponto de equilíbrio `x = 0` do sistema não-linear original é **assintoticamente estável**.
    - Se **pelo menos um** autovalor tem **parte real positiva** (`Re(λ_i) > 0`), o sistema é **instável**.
    - Se os autovalores têm parte real **zero**, o método é **inconclusivo** (depende das não-linearidades de ordem superior).

---

## 2. Por que NÃO usar o Indireto no ACC?

Se linearizássemos a dinâmica do veículo em torno da velocidade desejada `Vd`:
- Estado do erro: `e = Vf - Vd`.
- Dinâmica do erro: 
  ![\color{white} \dot{e} = -\frac{F_r(V_f)}{m} + \frac{u}{m}](https://latex.codecogs.com/png.image?%5Ccolor%7Bwhite%7D%20%5Cdot%7Be%7D%20%3D%20-%5Cfrac%7BF_r(V_f)%7D%7Bm%7D%20%2B%20%5Cfrac%7Bu%7D%7Bm%7D).
- A resistência aerodinâmica `Fr(Vf)` (que possui termos `Vf²`) seria aproximada por uma reta (Taylor) em torno de `Vd`.
- O sistema resultante seria `ė = a*e + b*u`. Projetando `u = -K*e`, teríamos `ė = (a - bK)e`. A estabilidade é garantida **apenas se `a - bK < 0`**, e apenas **perto de `Vd`**.

### 2.1. A Grande Limitação (Local vs. Global)
O Método Indireto garante estabilidade **apenas localmente**. 
- Se o carro estiver a 10 m/s e a referência for 30 m/s, a linearização feita em torno de 30 m/s **não é válida** para 10 m/s. A prova de estabilidade "quebra".
- **Pior no ACC com CBF**: Quando a restrição de segurança atua (frenagem brusca), o sistema pode sair completamente da região onde a linearização é válida. Não é possível provar matematicamente que o sistema retornará ao equilíbrio.

---

## 3. Por que o Método Direto (CLF) é Melhor Aqui?

No seu trabalho, você utiliza o **Método Direto** com a CLF `V = (Vf - Vd)²` e relaxação via QP.

| Característica | Método Indireto (Linearização) | Método Direto (CLF no QP) |
| :--- | :--- | :--- |
| **Base** | Linearização do sistema em torno do equilíbrio. | Função escalar positiva `V(x)` (ex: erro quadrático). |
| **Garantia de Estabilidade** | **Local** (apenas perto da referência). | **Global** (válida para todo o domínio de operação). |
| **Manuseio de Não-linearidades** | Precisa ser cortado/ignorado (ex: arrasto `Vf²`). | Lida diretamente com a não-linearidade (usa `LfV` exata). |
| **Manuseio de Restrições (CBF)** | Não lida bem. A segurança quebra a linearização. | Lida perfeitamente via QP. Segurança é priorizada. |
| **Esforço Computacional** | Muito baixo (multiplicação de ganhos fixos). | Médio (resolução do QP via Hildreth em tempo real). |

---

## 4. Conclusão para seu TCC

> "O Método Indireto de Lyapunov, embora amplamente utilizado em sistemas lineares, apresenta uma limitação fundamental para este trabalho: sua validade é estritamente local. Dado que o veículo pode operar em uma ampla faixa de velocidades e que a atuação da CBF pode levar o sistema para regiões distantes do equilíbrio, a linearização não seria capaz de garantir formalmente a estabilidade global. 
> 
> Por este motivo, optou-se pelo **Método Direto de Lyapunov**, que, através da função `V = (Vf - Vd)²`, fornece uma prova de estabilidade válida para todo o domínio de operação, sendo perfeitamente compatível com a estrutura de otimização (QP) utilizada para mediar o conflito entre desempenho e segurança."














