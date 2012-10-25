class Shiki
  constructor: (variable_name) ->
    @variable_name = variable_name
    @root = new Shiki.Operator('*')
    @root.left = new Shiki.Operand.Variable(@variable_name)
    @root.right = new Shiki.Operand.Number(1)

  getFunction: ->
    eval("(function(#{@variable_name}){return " + @getString() + ";})")

  getString: ->
    @root.getString()

  step: ->
    i = 0
    before = @root.getString()
    after = before
    while i < 10 && before == after
      node = @getRandomOperator(@root)
      Shiki.choise([@wrapNode, @cutNode, @bang]).apply(this, [node])
      after = @root.getString()
      i++

  getRandomOperator: (root)->
    current = root
    while Math.random() < 0.3
      index = current.randomIndex()
      if current[index].isOperator
        current = current[index]
      else
        return current

    return current

  getRandomNode: (root) ->
    current = root
    while current.isOperator && Math.random() < 0.8
      current = current[current.randomIndex()]

    return current

  getRandomOperand: (root)->
    current = root
    while current.isOperator
      current = current[current.randomIndex()]

    return current

  wrapNode: (node) ->
    index = node.randomIndex()
    operator = @randomOperator()
    lr = [node[index], @randomInstance()]
    lr = [lr[1], lr[0]] if Math.random() > 0.5
    operator.left = lr[0]
    operator.right = lr[1]
    node[index] = operator

  cutNode: (node) ->
    index = node.randomIndex()
    child = @getRandomNode(node[index])
    node[index] = child

  bang: (node) ->
    node.bang()

  changeValue: (node) ->
    node[node.randomIndex()] = @randomInstance()

  randomOperator: ->
    r = new Shiki.Operator(Shiki.choise(Shiki.Operator.operators))
    r.left = @randomInstance()
    r.right = @randomInstance()
    r

  randomInstance: ->
    rand = Math.random()

    if rand > 0.7
      @randomOperator()
    else if rand > 0.4
      new Shiki.Operand.Number
    else
      new Shiki.Operand.Variable(@variable_name)

Shiki.choise = (list) ->
  list[Math.floor(Math.random() * list.length)]

class Shiki.Operator
  constructor: (operator) ->
    if operator?
      @operator = operator
    else
      @bang()
    @left = new Shiki.Operand(0)
    @right = new Shiki.Operand(0)

  getString: ->
    "(" + [@left.getString(), @operator, @right.getString()].join('') + ")"

  bang: ->
    @operator = Shiki.choise(Shiki.Operator.operators)
    @left.bang() if @left
    @right.bang() if @right

  isOperator: true

  randomIndex: ->
    Shiki.choise(['left', 'right'])

Shiki.Operator.operators = '* % / + & | ^ << >>'.split(/\s+/)

class Shiki.Operand
  constructor: (value) ->
    @value = value

  getString: ->
    @value

  isOperator: false

class Shiki.Operand.Variable extends Shiki.Operand
  bang: ->

class Shiki.Operand.Number extends Shiki.Operand
  constructor: ->
    @bang()

  bang: ->
    @value = Math.floor(Math.random()*10)+1


t = new Shiki('t')

stdin = process.openStdin()

stdin.on 'data', (event) ->
  if event.toString() == "reset\n"
    t = new Shiki('t')
  else
    t.step()

  console.log t.getString()




