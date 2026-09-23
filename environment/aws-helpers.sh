# Docker login to ECR
ecrlogin() {
 REGION=${1:-us-east-1}
 ACCOUNT_ID=$(aws sts get-caller-identity  | jq -r .Account)
 aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
}

# Ensure AWS SDK uses config for profile region etc
export AWS_SDK_LOAD_CONFIG=1