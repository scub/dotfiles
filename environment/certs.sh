# Define location of Internal cert bundle
export CERTIFICATE_BUNDLE=$HOME/.ssl/internal-bundle.pem

# Use Internal cert bundle with all language environments
export REQUESTS_CA_BUNDLE=$CERTIFICATE_BUNDLE
export CURL_CA_BUNDLE=$CERTIFICATE_BUNDLE
export NODE_EXTRA_CA_CERTS=$CERTIFICATE_BUNDLE
export AWS_CA_BUNDLE=$CERTIFICATE_BUNDLE
export SSL_CERT_FILE=$CERTIFICATE_BUNDLE