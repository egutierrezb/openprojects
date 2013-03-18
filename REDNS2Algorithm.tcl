set ns          [new Simulator]
$ns             use-scheduler Heap
set rtg         [new RNG]
 
set R0 [$ns node]
set R1 [$ns node]
Queue/RED set suma_ 0
Queue/RED set cont_ 0

#configure the link 
$ns duplex-link $R0  $R1  16Mb 16ms RED

# get the handle 
global mylink
set  mylink  [$ns link $R0 $R1]   ;#forward link.
#play with the handle. 
 
proc print { } {
 global ns mylink
    set delay [$mylink delay]
    set bw [$mylink bw]
    puts "$delay  $bw"
 
}
proc change {} {
 global ns mylink R0 R1
 $ns duplex-link $R0  $R1  12Mb 12ms RED
 set  mylink2 [$ns link $R0 $R1]
 set delay2 [$mylink2 delay]
 set bw2 [$mylink2 bw]
 puts "$delay2 $bw2"
}

$ns at 5.0 "print"
#$ns at 10.0 "$mylink set delay_ 16ms"   
#$ns at 10.0 "$mylink set bw_ 16M"     
$ns at 10.0 "change"
$ns at 10.5 "print"
$ns at 11.0 "$ns duplex-link $R0  $R1  12Mb 12ms RED"
$ns at 15.0 "print"
$ns at 20.0 "$ns halt"
$ns run
