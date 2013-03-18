#Simulation: TokenBucket
#Define the value of queue
set q 10000

set ns [new Simulator]
set nf [open out.nam w]
set tr [open out.tr w]
set pk [open pk.dat w]
set queuelength [open queuelength.tr w]
set arrivaltime [open arrival.tr w]
set prop_pk [open prop.tr w]
set time [$ns now]
set cont 0
#initialization of the variable in order to prevent warning TBF::debug_
TBF set debug_ false; 

set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set link [$ns simplex-link $node1 $node2 2bps 100ms DropTail]
set link2 [$ns simplex-link $node2 $node3 2bps 100ms DropTail]
set qu [$link queue]
$qu set limit_ $q

# array of packet arrivals
set lambda(0) 1.0
set lambda(1) 10.0
set lambda(2) 15.0
set lambda(3) 20.0
set lambda(4) 25.0
set lambda(5) 30.0
set lambda(6) 35.0
set lambda(7) 40.0
set lambda(8) 45.0
set lambda(9) 50.0

# open a queue trace file
set tFile [open queue.tr w]
set qm [open qm.tr w]

#Definition of Agents (UDP for src (attached to node 1) y src2 (attached to node 3) and the TBF (attached to node 2) )
set src [new Agent/UDP]
$src set fid_ 0
$ns attach-agent $node1 $src
set qmon [$ns monitor-queue $node2 $node3 0.1]

$ns color 0 red
$ns color 1 blue
$ns simplex-link-op $node1 $node2 queuePos 0.5
$ns simplex-link-op $node2 $node3 queuePos 0.5

set number 0; #initialization of the variables for the computing of the mean queue length
set sum 0
for {set index 0} {$index<10} {incr index } {
set qlength_totaltime($index) 0
}

set sink [new Agent/Null]
$ns attach-agent $node2 $sink
$ns connect $src $sink

set src2 [new Agent/UDP]
$src2 set fid_ 1
$ns attach-agent $node2 $src2

set tbf [new TBF]
#bucket capacity bits
$tbf set bucket_ 10000
#token bucket rate bits/sec, token arrival rate lambda t
$tbf set rate_ 300
set lnk [[$ns link $node2 $node3] set link_]
$tbf target [$lnk target]
$lnk target $tbf

set shaper [new TBF]
$shaper set bucket_ 10000 ;#bits
$shaper set rate_ 300 ;#bits/s
$ns attach-tbf-agent $node2 $src2 $shaper

set sink2 [new Agent/Null]
$ns attach-agent $node3 $sink2
$ns connect $src2 $sink2

set rng [new RNG]
$rng seed 0
$ns namtrace-all $nf
set expo1 [new RandomVariable/Exponential]
set expo2 [new RandomVariable/Exponential]

proc generationlambda {var} {
global cont mu ns expo1 expo2

$expo1 set avg_ [expr 1/$var]

$expo2 set avg_ [expr 1000/$mu]
$ns at 0.00001 "sendpacket $expo1 $expo2"
}

proc finish {} {
global ns number nf \
tr tFile pk qm \
queue_record maximum_queue prop_pk queuelength arrivaltime
$ns flush-trace
close $queuelength
close $arrivaltime
close $nf
close $tr
close $tFile
close $pk
close $qm
close $prop_pk
# exec nam out.nam
exec xgraph queuelength.tr -geometry 800x400 &
exec xgraph arrival.tr -geometry 800x400 &
exit 0
}

proc sendpacket {expo1 expo2} {
global ns ak number src pk qmon qm link queue_record queuelength sum src2 arrivaltime cont
set then [$ns now]
#packetsize defined by expo2
set nextbytes [expr round ([$expo2 value])]
#interarrival time defined by expo1
$ns at [expr $then + [$expo1 value]] "sendpacket $expo1 $expo2"
set bytes $nextbytes
puts $pk "$then $bytes"
puts $qm "$then [$qmon set pkts_]"
set qlength [$qmon set pkts_]
set sum [expr $sum + $qlength]
set number [expr $number + 1]
if {$then == 200} {
qlength_totaltime($cont)= [expr 1.0*$sum/$number]
puts $queuelength "$lambda($cont) qlength_totaltime($cont)"
}
set qlength_totaltime [expr 1.0*$sum/$number]
$src send $bytes
$ns at [expr $then + [expr 1/[expr 2]]] "$src2 send $bytes"
}

$ns monitor-queue $node2 $node3 $tFile
# sampleInterval is optional and defaults to 0.1 seconds

# start tracing using either
[$ns link $node2 $node3] start-tracing
# or
# [$ns link $node2 $node3] queue-sample-timeout
# which averages over the last sampleInterval

if {$cont == 0} {
$ns at 0 "generationlambda $lambda(0)"
}
if {$time == 200} {
$ns halt
set cont [expr $cont + 1]
if {$cont <= 9} {
$ns run
$ns at $time "generationlambda $lambda($cont)"
}
}
puts "Token bucket simulation..."
$ns run
if {$cont==10} {
$ns at 200 "finish"
}

