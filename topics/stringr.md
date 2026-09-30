### stringr

<details>
<summary>Detecting &amp; matching</summary>

#### str_detect()
use case: TRUE/FALSE for whether a pattern appears in each string

```r
str_detect(colname, "pattern")
str_detect(colname, "^prefix")   # anchored to the start
str_detect(colname, "suffix$")   # anchored to the end
```

#### str_subset()
use case: keep only the elements of a vector that match a pattern

```r
str_subset(vec, "pattern")
```

#### str_count()
use case: count how many times a pattern occurs in each string

```r
str_count(colname, "pattern")
```

</details>

<details>
<summary>Extracting &amp; replacing</summary>

#### str_extract()
use case: pull out the first match of a pattern

```r
str_extract(colname, "[0-9]+")
```

#### str_replace() / str_replace_all()
use case: swap the first (or every) match for something else

```r
str_replace(colname, "old", "new")      # first match only
str_replace_all(colname, "old", "new")  # every match
```

#### str_remove() / str_remove_all()
use case: delete a matched pattern instead of replacing it

```r
str_remove_all(colname, "[^0-9]")  # strip everything but digits
```

</details>

<details>
<summary>Cleaning &amp; formatting</summary>

#### str_trim() / str_squish()
use case: drop leading/trailing whitespace (str_squish also collapses
internal whitespace to single spaces)

```r
str_trim(colname)
str_squish(colname)
```

#### str_to_lower() / str_to_upper() / str_to_title()
use case: normalize casing

```r
str_to_lower(colname)
str_to_title(colname)  # "jane doe" -> "Jane Doe"
```

#### str_pad()
use case: pad a string to a fixed width, e.g. zero-padding IDs

```r
str_pad(colname, width = 5, side = "left", pad = "0")
```

</details>

<details>
<summary>Splitting &amp; joining</summary>

#### str_split()
use case: split each string into pieces on a delimiter

```r
str_split(colname, ",")
str_split(colname, ",", simplify = TRUE)  # returns a matrix instead of a list
```

#### str_c()
use case: concatenate strings (vectorized paste, with a `sep` argument)

```r
str_c(first_name, last_name, sep = " ")
str_c("prefix_", colname)
```

#### str_glue()
use case: build a string with inline `{variable}` interpolation

```r
str_glue("{first_name} {last_name} is {age} years old")
```

</details>
