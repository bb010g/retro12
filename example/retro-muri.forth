#!/usr/bin/env retro

# Muri: a Minimalist Assembler for Nga

This is a small assembler used to build the initial image for
RETRO. The implementation here uses the runtime variant included
in the core RETRO system. See the glossary entries for `i`, `d`,
`r`, `as{`, and `}as` for details on these.

The full assembler has a postfix notation. Syntax is:

    <directive> <data>

Directives are a single character. Muri recognizes:

* **i** for instructions
* **d** for numeric data
* **s** for string data
* **:** for creating a label
* **r** for references to labels

Instructions are packed up to four instructions per location.
You can specify them using the first two characters of the
instruction name. For a non operation, use '..' instead of
'no'.

    0  nop        7  jump      14  gt        21  and
    1  lit <v>    8  call      15  fetch     22  or
    2  dup        9  ccall     16  store     23  xor
    3  drop      10  return    17  add       24  shift
    4  swap      11  eq        18  sub       25  zret
    5  push      12  neq       19  mul       26  end
    6  pop       13  lt        20  divmod

E.g., for a sequence of dup, multiply, no-op, drop:

    i dumu..dr

An example of a small program:

    i liju....
    r main
    : square
    i dumure..
    : main
    i lilica..
    d 12
    r square
    i en......

As mentioned earlier this requires knowledge of Nga architecture.
While you can pack up to four instructions per location, you
should not place anything after an instruction that modifies the
instruction pointer. These are: ju, ca, cc, re, and zr.

## Unu

This is documented in *example/retro-unu.forth*, but basically
it provides a combinator that runs a quote for each line in a
file, provided that the lines are in fenced blocks starting and
ending with `~~~`.

The RETRO sources are written in this style, so I include Unu
here to simplify the later workflow.

~~~
{{
  'Fenced var
  :toggle-fence @Fenced not !Fenced ;
  :fenced? (-f) @Fenced ;
  :handle-line (s-)
    fenced? [ over call ] [ drop ] choose ;
---reveal---
  :unu (sq-)
    swap [ dup '~~~ s:eq?
           [ drop toggle-fence ]
           [ handle-line       ] choose
         ] file:for-each-line drop ;
}}
~~~

## Muri

Now for the assembler. I create a couple of data structures: a
buffer for the assembled image and a pointer into this.

~~~
'Image d:create #8192 allot
'AP var
~~~

I then use these to implement `I,`, a word which stores a value
into the image buffer and increment the pointer.

~~~
:I, (n-) &Image @AP + store &AP v:inc ;
~~~

### Pass 1

Muri is a two pass assembler. The first pass handles most of the
work. It processes instrution bundles, data, strings, and creates
labels pointing to specific addresses in the image. References
are compiled as dummy values, to be resolved later.

~~~
'Pass_1:_ s:put
#0 !AP
#0 sys:argv
  [ dup s:length n:zero? [ drop #0 ] if 0;
    fetch-next &n:inc dip
    $i [ i here n:dec fetch I, ] case
    $d [ s:to-number I, ] case
    $r [ drop #-1 I, ] case
    $: [ @AP swap 'muri! s:prepend const ] case
    $s [ &I, s:for-each #0 I, ] case
    'ERROR s:put nl
  ] unu
@AP n:put '_cells s:put nl
~~~

### Pass 2

The second pass skips over everything except references, which
get resolved and filled in. This allows for forward references.

~~~
'Pass_2:_ s:put
#0 !AP
#0 sys:argv
  [ dup s:length n:zero? [ drop #0 ] if 0;
    fetch-next &n:inc dip
    $i [ drop &AP v:inc ] case
    $d [ drop &AP v:inc ] case
    $r [ 'muri! s:prepend d:lookup d:xt fetch I, ] case
    $: [ drop ] case
    $s [ s:length n:inc &AP v:inc-by ] case
    'ERROR s:put nl
  ] unu
@AP n:put '_cells s:put nl
~~~

### Save Image

Saving the image is pretty straightforward. For each cell,
convert to bytes and write them to the output file.

~~~
'FID var

:write-byte (n-)  @FID file:write ;
:mask       (n-)  #255 and ;

:write-cell (n-)
           dup mask write-byte
  #8 shift dup mask write-byte
  #8 shift dup mask write-byte
  #8 shift     mask write-byte ;

:save-image (s-)
  file:W file:open !FID
  &Image @AP [ fetch-next write-cell ] times drop
  @FID file:close ;

'ngaImage save-image
~~~

# Future Directions

Muri is currently a two-pass assembler. It might be interesting
to add additonal passes, one for each item type. This could
allow for some cleaner code and easier additions of new features
in the future. For now this works nicely though, and is simple
and reliable.
