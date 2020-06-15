#!/bin/bash

declare -a arr=("test1.git" "test2.git")

shuffle() {
    local i tmp size max rand
    size=${#arr[*]}
    echo $size
    max=$(( 32768 / size * size ))
    
    for ((i=size-1; i>0; i--)); do
        while (( (rand=$RANDOM) >= max )); do :; done
        rand=$(( rand % (i+1) ))
        tmp=${arr[i]} arr[i]=${arr[rand]} arr[rand]=$tmp
    done
}

update_respos(){
    mkdir -p ./test1/repos
    test1_dir=$root_path/test1/repos
    for i in {1..10}
    do
        for j in "${arr[@]}"
        do
            git_path=$(echo $test1_dir/$j|sed 's/\.git//g')
            if [[ ! -d $j ]]
            then
                git clone "https://bitbucket.9msn.net/scm/ops/$j" $git_path
            fi
            cd $git_path
            echo "dummy file" > $git_path/yoloman1
            git add yoloman1
            git commit -m "yoloman commits"
            git push origin master
        done
    done
}


check_out_braches(){
    mkdir -p ./test2/repos
    test2_dir=$root_path/test2/repos
    for i in {1..10}
    do
        for j in "${arr[@]}"
        do
            git_path=$(echo $test2_dir/$j|sed 's/\.git//g')
            if [[ ! -d $j ]]
            then
                git clone "https://bitbucket.9msn.net/scm/ops/$j" $git_path
            fi
            cd $git_path
            for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `;
            do
                git branch --track ${branch#remotes/origin/} $branch
            done
        done
    done
}

# Clean up git repos
clean(){
    cd $root_path
    rm -rf ./test1
    rm -rf ./test2
}


root_path=$PWD
shuffle
update_respos
check_out_braches
clean

