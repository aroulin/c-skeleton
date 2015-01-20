echo "Running unit tests:"

for i in build/tests/*.test
do
    if test -f $i
    then
        if valgrind --leak-check=full --error-exitcode=1 ./$i 2>> build/tests/tests.log
        then
            echo $i PASS
        else
            echo "ERROR in test $i: here's tests/tests.log"
            echo "------"
            tail build/tests/tests.log
            exit 1
        fi
    fi
done

echo ""