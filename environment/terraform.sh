#
# Terraform helpers
#
alias tfi='rm -rf .terraform && terraform init'
alias tfv='terraform init && terraform validate'
alias tfdocs='terraform-docs markdown table --output-file README.md --output-mode inject .'
alias tfmt='terraform format -recursive .'

