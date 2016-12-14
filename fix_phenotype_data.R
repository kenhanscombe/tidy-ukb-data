
fill_missing_description <-  function(data) {
  # Fills Description and Type columns where missing at follow-up assessments.
  #
  # data: field-to-description table from html file
  
  udi <- gsub(pattern = '-.*$', '', data[, 'UDI'])
  for (i in 2:nrow(data)) {
    if (udi[i] == udi[i-1] & is.na(data[, 'Description'][i])) {
      data[i, 'Type'] <- data[i-1, 'Type']
      data[i, 'Description'] <- data[i-1, 'Description']}}
  
  return(data)}


description_to_name <-  function(data) {
  # Makes variable name out of field description.
  #
  # data: Field-to-description table from html file
  
  name <- tolower(data[, 'Description'])
  name <- gsub(' - ', '_', name)
  name <- gsub(' ', '_', name)
  name <- gsub('uses_data-coding.*simple_list.$', '', name)
  name <- gsub('uses_data-coding.*hierarchical_tree.', '', name)
  name <- gsub(',', '', name)
  name <- gsub('(', '', name)
  name <- gsub(')', '', name)
  
  ukb_index_array <- gsub('^.*-', '', data[, 'UDI'])
  ukb_index_array <- gsub('\\.', '_', ukb_index_array)

  name_index_array <- ifelse(
    ukb_index_array == 'eid',
    'eid',
    paste(name, ukb_index_array, sep = '_'))
    
  return(name_index_array)}


column_name_lookup <-  function(data){
  # Matches field (as in tab file) to variable name
  #
  # data: Field-to-description table from html file
  # returns: a named character vector. Names are fields, values are variable names made from description
  
  df <- fill_missing_description(data)
  lookup <- description_to_name(df)
  names(lookup) <- paste('f.', gsub('-', '.', df[, 'UDI']), sep = '')
  return(lookup)}


update_tab_path <- function(fileset, path = './') {
  # Corrects path to tab file in R source
  #
  # In particular, if you have moved the fileset from the directory 
  # containing the foo.enc file on which you called gconv.
  # NB. gconv writes absolute path to directory containing foo.enc,
  # into foo.r read.table() call
  #
  # fileset: prefix for UKB fileset
  # path: relative path to directory containing the fileset
  r_file <- sprintf('%s.r', fileset)
  tab_file <- sprintf('%s.tab', fileset)
  
  # Update path to tab file in R source
  tab_location <- paste(path, tab_file, sep = '')
  r_location <- paste(path, r_file, sep = '')
  
  f <- gsub(
    "read.*$" ,
    sprintf("read.delim('%s')", tab_location) , 
    readLines(r_location))
  cat(f, file = r_location, sep = '\n')} 




#
## Use the above functions to read UKB fileset and output tidier phenotype data
#


tidy_phen <- function(fileset, path = './') {
  # Reads UKB phenotype fileset (html, tab, r) and returns a tidy dataset
  #
  # html - contains tables mapping field code to variable name, and labels and levels for categorical variables 
  # tab - raw data with field codes instead of variable names
  # r - read raw data script (inserts categorical variable levels and labels)
  #
  # fileset: prefix for UKB fileset
  # path: relative path to directory containing the fileset
  # returns: a dataframe
  
  html_file <- sprintf('%s.html', fileset)
  r_file <- sprintf('%s.r', fileset)
  tab_file <- sprintf('%s.tab', fileset)
  
  update_tab_path(fileset, path)
  
  source(paste(path, r_file, sep = ''))
  
  tables <- readHTMLTable(
    doc = paste(path, html_file, sep = ''),
    stringsAsFactors = FALSE)
  
  variable_names <- column_name_lookup(tables[[2]])
  names(bd) <- variable_names[names(bd)]
  return(bd)}
