sandbox@playground:~$ echo "Hello Dosto, We are here to practice Linux Commands for day-04"
Hello Dosto, We are here to practice Linux Commands for day-04


sandbox@playground:~$ ps aux| grep bash
sandbox        1  0.0  0.0   4628  3680 pts/0    Ss+  15:25   0:00 /bin/bash
sandbox       13  0.0  0.0   4628  3856 pts/1    Ss   15:25   0:00 /bin/bash
sandbox       31  0.0  0.0   3472  1516 pts/1    S+   15:28   0:00 grep --color=auto bash
|
sandbox@playground:~$ top -b -n 1 
top - 15:28:48 up 4 days,  3:49,  0 users,  load average: 0.05, 0.11, 0.04
Tasks:   3 total,   1 running,   2 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.8 us,  0.0 sy,  0.0 ni, 99.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  32096.1 total,  30018.6 free,    763.2 used,   1314.3 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.  30935.1 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
      1 sandbox   20   0    4628   3680   3224 S   0.0   0.0   0:00.02 bash
     13 sandbox   20   0    4628   3860   3252 S   0.0   0.0   0:00.02 bash
     32 sandbox   20   0    7184   2876   2544 R   0.0   0.0   0:00.00 top


sandbox@playground:~$ jobs
sandbox@playground:~$ pgrep bash
1
13


