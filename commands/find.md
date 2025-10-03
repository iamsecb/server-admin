# Find Command Cheat Sheet

### Find empty files or directories

```
find . -type f -empty
find . -type d -empty
```

### Find files by permissions

```
find . -type f -perm 600
find . -type f ! -perm 644
```

### Find files modified within the last N minutes/hours

```
find . -mmin -30
find . -mtime -1
```

### Find files by size

```
find . -size +100M
find . -size -10k
```


### Delete files interactively

```
find . -name "*.tmp" -ok rm {} \;
```

### Find and execute a command on files in batches (faster)

```
find . -name "*.log" -exec grep "ERROR" {} +
```

### Find files and print their detailed info

```
find . -type f -exec ls -lh {} +
```

### Find files and print their relative path from a directory (GNU find)

```
find . -type f -printf '%P\n'
```

### Find files and change their ownership

```
find . -type f -user olduser -exec chown newuser {} +
```

### Find broken symlinks

```
find . -xtype
```

### Find and replace 


```
# Find files with 'txt' extension and rename them to 'tf' extension in all subdirectories
# % shell expansion for shortest suffix match is used to remove .txt and add .tf

find . -type f -name '*.txt' -exec sh -c 'mv "$0" "${0%.txt}.tf"' {} \;
```