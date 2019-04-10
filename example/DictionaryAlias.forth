The easiest way to make an alias is by

:s2 s1 ;

which adds a layer of `call`.
`d:alias` eliminates this overhead.

~~~
{{
  :d:<aka> (as-)_also_known_as
    d:create &class:word reclass d:last d:xt swap d:xt fetch swap store ;
---reveal---
  :d:aka (s-)_make_alias_of_the_last_defined_word [ d:last ] dip d:<aka> ;
  'aka d:aka
  :d:alias (ss-)_make_alias_s2_of_s1 [ d:lookup ] dip d:<aka> ; 'alias aka
}}
~~~

```
:t #8 + ; 'tt aka
#9 tt
't 'ttt alias
#10 ttt
```
