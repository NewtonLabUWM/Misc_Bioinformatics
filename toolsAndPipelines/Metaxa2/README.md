### Assembled/long reads/contigs

Pros: more, potential full length information to mine from

Cons: sequence length limit -

```
Fatal exception (source file p7_pipeline.c, line 697):
Target sequence length > 100K, over comparison pipeline limit.
(Did you mean to use nhmmer/nhmmscan?)
```


### Unassembled/short read/raw

Pros: no sequence length limit

Cons: less full length information, potential fragmented genes



I ended up using both and comparing (shrug)
