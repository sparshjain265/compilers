# A terminal syntax high lighter for Standard ML.

In this assignment, you will be designing a syntax highlighter for
SML.  The task is the following: Your input is a sml program and you
need to highlight the different tokens in the program, like keyword,
comments etc and print it on the terminal.


1. Write a data type `Token` for tokens in SML.

2. Using `ml-lex` write a lexer for SML that returns the tokens. Be
   careful to have a way to preserve spaces. The best way is for your
   lexer to return a tuple of `Token * position` where position itself
   is `line * column`

3. Assume that your terminal is ANSI and use the ANSI codes for
   colouring, underlineing etc.  You can set the colours using the ESC
   [ followed by some command. For example, to set the forground to
   red you need to output the string sequence `ESC[31m` where ESC is
   the escape character (ascii 27). You can use the `chr : int ->
   char` to convert from ascii code to the corresponding
   character. See the section on [Select Graphic Rendition][sgr] in
   the Wikipedia entry for [ANSI escape code][ansi-codes]

The lexical grammar for SML is given in
<https://people.mpi-sws.org/~rossberg/sml.html>. You can start with a
small subset of it and extend it slowly. Also for time being you can
assume no nested comments are allowed (What would happend if we allow
it?)


[sgr]: <https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters>
[ansi-codes]: <https://en.wikipedia.org/wiki/ANSI_escape_code>
