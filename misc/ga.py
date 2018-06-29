# uncompyle6 version 3.2.3
# Python bytecode 3.6 (3379)
# Decompiled from: Python 3.6.5 |Anaconda, Inc.| (default, Apr 29 2018, 16:14:56) 
# [GCC 7.2.0]
# Embedded file name: /home/harold/work/ai/ga.py
# Compiled at: 2018-06-04 16:37:52
# Size of source mod 2**32: 6024 bytes
"""
A generic Genetic Algorithm

References
- https://en.wikipedia.org/wiki/Genetic_algorithm
- https://github.com/MorvanZhou

"""
import sys, numpy as np
if not sys.version_info >= (3, 5):
    raise AssertionError

class GA(object):
    """a generic Genetic Algorithm"""

    def __init__(self, size, fitfunc, context=None, limit=4294967296, popsize=100, crossover=0.4, mutation=0.01, permutation=False):
        """Args:
            size (int)                   : DNA size (number of genes)
            fitfunc (function)           : fitness function
            context (obj, optional)      : context to pass to fitness
            limit (:obj:`int`, optional) : upper limit for DNA value (can be 2)
            popsize (:obj:`int`, optional)    : population size (default 100)
            crossover (:obj:`int`, optional)  : crossover rate (default 40%)
            mutation (:obj:`int`, optional)   : mutation rate (default 1%)
            permutation (:obj: bool`, optional) : is DNA a permutation
        """
        self._size = size
        self._fitfunc = fitfunc
        self._context = context
        self._limit = limit
        self._popsize = popsize
        self._crossover = crossover
        self._mutation = mutation
        self._permutation = permutation
        if limit <= 256:
            self._dtype = np.uint8
        else:
            if limit <= 65536:
                self._dtype = np.uint16
            else:
                self._dtype = np.uint32
            if permutation:
                self._pop = np.vstack((np.random.permutation(self._limit) for _ in range(self._popsize)))
            else:
                self._pop = np.random.randint(self._limit, size=(
                 self._popsize, self._size),
                  dtype=self._dtype)

    @property
    def population(self):
        """return the population"""
        return self._pop

    @property
    def best(self):
        """return the best individual from the last selection"""
        return self._best

    @property
    def score(self):
        """return the best fitness score from last selection"""
        return np.max(self._scores)

    def _select(self):
        self._scores = self._fitfunc(self._pop, self._context)
        self._best = self._pop[np.argmax(self._scores)]
        idx = np.random.choice(self._popsize, size=self._popsize, p=self._scores / self._scores.sum())
        return self._pop[idx]

    def _cross(self, parent, parents):
        if np.random.rand() < self._crossover:
            i = np.random.randint(0, self._popsize, size=1)
            x_points = np.random.randint(0, 2, self._size).astype(np.bool)
            if self._permutation:
                keep = parent[~x_points]
                swap = parents[(i,
                 np.isin(parents[i].ravel(), keep, invert=True))]
                parent[:] = np.concatenate((keep, swap))
            else:
                parent[x_points] = parents[(i, x_points)]
            return parent

    def _mutate(self, child):
        for gene in range(self._size):
            if np.random.rand() < self._mutation:
                if self._permutation:
                    swap = np.random.randint(0, self._size)
                    child[gene], child[swap] = child[swap], child[gene]
                elif self._limit == 2:
                    child[gene] = 1 if child[gene] == 0 else 0
                else:
                    child[gene] = np.random.randint(self._limit)

        return child

    def evolve(self):
        """evolution = selection, crossover, mutation"""
        parents = self._select()
        self._pop = np.array([self._mutate(self._cross(i, parents)) for i in parents])


if __name__ == '__main__':
    pass
if len(sys.argv) == 1:
    print('ga.py guess <word> or ga.py travel <number>')
else:
    if sys.argv[1] == 'guess':
        word = sys.argv[2].lower() if len(sys.argv) > 2 else 'keepitsecret'
        word_dna = (np.fromstring(word, dtype=np.uint8)) - 97

        def fitness(dna, context):
            return np.sum(np.equal(dna, word_dna), axis=1)


        ga = GA(len(word), fitness, limit=26, mutation=0.01)
        for gen in range(1000):
            ga.evolve()
            w = ('').join(map(chr, ga.best + 97))
            print('Gen:', gen, '|', w)
            if w == word:
                break

    else:
        if sys.argv[1] == 'travel':
            ncities = int(sys.argv[2]) if len(sys.argv) > 2 else 20
            xycities = np.random.rand(ncities, 2)

            def fitness(dna, context):
                line_x = np.empty_like(dna, dtype=np.float64)
                line_y = np.empty_like(dna, dtype=np.float64)
                for i, d in enumerate(dna):
                    line_x[i, :] = xycities[d][:, 0]
                    line_y[i, :] = xycities[d][:, 1]

                distance = np.empty((line_x.shape[0],), dtype=np.float64)
                for i, (xs, ys) in enumerate(zip(line_x, line_y)):
                    distance[i] = np.sum(np.sqrt(np.square(np.diff(xs)) + np.square(np.diff(ys))))

                return np.exp(ncities * 2 / distance)


            ga = GA(ncities, fitness, limit=ncities, permutation=True, crossover=0.1,
              mutation=0.02,
              popsize=500)
            for gen in range(500):
                ga.evolve()
                print('Gen:', gen, '|score: %.0f' % ga.score, '|dist: %.2f' % (ncities * 2 / np.log(ga.score)))
# okay decompiling /home/harold/work/ai/__pycache__/ga.cpython-36.pyc
