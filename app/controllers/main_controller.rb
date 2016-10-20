############################################
# Controller to link with folder
############################################

require "pathname"

class MainController < ApplicationController
  def index
    #@hash = directory_hash("/var/www/html/owncloud/data/cmonterrosa/files/CONSEJO DE LA JUDICATURA")
    #@hash = directory_hash("/Users/cmonterrosa/Music")
    #@hash= rec_path(Pathname.new("/tmp"), true)
    #@hash= directory_hash("/Users/cmonterrosa/NetBeansProjects/transparencia_cliente")
    #@path = '/Users/cmonterrosa/NetBeansProjects/transparencia_cliente/**/*'
    @path = '/var/www/html/owncloud/data/cmonterrosa/files'
    @initial_folder = 'CONSEJO DE LA JUDICATURA'
    @tree = get_tree("#{@path}/#{@initial_folder}")
    @new_tree = @tree.each do |t|
      t.gsub!(@path, "")
    end
    a=10
  end



    def get_tree2(simple_path)
    Dir.glob("#{simple_path}/**/").
    map{|path|
      path.split '/' # split to parts
      }.inject({}){|acc, path| # start with empty hash
        path.inject(acc) do |acc2,dir| # for each path part, create a child of current node
        acc2[dir] ||= {} # and pass it as new current node
    end
    acc
  }
end

  def get_tree(simple_path)
    #Dir.glob(simple_path). # get all files below current dir
    #Dir["#{simple_path}**/**/*.xlsx"].
     #Dir.glob(simple_path + '/**').
     @urls=[]
     Dir.glob("#{simple_path}/**/").

  map{|path|
    path.split '/' # split to parts
  }.inject({}){|acc, path| # start with empty hash
     @urls << path.join("/")
     path.inject(acc) do |acc2,dir| # for each path part, create a child of current node
      acc2[dir] ||= {} # and pass it as new current node
    end
    acc
  }
return @urls
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

 def directory_hash2(path, name=nil, exclude = [])
  exclude.concat(['..', '.', '.git', '__MACOSX', '.DS_Store', '.rb'])
  data = {'text' => (name || path)}
  data[:children] = children = []
  Dir.foreach(path) do |entry|
    next if exclude.include?(entry)
    full_path = File.join(path, entry)
    if File.directory?(full_path)
      children << directory_hash2(full_path, entry)
    else
      children << {'icon' => 'jstree-file', 'text' => entry}
    end
  end
  return data
end

def directory_hash(path, name=nil)
  data = {:data => (name || path)}
  data[:children] = children = []
  Dir.foreach(path) do |entry|
    next if (entry == '..' || entry == '.')
    full_path = File.join(path, entry)
    if File.directory?(full_path)
      children << directory_hash(full_path, entry)
    else
      children << entry
    end
  end
  return data
end

def leaves_paths tree
  if tree[:children]
    tree[:children].inject([]){|acc, c|
      leaves_paths(c).each{|p|
        acc += [[tree[:name]] + p]
      }
      acc
    }
  else
    [[tree[:name]]]
  end
end

def estructura
  url="/var/www/html/owncloud/data/cmonterrosa/files/CONSEJO DE LA JUDICATURA"
  array = Dir["#{url}/*"]
  auto_hash = Hash.new{ |h,k| h[k] = Hash.new &h.default_proc }
  array.each{ |path|
    sub = auto_hash
    path.split( "/" ).each{ |dir| sub[dir]; sub = sub[dir] }
  }
  xml = Builder::XmlMarkup.new(:indent => 2)
    xml.ul do
      build_branch(auto_hash, xml)
  end
  return xml.target!
end



def build_branch(branch, xml)
  url_owncloud = "https://localhost/owncloud/index.php/apps/files/?dir=/CONSEJO%20DE%20LA%20JUDICATURA/INFORMACION%20OBLIGATORIA/"
  directories = branch.keys.reject{|k| branch[k].empty? }.sort
  leaves = branch.keys.select{|k| branch[k].empty? }.sort

  exclude = []
  exclude.concat(['..', '.', '.git', '__MACOSX', '.DS_Store', '.rb'])

  directories.each do |directory|
    xml.li(directory, :class => 'folder')
    xml.ul do
      build_branch(branch[directory], xml)
    end
  end

  leaves.each do |leaf|
    xml.ul(leaf, :class => 'folder')
    #xml.li("\<A XML-LINK='simple' HREF='#{leaf}'>#{leaf}\</A>", :class => 'leaf')
    next if exclude.include?(leaf)
    xml.li do
        xml.a(leaf, "href"=>"#{url_owncloud}/#{leaf}")
    end
  end
end

end
