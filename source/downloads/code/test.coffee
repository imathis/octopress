fibonacci = (n) ->
  if n <= 2
    n
  else
    arguments.callee(n - 2) + arguments.callee(n - 1)

for x in [1..10]
  console.log "#{x} : #{fibonacci(x)}"
