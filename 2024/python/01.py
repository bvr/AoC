
# from https://www.reddit.com/r/adventofcode/comments/1h3vp6n/comment/lztuvx8/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

data = [*map(int, open('../input/01.txt').read().split())]
A, B = sorted(data[0::2]), sorted(data[1::2])
print(sum(map(lambda a, b: abs(a-b), A, B)),
      sum(map(lambda a: a * B.count(a), A)))

# Today's Python trick is on line 6: map() can take multiple iterables. Example:
# 
# >>> xs = [1, 2, 3]
# >>> ys = [4, 5, 6]
# >>> list(map(lambda x, y: x + y, xs, ys))
# [5, 7, 9]
