#! /bin/sh

RESULT=""
PWD=$(pwd)

cd $HOME
if ! [ -d '.vim' ]
    mkdir .vim
fi

cd .vim
if ! [ -d 'bundle' ]
    mkdir bundle
fi

cd bundle
for file in `ls`
do
    if [ -d $file ]
    then
        #echo $file
        cd $file
        RESULT=$RESULT'\n'$(git remote show origin | grep "Fetch" | sed 's/Fetch\ URL:/git\ clone/')
        cd ..
    fi
done

echo $RESULT >> bundle.sh
chmod +x bundle.sh

cd $PWD
