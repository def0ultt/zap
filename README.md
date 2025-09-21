
# ParamFuzz

**ZAP**  is a small and fast command-line tool to short, replace and  append values to URL parameters. Perfect for bug bounty hunters, penetration testers, and security researchers.  

---

## Features

- Replace all URL parameter values with a custom string (default: `FUZZ`)  
- Replace only the **first** (`-s`) or **last** (`-f`) parameter value  
- Append a string to parameters instead of replacing (`-a`)  
- Safe for any input, including special characters like `/`, `<`, `>`, `&`  
- Sort all parameters alphabetically in the output  
- Remove duplicate URLs automatically  
- Remove all URLs that do not contain any parameters  
- Simple, short, and fast — perfect for pipelines and fuzzing lists  


---

## Installation

```bash
git clone https://github.com/yourusername/paramfuzz.git
cd paramfuzz
chmod +x zap   # or your script name
````

No additional dependencies required (Bash + standard utilities).

---

## Usage

```bash
cat urls.txt | ./zap [FUZZ_WORD] [OPTIONS]
```

### Options

| Flag        | Description                                                             |
| ----------- | ----------------------------------------------------------------------- |
| `-f`        | Replace **only the last** parameter value                               |
| `-s`        | Replace **only the first** parameter value                              |
| `-a`        | Append FUZZ\_WORD to parameter values instead of replacing              |
| `-h`        | Show help menu                                                          |
| `FUZZ_WORD` | Optional. Default: `FUZZ`. Can be any string including HTML/JS payloads |

---

## Examples

Assume `urls.txt` contains:

```
https://example.com/test.js
https://example.com/test2.css
https://example.com/?id=123&next=home
https://testsite.com/search?q=admin
https://vuln.com/page?post=5
```

**Replace all parameter values with `FUZZ` (default):**

```bash
cat urls.txt | ./zap
```

Output:

```
https://example.com/?id=FUZZ&next=FUZZ
https://testsite.com/search?q=FUZZ
https://vuln.com/page?post=FUZZ
```

**Replace all parameters with a custom word (`TEST`):**

```bash
cat urls.txt | ./zap TEST
```

Output:

```
https://example.com/?id=TEST&next=TEST
https://testsite.com/search?q=TEST
https://vuln.com/page?post=TEST
```

**Append `FUZZ` to all parameter values:**

```bash
cat urls.txt | ./zap -a
```

Output:

```
https://example.com/?id=123FUZZ&next=homeFUZZ
https://testsite.com/search?q=adminFUZZ
https://vuln.com/page?post=5FUZZ
```

**Append `FUZZ` only to the first parameter value:**

```bash
cat urls.txt | ./zap -s -a
```

Output:

```
https://example.com/?id=123FUZZ&next=home
https://testsite.com/search?q=adminFUZZ
https://vuln.com/page?post=5FUZZ
```

**Replace only the last parameter value:**

```bash
cat urls.txt | ./zap -f
```

Output:

```
https://example.com/?id=123&next=FUZZ
https://testsite.com/search?q=FUZZ
https://vuln.com/page?post=FUZZ
```

**Use a JS payload safely:**

```bash
cat urls.txt | ./zap "><script>alert(5)</script>" -a
```

Output:

```
https://example.com/?id=123><script>alert(5)</script>&next=home><script>alert(5)</script>
https://testsite.com/search?q=admin><script>alert(5)</script>
https://vuln.com/page?post=5><script>alert(5)</script>
```


