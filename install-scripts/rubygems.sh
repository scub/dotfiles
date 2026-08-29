#
# CLI tooling provided through gems
#
install_rubygem_tools() {
  bundle config set path $HOME/.dotfiles/install-scripts/rubygems
  bundle config set path.system true
  bundle install --system
  bundle config unset path
  bundle config unset path.system
}