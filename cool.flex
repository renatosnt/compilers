/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */
/*
   The two statements below are here just so this program will compile.
   You may need to change or remove them on your final code.
*/
#define yywrap() 1
#define YY_SKIP_YYWRAP

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
  int commentCount = 0;
  int strLen = 0;
%}

/*
 * Define names for regular expressions here.
 */


%x STRING
%x COMMENT
%x LINE_COMMENT

DARROW          =>
LE          <=
ASSIGN          <-


ALPHANUM        [a-zA-Z0-9_]
INT             [0-9]+
TYPE            [A-Z]{ALPHANUM}*
OBJECT          [a-z]{ALPHANUM}*

%%


/*Comments*/
--[.]* 

/*Nested Comments*/

"*)" {
  setError("Unmatched *)");
  return ERROR;
}

"(*" {
  commentCount++;
  BEGIN(COMMENT);
}

<COMMENT>"(*" {
  commentCount++;
}

<COMMENT>"*)" {
  commentCount--;
  if (commentCount == 0) { BEGIN(0); }
}

<COMMENT>. {}

<COMMENT>\n {curr_lineno++}

<COMMENT><<EOF>> {
  setError("EOF in comment");
  BEGIN(0);
  commentCount = 0;
  return ERROR;
}

/* SINGLE LINE COMMENTS */

"--"  { BEGIN(LINE_COMMENT) }

<LINE_COMMENT>. {}

<LINE_COMMENT>\n {
  curr_lineno++;
  BEGIN(INITIAL);
}


/*Integers*/
{INT} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
} 

/* Multiple characters operators */

{DARROW}		{ return (DARROW); }

{LE}        { return (LE);     }

{ASSIGN}    { return (ASSIGN); }

"+" { return '+'; }
"/" { return '/'; }
"-" { return '-'; }
"*" { return '*'; }
"=" { return '='; }
"<" { return '<'; }
"." { return '.'; }
"~" { return '~'; }
"," { return ','; }
";" { return ';'; }
":" { return ':'; }
"(" { return '('; }
")" { return ')'; }
"@" { return '@'; }
"{" { return '{'; }
"}" { return '}'; }


/*
* Keywords are case-insensitive except for the values true and false,
* which must begin with a lower-case letter.
*/
()

(?i:class) { return (CLASS); }
(?i:else) { return (else); }
(?i:fi) { return (FI); }
(?i:if) { return (IF); }
(?i:in) { return (IN); }
(?i:inherits) { return (INHERITS); }
(?i:let) { return (LET); }
(?i:loop) { return (LOOP); }
(?i:pool) { return (POOL); }
(?i:then) { return (THEN); }
(?i:while) { return (WHILE); }
(?i:case) { return (CASE); }
(?i:esac) { return (ESAC); }
(?i:of) { return (OF); }
(?i:new) { return (NEW); }
(?i:not) { return (NOT); }
(?i:isvoid) { return (ISVOID); }

/* case sensitive keywords*/
t(?i:rue) {
  cool_yylval.boolean = true;
  return (BOOL_CONST);
}
f(?i:alse) {
  cool_yylval.boolean = false;
  return(BOOL_CONST);
}


/* Identifiers */

{TYPE} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}

{OBJECT}|(self) {
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}


/*
*  String constants (C syntax)
*  Escape sequence \c is accepted for all characters c. Except for 
*  \n \t \b \f, the result is c.
*
*/

\" {
  BEGIN(STRING);
  strLen = 0;
}

<STRING>\" {
  cool_yylval.symbol = stringtable.add_string(string_buf);
  string_buf[0] = '\0';
  BEGIN(INITIAL);
  return STR_CONST;
}

<STRING>\0 {
  setError("String contains null character");
  string_buf[0] = '\0';
  return ERROR;
}

<STRING>\n {
  setError("Unterminated string constant");
  string_buf[0] = '\0';
  curr_lineno++;
  BEGIN(INITIAL);
  return ERROR;
}

/* escaped characters */

<STRING>\\f {
  if(isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, "\f");  
}

<STRING>\\\n {
  if(isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, "\n");  
}

<STRING>\\t {
  if(isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, "\t");  
}

<STRING>\\b {
  if(isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, "\b");  
}


<STRING>\\. {
  if(isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, &strdup(yytext)[1]);  
}

/*                     */
<STRING><<EOF>> {
  setError("EOF in string constant");
  curr_lineno++;
  BEGIN(INITIAL);
  return ERROR;
}

<STRING>. {
  if (isStringTooLong()) {
    return strLenghtError();
  }
  strLen++;
  strcat(string_buf, yytext);
}



\n { curr_lineno++ }

. {
  setError(yytext);
  return ERROR;
}



%%

/*
  lexemes: lval

*/

void setError(char *msg) {
  cool_yylval.error_msg = msg;
}

bool isStringTooLong() {
  if (strLen + 1 >= MAX_STR_CONST) {
    return true;
  }
  return false;
}

int strLenghtError() {
  string_buf[0] = '\0';
  setError("String constant too long");
  return ERROR;
}


