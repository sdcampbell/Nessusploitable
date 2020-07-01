# nessus-exploitable
Parses Nessus .nessus files for exploitable vulnerabilities and outputs a report file in format MM-DD-YYYY-nessus.csv. Import the report data into Excel in Tab Separated Values format. The report includes the name of the Metasploit module, if applicable. Unfortunately the Metasploit module is the description, not the path you need to type in to use the module. This is a limitation of Nessus reporting, not this Ruby script. To search based on Metasploit module description, enter in Metasploit `search fullname:'[text from Excel sheet column' type:exploit`. The Metasploit search results will highlight the search keywords, so just scroll and look for the result with the full match. 

Requires ruby-nessus gem v2 which must be installed from GitHub:

```
git clone https://github.com/mephux/ruby-nessus
cd ruby-nessus/
gem build ruby-nessus.gemspec
sudo gem install ruby-nessus-2.0.beta.gem
```

Usage: 

```
ruby nessus-exploitable.rb [options] [path]
    -f, --file PATH                  File path for single file
    -d, --directory PATH             Directory path to import multiple .nessus files
    -h, --help                       Prints help
```
