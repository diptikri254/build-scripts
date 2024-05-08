PACKAGE_NAME=jest-circus
PACKAGE_VERSION=${1:-v29.7.0}
PACKAGE_URL=https://github.com/facebook/jest

dnf install -y wget git yum-utils nodejs nodejs-devel nodejs-packaging npm python3 make  gcc gcc-c++   

NODE_VERSION=16.14.2 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install $NODE_VERSION
export PATH=/usr/local/bin:$PATH
ln -s /usr/bin/python3 /bin/python

source ~/.bashrc


npm i --global yarn 
yarn policies set-version  1.22.19

export PATH=/root/.nvm/versions/node/v16.14.2/bin/:$PATH
#Install and Run tests
git clone $PACKAGE_URL jest
cd jest 
git checkout $PACKAGE_VERSION
yarn add --dev @jest/globals@27.0.5  
yarn add --dev @jest/test-utils@0.0.0  
yarn add --dev jest@27.0.5 
yarn add --dev jest-changed-files@27.0.2 
yarn add --dev jest-mock@27.0.3 
yarn add --dev jest-snapshot@27.0.5 
yarn install 
yarn build:js
#Note that there are test failures which are in parity with Intel. Details are provided in the README file.

if ! yarn jest ./packages/jest-circus/ 2>&1 | tee test.log ; then
     	echo "------------------$PACKAGE_NAME:test_fails-------------------------------------"
		echo "$PACKAGE_URL $PACKAGE_NAME" 
		echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | GitHub | Fail |  test_fail" 
		exit 1
else
		echo "------------------$PACKAGE_NAME:test_success-------------------------------------"
		echo "$PACKAGE_URL $PACKAGE_NAME" 
		echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | GitHub | Success |  test_success" 
		exit 0
fi