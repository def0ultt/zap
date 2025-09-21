# Manipulate & Extract Parameters – **zap**

**zap** is a small and fast command-line tool to replace, append, list, or extract URL parameter names and values. Perfect for bug bounty hunters, penetration testers, and security researchers.

---

### Features

* Replace all URL parameter values with a custom string (default: `FUZZ`)
* Replace only the first (`-s`) or last (`-f`) parameter value
* Append a string to parameters instead of replacing (`-a`)
* **Extract all parameter names from URLs (`-e`)**
* Safe for any input, including special characters like `/`, `<`, `>`, `&`
* Sort all parameters alphabetically in the output
* Remove duplicate URLs automatically
* Remove all URLs that do not contain any parameters
* Simple, short, and fast — perfect for pipelines and fuzzing lists

---

### Installation

```bash
git clone https://github.com/def0ultt/zap
chmod +x zap   
```

No additional dependencies required (Bash + standard utilities).

---

### Usage

```bash
cat urls.txt | ./zap [FUZZ_WORD] [OPTIONS]
```

---

### Options

| Flag | Description                                                |
| ---- | ---------------------------------------------------------- |
| `-f` | Replace only the last parameter value                      |
| `-s` | Replace only the first parameter value                     |
| `-a` | Append FUZZ\_WORD to parameter values instead of replacing |
| `-e` | **Extract all parameter names from URLs**                  |
| `-h` | Show help menu                                             |

**FUZZ\_WORD** Optional. Default: `FUZZ`. Can be any string including HTML/JS payloads.

---

### Examples

Assume `urls.txt` contains:

```
https://example.com/?id=123&next=home
https://testsite.com/search?q=admin
https://vuln.com/page?post=5
```

---

**Replace all parameter values with FUZZ (default):**

```bash
cat urls.txt | ./zap
```

Output:

```
https://example.com/?id=FUZZ&next=FUZZ
https://testsite.com/search?q=FUZZ
https://vuln.com/page?post=FUZZ
```

---

**Replace all parameters with a custom word (TEST):**

```bash
cat urls.txt | ./zap TEST
```

Output:

```
https://example.com/?id=TEST&next=TEST
https://testsite.com/search?q=TEST
https://vuln.com/page?post=TEST
```

---

**Append FUZZ to all parameter values (`-a`):**

```bash
cat urls.txt | ./zap -a
```

Output:

```
https://example.com/?id=123FUZZ&next=homeFUZZ
https://testsite.com/search?q=adminFUZZ
https://vuln.com/page?post=5FUZZ
```

---

**Append FUZZ only to the first parameter value (`-s -a`):**

```bash
cat urls.txt | ./zap -s -a
```

Output:

```
https://example.com/?id=123FUZZ&next=home
https://testsite.com/search?q=adminFUZZ
https://vuln.com/page?post=5FUZZ
```

---

**Replace only the last parameter value (`-f`):**

```bash
cat urls.txt | ./zap -f
```

Output:

```
https://example.com/?id=123&next=FUZZ
https://testsite.com/search?q=FUZZ
https://vuln.com/page?post=FUZZ
```

---

**Extract only parameter names (`-e`):**

```bash
cat urls.txt | ./zap -e
```

Output:

```
id
next
q
post
```



