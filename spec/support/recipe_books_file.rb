def write_recipe_books_file config, string
  File.open(config.recipe_books_file_path, 'w') { |f| f.write(string) }
end
