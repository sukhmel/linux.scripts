#! /bin/sh

RESULT=""
ORIGIN=$(pwd)

cd $HOME
if ! [ -d '.vim' ]
then
    mkdir .vim
fi

cd .vim
if ! [ -d 'bundle' ]
then
    mkdir bundle
fi

cd bundle
for file in `ls`
do
    if [ -d $file ]
    then
        #echo $file
        cd $file
        RESULT=$RESULT'\n'$(git remote show origin | grep "Fetch" | sed 's/^[^:]*:/git\ clone/')
        cd ..
    fi
done

cd $ORIGIN

echo \#! /bin/sh >> bundle.sh
echo $RESULT >> bundle.sh
chmod +x bundle.sh
