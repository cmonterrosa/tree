# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_segment( node )

    html = "<li>"
    node_class = (node.children.length == 0)? "file" : "folder"
    html << "<span class=\"#{node_class}\">#{h(node.to_s)} </span>"
    html << "<ul id=\"children_of_#{h(node.id)}\">" 
    if node.children
      node.children.each{|child_node|
        html << display_segment( child_node )
      }
    end
    html << "</ul></li>"
  end

  def ihash(h, initial_folder=nil)
    h.each_pair do |k,v|
      if v.is_a?(Hash)
          puts "key: #{k} recursing..."
          ihash(v)
      else
        # MODIFY HERE! Look for what you want to find in the hash here
          puts "key: #{k} value: #{v}"
      end
  end
end

  def rec_path(path, file= false)
    puts path
    path.children.collect do |child|
      if file and child.file?
        child
      elsif child.directory?
        rec_path(child, file) + [child]
      end
    end.select { |x| x }.flatten(1)
 end




end
