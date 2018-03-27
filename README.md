# JSONShootout

Performance measurement for JSON encoder/decoders.

This is a rough test.  Three runs were done for each library on the same machine around the same time.  Still there was
some observed variability in the results on the order of up to %30.  A more controlled experiment involving many more runs 
and more variance in the data used for the test is necessary for real performance benchmarks. 

Most test data from: http://www.json-generator.com.

Several json files are available for test by using the option ```--json-file"res/test.json"```.

By default it uses the 8.1M  ```res/big.json``

### Usage

TODO

## Results

When profiling, output of fprof files goes into with understandable names ```.fprof```

When benchmarking, result times in milliseconds. Blue is Encode, Green is Decode.

Results are taken from running all encoders multiple times on the same machine in the same time period, under latest production Elixir 1.6.

