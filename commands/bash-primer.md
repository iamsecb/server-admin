# Shell Parameter Expansion

## % and %% (Remove Suffix)

Syntax:
`${parameter%word}`: This removes the shortest matching word from the end of the parameter's value.
`${parameter%%word}`: This removes the longest matching word from the end of the parameter's value.

Explanation:
parameter: This is the name of the variable whose value you want to modify.
word: This is a pattern or literal string that Bash attempts to match against the end of the parameter's value. Wildcard characters like * can be used in word.


#### Examples

Removing the shortest match.

```
    filename="document.tar.gz"
    echo ${filename%.gz}
```

Output: `document.tar`

In this example, `.gz` is the shortest match at the end of filename, so it is removed. Removing the longest match.

```
    filename="archive.tar.gz"
    echo ${filename%%.*}
```		
Output: `archive`

Here, `.*` matches `.tar.gz` (**the longest match from the end**), so only archive remains. If you used `%.*`, it would only remove `.gz`. Using wildcards.

```
    path="/home/user/documents/report.txt"
    echo ${path%/*}
```		

Output: `/home/user/documents`