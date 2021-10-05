# Database Internals - Alex Petrov

## Part I. Storage Engines

it’s usually much better to use a database that slowly saves the data than one that quickly loses it.

To compare databases, it’s helpful to understand the use case in great detail and define the current and anticipated variables, such as:

- Schema and record sizes

- Number of clients

- Types of queries and access patterns

- Rates of the read and write queries

- Expected changes in any of these variables


Knowing these variables can help to answer the following questions:

- Does the database support the required queries?

- Is this database able to handle the amount of data we’re planning to store?

- How many read and write operations can a single node handle?

- How many nodes should the system have?

- How do we expand the cluster given the expected growth rate?

- What is the maintenance process?


One of the popular tools used for benchmarking, performance evaluation, and comparison is Yahoo! Cloud Serving Benchmark (YCSB).
 YCSB offers a framework and a common set of workloads that can be applied to different data stores

The Transaction Processing Performance Council (TPC) has a set of benchmarks that database vendors use for comparing and advertising performance of their products. 

This doesn’t mean that benchmarks can be used only to compare databases. Benchmarks can be useful to define and test details of the service-level agreement,1 understanding system requirements, capacity planning, and more. The more knowledge you have about the database before using it, the more time you’ll save when running it in production.

Past smooth upgrades do not guarantee that future ones will be as smooth, but complicated upgrades in the past might be a sign that future ones won’t be easy, either.

All storage engines face the same challenges and constraints. To draw a parallel with city planning, it is possible to build a city for a specific population and choose to build up or build out. In both cases, the same number of people will fit into the city, but these approaches lead to radically different lifestyles.


The service-level agreement (or SLA) is a commitment by the service provider about the quality of provided services. Among other things, the SLA can include information about latency, throughput, jitter, and the number and frequency of failures.




