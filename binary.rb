# Class for the Node
class Node
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def to_s
    "Node with value: #{@value}"
  end
end

# THe class for the Binary Tree
class Tree
  attr_accessor :root

  def initialize(array)
    # Sorts and makes array elements unique
    a = array.sort.uniq
    @root = build_tree(a)
  end

  def build_tree(array)
    start = 0
    last = array.length - 1
    mid = (start + last) / 2
    node = Node.new(array[mid])
    return node if mid.zero?

    # searches array everything does not include mid since it is already in the tree
    node.left = build_tree(array[0..(mid - 1)])
    node.right = build_tree(array[(mid + 1)..])
    node
  end

  # inserts value resursively only adds value node if there is null value
  # default starting value is the root
  def insert(value, current_node = @root)
    # if the node is null
    if current_node.nil?
      current = Node.new(value)
      return current
    # value is less than node so on left side
    elsif value < current_node.value
      current_node.left = insert(value, current_node.left)
    # value is greater than node so on right side
    elsif value > current_node.value
      current_node.right = insert(value, current_node.right)
    end
    # when the value is not greater than or less than current value it returns the root
    # code only searches if it is in the direction of value if not it simply returns the child node branch
    current
  end

  def delete(value, current_node = @root)
    # No value
    if (current_node.nil?)
      return create_node
    end

    # traverses left and right
    if value < current_node.value
      current_node.left = delete(value, current_node.left)
    # value is greater than node so on right side
    elsif value > current_node.value
      current_node.right = delete(value, current_node.right)
    else
      # when it is not traversing and not null so when current_node.value == value
      # time to delete make 3 cases
      # no child and 1 child
      if current_node.left.nil? && current_node.right.nil?
        return nil
      elsif current_node.left.nil?
        return current.right
      elsif current_node.right.nil?
        return current_node.left
      end

      # when neither child is null
      # finding inorder succesor
      sucessor = inorder_succesor(current_node.right)
      # removes it from right side where we find inorder sucessor
      current_node.right = delete(succesor.value, create_node.right)
      current_node = Node.new(succesor.value, current_node.left, current_node.right)
    end
    current_node
  end 

  # finding min of right side
  def inorder_succesor(current_node)
    min = current_node
    # left is less so lowest value on right tree so closest
    while min.left != nil
      min = min.left
    end
    min
  end

  def find(value, current_node = @root)
    if current_node == nil
      return nil
    elsif current_node.value == value
      return current_node
    # removed .branch instead set current to result
    elsif value < current_node.value
      current = find(value, current_node.left)
    elsif value > current_node.value
      current = find(value, current_node.right)
    end
    # when the value is not greater than or less than current value it returns the root
    # code only searches if it is in the direction of value if not it simply returns the child node branch
    current
  end

  def level_order(visit = @root)
    # Starts with root in queue
    return if(vist.nil?)
    queue = visit
    # Array to return
    node_array = []
    # while array still has nodes to traverse
    until(queue.empty?)
      # gives current value and removes it from queue
      current = queue.shift
      if(block_given?)
        yield(current)
      else
        node_array.push(current.value)
      end
      # if left not nil add it to queue
      queue.push(current.left) if(!current.left.nil?)
      # if right not nil add it to queue
      queue.push(current.right) if(!current.rigt.nil?)
    end
    node_array
  end
  # left, value, right

  def inorder(current_node = @root)
    return if current_node.nil?

    left_branch = postorder(current_node.left)
    if block_given?
      yield(current_node)
      right_branch = postorder(current_node.right)
    else
      right_branch = postorder(current_node.right)
      [left_branch, current_node.value, right_branch].flatten.compact
    end
  end
  # value, left, right

  def preorder(current_node = @root)
    return if current_node.nil?

    if block_given?
      yield(current_node)
      left_branch = postorder(current_node.left)
      right_branch = postorder(current_node.right)
    else
      left_branch = postorder(current_node.left)
      right_branch = postorder(current_node.right)
      [current_node.value, left_branch, right_branch].flatten.compact
    end
  end
  # left, right, value

  def postorder(current_node = @root)
    return if current_node.nil?

    left_branch = postorder(current_node.left)
    right_branch = postorder(current_node.right)
    # block given
    if block_given?
      yield(current_node)
    else
      [left_branch, right_branch, current_node.value].flatten.compact
    end
  end

  def depth(node, current_node = @root)
    return nil if find(node.value, current_node).nil?
    # adds one layer  when it finds node value
    if current_node.value == node.value
      return 1
    # removed .branch instead set current to result
    elsif value < current_node.value
      current = 1 + depth(node, current_node.left)
    elsif value > current_node.value
      current = 1 + depth(node, current_node.right)
    end
    # when the value is not greater than or less than current value it returns the root
    # code only searches if it is in the direction of value if not it simply returns the child node branch
    current
  end

  def balanced?(tree = @root)
    return if tree.nil?

    # finds height of tree root -> leaf lowest
    right_length = height(tree.right)
    left_length =  height(tree.left)
    # return false if right_length.nil? || left_length.nil?

    if (right_length - left_length).abs <= 1
      true
    else
      false
    end
  end
  # finds deepest

  def height(node)
    return 0 if node.nil?

    right_branch = 1 + height(node.right)
    left_branch =  1 + height(node.left)

    return right_branch if right_branch > left_branch
    return left_branch if left_branch > right_branch
    return right_branch
  end

  def rebalance
    array = inorder
    @root = build_tree(array)
  end

end

random = (Array.new(15) { rand(1..100) })
tree = Tree.new(random)
puts tree.root
p tree.balanced?
p tree.preorder
p tree.postorder
p tree.inorder
tree.insert(777)
puts tree.balanced?
tree.rebalance
puts tree.balanced?
p tree.preorder
p tree.postorder
p tree.inorder