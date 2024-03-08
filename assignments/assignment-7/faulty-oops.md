# Analysis of faulty device driver
Author: Hector Redal

## First step: Executing the command 'echo "Hello world" > /dev/faulty'
When runnning the command 'echo "Hello world" > /dev/faulty', the virtual image get stuck and even restarts (reloads), as it can be seen in the following printout:

> echo “hello_world” > /dev/faulty <br>
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000 <br>
> Mem abort info: <br>
>   ESR = 0x96000045 <br>
>   Exception class = DABT (current EL), IL = 32 bits <br>
>  SET = 0, FnV = 0 <br>
>  EA = 0, S1PTW = 0 <br>
>  Data abort info: <br>
>   ISV = 0, ISS = 0x00000045 <br>
>   CM = 0, WnR = 1 <br>
> user pgtable: 4k pages, 39-bit VAs, pgdp = 000000003072c1bc <br>
> [0000000000000000] pgd=0000000000000000, pud=0000000000000000 <br>
> Internal error: Oops: 96000045 [#1] SMP <br>
> Modules linked in: hello(O) faulty(O) scull(O) <br>
> Process sh (pid: 159, stack limit = 0x00000000bdd85dba) <br>
> CPU: 0 PID: 159 Comm: sh Tainted: G           O      5.1.10 #1 <br>
> Hardware name: linux,dummy-virt (DT) <br>
> pstate: 80000005 (Nzcv daif -PAN -UAO) <br>
> pc : faulty_write+0x8/0x10 [faulty] <br>
> lr : __vfs_write+0x18/0x40 <br>
> sp : ffffff8010b23dd0 <br>
> x29: ffffff8010b23dd0 x28: ffffffc006ae55c0  <br>
> x27: 0000000000000000 x26: 0000000000000000  <br>
> x25: 0000000056000000 x24: 0000000000000015  <br>
> x23: 0000000000000000 x22: ffffff8010b23e50  <br>
> x21: 00000055782fcb20 x20: ffffffc0055da300  <br>
> x19: 0000000000000012 x18: 0000000000000000  <br>
> x17: 0000000000000000 x16: 0000000000000000  <br>
> x15: 0000000000000000 x14: 0000000000000000  <br>
> x13: 0000000000000000 x12: 0000000000000000  <br>
> x11: 0000000000000000 x10: 0000000000000000  <br>
> x9 : 0000000000000000 x8 : 0000000000000000  <br>
> x7 : 0000000000000000 x6 : 0000000000000000  <br>
> x5 : ffffff80086ad000 x4 : ffffff80086ab000  <br>
> x3 : ffffff8010b23e50 x2 : 0000000000000012  <br>
> x1 : 0000000000000000 x0 : 0000000000000000  <br>
> Call trace: <br>
>  faulty_write+0x8/0x10 [faulty] <br>
>  vfs_write+0xa4/0x1a0 <br>
>  ksys_write+0x60/0xe0 <br>
>  __arm64_sys_write+0x18/0x20 <br>
>  el0_svc_common.constprop.0+0x68/0x160 <br>
>  el0_svc_handler+0x60/0x80 <br>
>  el0_svc+0x8/0xc <br>
> Code: bad PC value <br>
> ---[ end trace 62c136c4ca6ab520 ]--- <br>
> <br>
> Welcome to Buildroot <br>
> buildroot login: <br>


## Second Step: Analysis of what happended
The conclusion I came to is that sending a very simple text string to the faulty driver has caused a buffer oveflow (this is equivalent to the NULL pointer deference). So, it is of paramount importance analyzing the call stack, and checking the implementation of the last function called.

The last function called is faulty_write. So this is the culprit for hanging the virtual image.
Let's take a look at the code of this function in the faulty.c file:

> ssize_t faulty_write (struct file *filp, const char __user *buf, size_t count,
> 		loff_t *pos) <br>
> { <br>
> 	/* make a simple fault by dereferencing a NULL pointer */ <br>
> 	*(int *)0 = 0; <br>
> 	return 0; <br>
> } <br>

It is blatantly obvious that this function has been design intentionally to malfunction and even crash the system.
Assigning a value to address 0x0 is not allowed by any processor. That's the reason writing to the faulty driver crashes the system.