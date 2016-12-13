
# Tidy(er) UK Biobank phenotype data

Some convenience R tools for making UK Biobank (UKB) phenotype data tidier.


### Getting started

After downloading and decrypting your UKB data with the supplied [UKB tools] (http://biobank.ctsu.ox.ac.uk/crystal/docs/UsingUKBData.pdf), you have multiple files that need to be brought together to give you a tidy dataset to explore. The data file in any format has column names that are the field codes from the UKB data showcase. You can retrieve the variable names from the html file created using the UKB tools. 


### Prerequisites

From your decrypted UKB data, create a fileset: an html documentation file

```ukb_conv ukb1234.enc_ukb  docs```

and a tab-delimited data file and R script that reads the tab file

```ukb_conv ukb1234.enc_ukb r```

Full details of the data download and decrypt process are given in the [Using UK Biobank Data] (http://biobank.ctsu.ox.ac.uk/crystal/docs/UsingUKBData.pdf) documentation


### Example use

The function `tidy_phen()` takes two arguments, the stem of your fileset and the path, and returns a dataframe with usable column names. You will need to install and load the `XML` libary

```
library(XML)
source('fix_phenotype_data.R')
my_ukb_data <- tidy_phen('ukb1234')
```

You can also specify the path to your fileset if it is not in the current directory. For example, if your fileset is in a subdirectory of the working directory called data

```
my_ukb_data <- tidy_phen('ukb1234', './data/')
```

`tidy_phen()` updates the read call in the R source file to point to the correct directory by a call to `update_tab_path()`

<br>

***

#### Notes:

I'll be updating this as I work through my data. If any of it proves to be useful for other people, I'll write a wrapper around the code so it can be used from the command line. Things to be aware of:

1. For the datasets I've downloaded, what I'm calling the __Field-to-Description__ table (from which I build the variable name), is always the second table - retrieved with `[[2]]` in the code.

2. Eye-balling the output, I think the variable names are pretty sensible. If you want to drop any more text, this can be done in `description_to_name()`

3. I've preserved the __index__ and __array__ from the field code in the variable name, as two numbers separated by underscores at the end of the name e.g. *name_index_array*. __index__ captures the assessment instance. __array__ captures multiple answers to the same "question". See UK Biobank documentation for detailed description of [index] (http://biobank.ctsu.ox.ac.uk/crystal/instance.cgi?id=2) and [array] (http://biobank.ctsu.ox.ac.uk/crystal/help.cgi?cd=array).

(http://biobank.ctsu.ox.ac.uk/crystal/instance.cgi?id=2)
