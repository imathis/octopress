### Additional options:

These options don't depend on any previous option and order does not matter.

{% if show-range %}
- `start:#` - Render a snippet from the file beginning at the specified line.
- `end:#` - Render a snippet from the file ending at the specified line.
- `range:#-#` - Render a specified range of lines from a file (a shortcut for start:# end:#).
- `mark:#,#-#` - Mark one or more lines of code with the class name "marked". Accepts one number, numbers separated by commas, and number ranges. Example `mark:1,5-8` will mark lines 1,5,6,7,8. Note: If you've changed the beginning line number be sure these match rendered line numbers 
- `linenos:false` - Do not add line numbers to highlighted code.
{% else %}
- `start:#` - Line numbers begin at # (useful for using snippets to reference longer code).
- `mark:#,#-#` - Mark one or more lines of code with the class name "marked". Accepts one number, numbers separated by commas, and number ranges. Example `mark:1,5-8` will mark lines 1,5,6,7,8. Note: If you've changed the beginning line number be sure these match rendered line numbers 
- `linenos:false` - Do not add line numbers to highlighted code.
{% endif %}
