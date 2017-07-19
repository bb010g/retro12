In prior releases of RETRO, a test suite covered a large portion
of the core language and libraries. RETRO 12 currently does not
have any sigificant automated tests. This is an attempt to fix
this issue.

As with the previous test suite, this assumes that the core
functionality is mostly working. If your VM or Rx core is broken,
don't expect this to be much help.

First, a way to kill RETRO that'll guarantee a resulting error.
We simply divide by zero.

````
:err:die (-) #0 #0 / ;
````

Next, the guts of the test suite. I'll define a block for each
word tested, with some minimal syntax. So a test will look
like:

    'wordname Testing
      [ test code ] [ checks, returning a flag ] try
    passed

Multiple tests can be between the `Testing` and the `passed`.
This will count the number of successful tests.

````
'Total var
'WordsTested var
'Flag var
'Tests var
'InTestState var
:Testing (s-)
  'Test:__ puts puts nl #-1 !Flag #0 !Tests  &WordsTested v:inc reset ;
:passed (-)
  '->_ puts @Tests putn '_tests_passed puts nl
  '----------------------------------- puts nl ;
:exit-on-fail (-)
  @Flag [ passed '->_1_test_failed puts nl err:die ] -if ; 
:match (n-)
  eq? @InTestState and !InTestState ;
:try (qq-)
  #-1 !InTestState
  [ call ] dip call
  depth n:-zero? [ @Flag and !Flag ] if
  @Flag @InTestState and !Flag
  exit-on-fail &Tests v:inc &Total v:inc ;

:summary (-)
  @WordsTested putn '_words_tested puts nl
  @Total putn '_tests_passed puts nl ;
````

And now the tests begin. These should follow the order of the
Glossary to make maintenance and checking of completion easier.

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'- Testing
  [ #2 #1 -        ] [ #1 eq? ] try
  [ #2 #4 #3 - -   ] [ #1 eq? ] try
  [ #1 #2 #1 #9 -  ] [ #-8 match #2 match #1 match ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
', Testing
  [ here #0 , here swap - ] [  #1 eq? ] try
  [ here #12 , fetch      ] [ #12 eq? ] try
  here #1 , #2 , #3 ,
  [ fetch-next swap fetch-next swap fetch ]
  [ #3 eq? swap #2 eq? and swap #1 eq? and ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'; Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'/ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'[ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'] Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'{{ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'}} Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'* Testing
  [  #1  #2 *       ] [ #2 eq?   ] try
  [  #2  #3 *       ] [ #6 eq?   ] try
  [ #-1 #10 *       ] [ #-10 eq? ] try
  [ #-1  #2 * #-1 * ] [ #2 eq?   ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'+ Testing
  [ #1 #2 +  ] [ #3 eq? ] try
  [ #4 #-2 + ] [ #2 eq? ] try
  [ #0 #1 +  ] [ #1 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'0; Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'again Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'allot Testing
  [ here #10 allot here swap -  ] [ #10 eq? ] try
  [ here #-10 allot here - ]      [ #10 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'and Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'as{ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'}as Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:ACK Testing
  [ ASCII:ACK ] [ #6 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:BEL Testing
  [ ASCII:BEL ] [ #7 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:BS Testing
  [ ASCII:BS ] [ #8 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:CAN Testing
  [ ASCII:CAN ] [ #24 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:CR Testing
  [ ASCII:CR ] [ #13 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DC1 Testing
  [ ASCII:DC1 ] [ #17 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DC2 Testing
  [ ASCII:DC2 ] [ #18 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DC3 Testing
  [ ASCII:DC3 ] [ #19 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DC4 Testing
  [ ASCII:DC4 ] [ #20 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DEL Testing
  [ ASCII:DEL ] [ #127 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:DLE Testing
  [ ASCII:DLE ] [ #16 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:EM Testing
  [ ASCII:EM ] [ #25 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:ENQ Testing
  [ ASCII:ENQ ] [ #5 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:EOT Testing
  [ ASCII:EOT ] [ #4 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:ESC Testing
  [ ASCII:ESC ] [ #27 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:ETB Testing
  [ ASCII:ETB ] [ #23 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:ETX Testing
  [ ASCII:ETX ] [ #3 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:FF Testing
  [ ASCII:FF ] [ #12 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:FS Testing
  [ ASCII:FS ] [ #28 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:GS Testing
  [ ASCII:GS ] [ #29 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:HT Testing
  [ ASCII:HT ] [ #9 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:LF Testing
  [ ASCII:LF ] [ #10 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:NAK Testing
  [ ASCII:NAK ] [ #21 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:NUL Testing
  [ ASCII:NUL ] [ #0 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:RS Testing
  [ ASCII:RS ] [ #30 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SI Testing
  [ ASCII:SI ] [ #15 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SO Testing
  [ ASCII:SO ] [ #14 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SOH Testing
  [ ASCII:SOH ] [ #1 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SPACE Testing
  [ ASCII:SPACE ] [ #32 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:STX Testing
  [ ASCII:STX ] [ #2 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SUB Testing
  [ ASCII:SUB ] [ #26 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:SYN Testing
  [ ASCII:SYN ] [ #22 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:US Testing
  [ ASCII:US ] [ #31 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ASCII:VT Testing
  [ ASCII:VT ] [ #11 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'bi Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'bi@ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'bi* Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:add Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:empty Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:end Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:get Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:preserve Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:set Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:size Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'buffer:start Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'call Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'case Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-consonant? Testing
  [ $a ] [ c:-consonant? ] try 
  [ $b ] [ c:-consonant? not ] try 
  [ $c ] [ c:-consonant? not ] try 
  [ $d ] [ c:-consonant? not ] try 
  [ $e ] [ c:-consonant? ] try 
  [ $f ] [ c:-consonant? not ] try 
  [ $g ] [ c:-consonant? not ] try 
  [ $h ] [ c:-consonant? not ] try 
  [ $i ] [ c:-consonant? ] try 
  [ $j ] [ c:-consonant? not ] try 
  [ $k ] [ c:-consonant? not ] try 
  [ $l ] [ c:-consonant? not ] try 
  [ $m ] [ c:-consonant? not ] try 
  [ $n ] [ c:-consonant? not ] try 
  [ $o ] [ c:-consonant? ] try 
  [ $p ] [ c:-consonant? not ] try 
  [ $q ] [ c:-consonant? not ] try 
  [ $r ] [ c:-consonant? not ] try 
  [ $s ] [ c:-consonant? not ] try 
  [ $t ] [ c:-consonant? not ] try 
  [ $u ] [ c:-consonant? ] try 
  [ $v ] [ c:-consonant? not ] try 
  [ $w ] [ c:-consonant? not ] try 
  [ $x ] [ c:-consonant? not ] try 
  [ $y ] [ c:-consonant? not ] try 
  [ $z ] [ c:-consonant? not ] try 
passed
````


-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:consonant? Testing
  [ $a ] [ c:consonant? not ] try 
  [ $b ] [ c:consonant? ] try 
  [ $c ] [ c:consonant? ] try 
  [ $d ] [ c:consonant? ] try 
  [ $e ] [ c:consonant? not ] try 
  [ $f ] [ c:consonant? ] try 
  [ $g ] [ c:consonant? ] try 
  [ $h ] [ c:consonant? ] try 
  [ $i ] [ c:consonant? not ] try 
  [ $j ] [ c:consonant? ] try 
  [ $k ] [ c:consonant? ] try 
  [ $l ] [ c:consonant? ] try 
  [ $m ] [ c:consonant? ] try 
  [ $n ] [ c:consonant? ] try 
  [ $o ] [ c:consonant? not ] try 
  [ $p ] [ c:consonant? ] try 
  [ $q ] [ c:consonant? ] try 
  [ $r ] [ c:consonant? ] try 
  [ $s ] [ c:consonant? ] try 
  [ $t ] [ c:consonant? ] try 
  [ $u ] [ c:consonant? not ] try 
  [ $v ] [ c:consonant? ] try 
  [ $w ] [ c:consonant? ] try 
  [ $x ] [ c:consonant? ] try 
  [ $y ] [ c:consonant? ] try 
  [ $z ] [ c:consonant? ] try 
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-digit? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:digit? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'choose Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'class:data Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'class:macro Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'class:primitive Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'class:word Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:letter? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-lowercase? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:lowercase? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'compile:call Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'compile:jump Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'compile:lit Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'Compiler Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'compile:ret Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'compiling? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'const Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'copy Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:toggle-case Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:to-lower Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:to-string Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:to-upper Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-uppercase? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:uppercase? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'curry Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-visible? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:visible? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-vowel? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:vowel? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:-whitespace? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'c:whitespace? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:add-header Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'data Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:class Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:create Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'depth Testing
  [ depth       ] [ #0 eq? ] try
  [ #1 depth    ] [ #1 eq? reset ] try
  [ #1 #2 depth ] [ #2 eq? reset ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:for-each Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'Dictionary Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'dip Testing
  [ #1 #2 [ #3 + ] dip ] [ #2 match #4 match ] try
  [ #0 #1 #2 [ [ #3 + ] dip ] dip ] [ #2 match #1 match #3 match ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:last Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:last<class> Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:last<name> Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:last<xt> Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:link Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:lookup Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:name Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'does Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'drop Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'drop-pair Testing
  [ #1 #2 #3 drop-pair ] [ #1 eq? ] try
  [ #1 #2 drop-pair ] [ depth n:zero? ] try
  [ #1 #2 #3 drop-pair ] [ depth n:-zero? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'dup Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'?dup Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'dup-pair Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'd:xt Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'EOM Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'-eq? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'eq? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'err:notfound Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'FALSE Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'fetch Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'fetch-next Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'gt? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'gteq? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'Heap Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'here Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'i Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'if Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'-if Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'immediate Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'interpret Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'lt? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'lteq? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'mod Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'/mod Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:abs Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:between? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:dec Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:even? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:inc Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'nip Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'nl Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:limit Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:max Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:MAX Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:min Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:MIN Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:negate Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:negative? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:odd? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'not Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:positive? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:pow Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:sqrt Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:square Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:strictly-positive? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:to-string Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:-zero? Testing
  [ #1 n:-zero? ] [ #-1 eq? ] try
  [ #0 n:-zero? ] [ #0 eq? ] try
  [ #-1 n:-zero? ] [ #-1 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'n:zero? Testing
  [ #1 n:zero? ] [ #0 eq? ] try
  [ #0 n:zero? ] [ #-1 eq? ] try
  [ #-1 n:zero? ] [ #0 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'or Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'over Testing
  [ #1 #2 over ] [ #1 match #2 match #1 match ] try
  [ #1 #2 #3 over ] [ #2 match #3 match #2 match #1 match ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'pop Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:` Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:: Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:! Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:' Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:( Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:@ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:$ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:& Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'prefix:# Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'push Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'putc Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'putn Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'puts Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'r Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'reclass Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'reorder Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'repeat Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'reset Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'---reveal--- Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'RewriteUnderscores Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'rot Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's, Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:append Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:case Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:chop Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:contains-char? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:contains-string? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'ScopeList Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:empty Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:contains? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:contains-string? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:dup Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:filter Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:from-results Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:from-string Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:for-each Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:length Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:map Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:nth Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'set:reverse Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:eq? Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:filter Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:for-each Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:hash Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'shift Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:index-of Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'sip Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:keep Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:left Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:length Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:map Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'sp Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:prepend Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:reverse Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:right Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:skip Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:split Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:substr Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:temp Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:to-lower Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:to-number Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'store Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'store-next Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:to-upper Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:trim Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:trim-left Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:trim-right Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'STRINGS Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'swap Testing
  [ #1 #2 #3 swap ] [ #2 match #3 match #1 match ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
's:with-format Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tab Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'TempStringMax Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'TempStrings Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'times Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tors Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tri Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tri@ Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tri* Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'TRUE Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'tuck Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'until Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'var Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'var<n> Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:dec Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:dec-by Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'Version Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:inc Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:inc-by Testing
  'TestA var
  [ #10 &TestA v:inc-by ] [ @TestA #10 eq? ] try
  [ #10 &TestA v:inc-by ] [ @TestA #20 eq? ] try
  [ #10 &TestA v:inc-by ] [ @TestA #30 eq? ] try
  [ #-20 &TestA v:inc-by ] [ @TestA #10 eq? ] try
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:limit Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:off Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:on Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:preserve Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'v:update-using Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'while Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'words Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
'xor Testing
passed
````

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

````
summary
````