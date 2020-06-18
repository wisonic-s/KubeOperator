#!/bin/sh

check_command(){
    if [ $# -le 0 ]
    then
        exit 0
    else
        for i in $@
        do
            which $i > /dev/null 2>&1
            if [ $? -ne 0 ]
            then
                echo "命令 $i 不存在,请确认相关软件是否已经安装！"
                exit 1
            fi
        done
    fi
}

if [ $# -ne 1 ]
then
    echo "请指定要生成的 webkubectl 的镜像版本和标签，例如: webkubectl:v1.0"
    exit 1
fi

check_command git docker
if [ $? -ne 0 ]
then
    exit 1
fi

CURRENT_DIR=$(cd `dirname $0`; pwd)

git clone https://github.com/KubeOperator/webkubectl.git

sed -i 's/amd64/arm64/g' $CURRENT_DIR/webkubectl/Dockerfile

docker build -t $1 -f $CURRENT_DIR/webkubectl/Dockerfile $CURRENT_DIR/webkubectl
