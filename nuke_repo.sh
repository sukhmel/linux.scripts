#! /bin/sh
# remove all git repository contents except for files specified in command line

FLAGS=1
VERBOSE=1
EXECUTE=1
while [ $FLAGS ]
do
    FLAGS=""

    if [ -n $VERBOSE ] && [ "-q" = "$1" ]
    then
        shift
        SUFFIX="> /dev/null"
        VERBOSE=""
        FLAGS=1
    fi

    if [ -n $EXECUTE ] && [ "-n" = "$1" ]
    then
        shift
        EXECUTE=""
        FLAGS=1
    fi
done

for file in "$@"
do
    GREP_LINE="$GREP_LINE | grep -v '$file' "
    EXCEPT="$EXCEPT$file "
done

LS_LINE="git ls-files $GREP_LINE" 
NON_SPACE_LIST=$(eval "$LS_LINE | grep -v ' '")
SPACE_LIST=$(eval "$LS_LINE | grep ' ' | sed 's/ /#/g'")

LIST=$( echo $SPACE_LIST | sed 's/ /:/g;s/#/ /g')

if [ $VERBOSE ]
then
    echo going to remove:
    echo $NON_SPACE_LIST
    echo $SPACE_LIST
fi

if [ "$NON_SPACE_LIST" != "" ]
then
    cmd="git rm --cached --ignore-unmatch $(echo $NON_SPACE_LIST) $SUFFIX"

    if [ $VERBOSE ]
    then
        echo "$cmd"
    fi
    
    if [ $EXECUTE ]
    then
        eval "$cmd"
    fi
fi

if [ "$LIST" != "" ]
then
    (
        IFS=':'
        for file in $LIST
        do
            cmd="git rm --cached '$file' $SUFFIX"
            if [ $VERBOSE ]
            then
                echo "$cmd"
            fi

            if [ $EXECUTE ]
            then
                eval "$cmd"
            fi
        done
    )
fi

echo removed all repository contents except for $EXCEPT
