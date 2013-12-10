SimpleCov.start do 
  filters.clear

  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /kitchen_boy/
  end

  add_filter "/spec/"
  add_filter "/features/"
end
