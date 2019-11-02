# SuperscalarPipeline
A Superscalar, Out-of-order Pipeline loosely based on the RISC-V ISA implemented in SystemVerilog.  

Superscalar out-of-order execution has become the norm in modern processors. Yet there is little information in the literature about its implementation details. This thesis explores what new hardware structures superscalar outof-order execution requires. It presents a design for a simple processor, implemented in SystemVerilog, that uses register renaming, reservation stations and a reorder buffer to dynamically schedule instructions.  
The thesis also contains an essay that explains why power limitations have caused processor clock rates to stagnate in the noughties. This resulted in heightened pressure on computer architects to increase instruction throughput per cycle.  


![Pipeline](pipeline.png)
