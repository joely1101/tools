#!/bin/bash
. libtimer.sh

myfunc1()
{
   tt=`date +%S`
   echo "function1 $@ $tt"
}
myfunc2()
{
   tt2=`date +%S`
   echo "function2 $@ $tt2"

}
timer_init
timer_add 5 myfunc2 I am paramter
timer_add 2 myfunc1 argument
timer_run