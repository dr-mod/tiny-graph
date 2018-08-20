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

  def edge_to(node)
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
  attr_accessor :previous, :weight, :node
  
  def initialize(node)
    @node = node
    @weight = Float::INFINITY
  end
  
  def to_s
    "Node:#{node}, Weight:#{weight}, Prev:#{previous}"
  end
end

def shortest_path(nodes, start_node)
  table = nodes.map { |node| [node, Entry.new(node)] }.to_h
  table[start_node].weight = 0

  unvisited_nodes = nodes.clone
  
  while unvisited_nodes.any?
    active_node = unvisited_nodes.map {|node| table[node]}.sort.first.node
    unvisited_nodes.delete(active_node)
    
    edges_to_follow = active_node.edges.select{ |edge| unvisited_nodes.include? edge.other_node(active_node)}
    
    edges_to_follow.each do |edge|
      combined_weight = edge.weight + table[active_node].weight
      node = edge.other_node(active_node)
      entry = table[node] 
      
      if entry.weight > combined_weight
        entry.weight = combined_weight
        entry.previous = active_node
      end
    end
  end
  
  table.values
end


n = ["A", "B", "C", "D", "E"].map { |name| [name, Node.new(name)] }.to_h

n["A"].edge_to(n["B"]).set_weight(6)
n["A"].edge_to(n["D"]).set_weight(1)

n["B"].edge_to(n["D"]).set_weight(2)
n["B"].edge_to(n["E"]).set_weight(2)
n["B"].edge_to(n["C"]).set_weight(5)

n["C"].edge_to(n["E"]).set_weight(5)

n["D"].edge_to(n["E"]).set_weight(1)


shortest_path(n.values, n["A"]).each do |entry|
  puts entry
end