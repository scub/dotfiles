#
# CLI tooling provided through gems
#
install_rubygem_tools() {
  bundle config set path $HOME/.dotfiles/install-scripts/rubygems
  bundle install --system
  bundle config unset path
}