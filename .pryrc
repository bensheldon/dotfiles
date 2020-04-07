puts "Loaded ~/.pryrc"

# Allow multiline pasting
# https://github.com/pry/pry/issues/1524#issuecomment-324455658
Pry.commands.delete /\.(.*)/
