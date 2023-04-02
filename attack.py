import time

def gcd(a,b: int) -> int:
    while b!=0:
        t=a%b
        a=b
        b=t
    return a

def attack():

    N = 727654310387077531730993221
    # разложение чисел на множители методом p эвристики Полларда
    x = 2;
    y = 1;
    i = 0;
    st = 2;

    # время выполнения кода
    start = time.time()
    while gcd(N, abs(x - y)) == 1:
        if i == st:
            y = x
            st = st * 2
        x = (x * x + 1) % N
        i += 1
    p = gcd(N, abs(x - y))

    end = time.time()

    q = int(N / p)

    print(f'Найденные числа p={p}, q={q} время поиска составило {(end - start) * 1000}ms')


attack()
