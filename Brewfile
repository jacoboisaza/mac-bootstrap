# Aggregate manifest for humans and `brew bundle` compatibility.
# The setup script applies these files as isolated phases.
%w[core apps vscode].each do |name|
  path = File.join(__dir__, "brew", "Brewfile.#{name}")
  eval(File.read(path), binding, path)
end
