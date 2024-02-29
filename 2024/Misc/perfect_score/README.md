# Perfect Score

### Challenge Description

Can u find the value of x ?

**Challenge File**:
- [perfect_score.zip](./handout/perfect_score.zip)


### Short Writeup
Considering that there can be at most one prime factor greater than sqrt(x), we focus on primes smaller than or equal to sqrt(x). With an upper bound of 97, we have 25 primes in this range. For each of these primes, we aim to find the highest power that divides x. This process involves querying the maximum possible power through binary search (for instance, if 2 can have a maximum power of 14 in x, we perform a binary search on the range 0 to 14).

Moving on to primes larger than 97, we handle them separately. We first create an array containing the remaining primes. Then, we conduct binary search on this array to find a prime factor, denoted as y, such that gcd(x, y) > 1. This method helps identify any prime factors beyond the sqrt(x) threshold.

### Flag

bi0sctf{y0u_4r3_4_m4th3m4t1c14n}

### Author
Sans
