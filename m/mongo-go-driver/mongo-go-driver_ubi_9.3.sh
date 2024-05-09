PACKAGE_PATH=github.com/mongodb/
PACKAGE_NAME=mongo-go-driver
PACKAGE_VERSION=v1.15.0
PACKAGE_URL=https://github.com/mongodb/mongo-go-driver

# Install dependencies
yum install -y wget
yum install -y make git wget gcc


# Download and install go
yum install golang -y
wget https://golang.org/dl/go1.17.5.linux-ppc64le.tar.gz
tar -xzf go1.17.5.linux-ppc64le.tar.gz
rm -rf go1.17.5.linux-ppc64le.tar.gz
export GOPATH=`pwd`/gopath
export PATH=`pwd`/go/bin:$GOPATH/bin:$PATH

# Clone the repo and checkout submodules
yum install git -y
git clone $PACKAGE_URL
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION
echo "Building github.com/mongodb/mongo-go-driver v1.15.0"
go get go.mongodb.org/mongo-driver/mongo

#install mongodb
yum install https://repo.mongodb.com/yum/redhat/8/mongodb-enterprise/7.0/ppc64le/RPMS/mongodb-enterprise-server-7.0.8-1.el8.ppc64le.rpm -y
yum install python3-devel -y
systemctl start mongod

#cd mongo/integration/

echo "Building $PACKAGE_PATH$PACKAGE_NAME with $PACKAGE_VERSION"
if ! go build -v ./... ; then
    echo "------------------$PACKAGE_NAME:install_fails-------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_Fails"
    exit 1
fi
cd x/mongo/driver/topology/
echo "Testing $PACKAGE_PATH$PACKAGE_NAME with $PACKAGE_VERSION"
if ! go test -v ./... ; then
    echo "------------------$PACKAGE_NAME:install_success_but_test_fails---------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_success_but_test_Fails"
    exit 2
else
    echo "------------------$PACKAGE_NAME:install_&_test_both_success-------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub  | Pass |  Both_Install_and_Test_Success"
    exit 0
fi