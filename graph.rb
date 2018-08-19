module WeightComparable
  def <=>(other)
    @weight <=> other.weight
  end
end

class Node
  attr_accessor :name, :edges

  def initialize(name)
    @name = name
    @edges = []
  end

  def add_edge(node)
    self.edges << node
  end

  def to_s
    @name
  end

  def edgeTo(node)
    Edge.new(self, node)
  end

end

class Edge
  include WeightComparable
  attr_accessor :weight, :node1, :node2

  def initialize(node1, node2, weight = 1)
    @node1, @node2 = node1, node2
    @weight = weight

    @node1.add_edge(self)
    @node2.add_edge(self)
  end

  def set_weight(weight)
    @weight = weight
  end

  def to_s
    "#{@node1} #{@node2} #{@weight}"
  end

  def other_node(node)
    if @node1 != node
      @node1
    else
      @node2
    end
  end

end

class Entry
  include WeightComparable
  attr_accessor :previous, :weight
  
  def initialize()
    @weight = Float::INFINITY
  end
  
  def to_s
    "#{previous} #{weight}"
  end
end

def shortestPath(nodes, start_node)
  table = nodes.map { |node| [node, Entry.new] }.to_h
  table[start_node].weight = 0

  unvisited_nodes = nodes.clone
  
  nodes.each {|node| node.edges.sort}
  
  while unvisited_nodes.any?
    active_node = unvisited_nodes.map {|node| table[node]}.sort.first #TODO: select the node with the lowest weight
    unvisited_nodes.delete(active_node)
    
    edges_to_follow = active_node.edges.select{ |edge| unvisited_nodes.include? edge.other_node(active_node)}
    
    puts edges_to_follow
    
    edges_to_follow.each do |edge|
      weight = edge.weight
      node = edge.other_node(active_node)
      entry = table[node] 
      
      if entry.weight > weight 
        entry.weight = weight
        entry.previous = node
      end
    end
  end
  
  table
end


n = ["A", "B", "C", "D", "E"].map { |name| [name, Node.new(name)] }.to_h

n["A"].edgeTo(n["B"]).set_weight(6)
n["A"].edgeTo(n["D"]).set_weight(1)

n["B"].edgeTo(n["D"]).set_weight(2)
n["B"].edgeTo(n["E"]).set_weight(2)
n["B"].edgeTo(n["C"]).set_weight(5)

n["C"].edgeTo(n["E"]).set_weight(5)

n["D"].edgeTo(n["E"]).set_weight(1)


shortestPath(n.values, n["A"]).each do |key, value|
  puts "#{key} #{value}"
end