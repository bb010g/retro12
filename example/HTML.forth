# HTML Generation

This is a little experiment in combinator-driven HTML generation.

~~~
:a:href (ss-)  '<a_href=" s:put s:put '"> s:put s:put '</a> s:put ;
:p      (q-)   '<p>       s:put call  '</p>      s:put nl ;
:strong (q-)   '<strong>  s:put call  '</strong> s:put nl ;
:em     (q-)   '<em>      s:put call  '</em>     s:put nl ;
:h1     (s-)   '<h1>      s:put s:put '</h1>     s:put nl ;
:div    (q-)   '<div>     s:put call  '</div>    s:put nl ;
:body   (q-)   '<body>    s:put call  '</body>   s:put nl ;
:prefix:"      s:keep &s:put compile:call ; immediate
~~~

Test case:

```
[ 'Hello h1
  [ "This_is_a_test_of_HTML_generation._Please_
    'follow_the_link 'page2.html a:href ". ] p
  [ "This_is_a_second_paragraph ] p
] body
```
