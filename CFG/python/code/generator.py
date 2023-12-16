def square_numbers(n):
  for i in range(n):
    yield i ** 2

squares = square_numbers(5)
for num in squares:
  print(num)