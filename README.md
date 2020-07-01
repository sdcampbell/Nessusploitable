# nessus-exploitable
Parses Nessus .nessus files for exploitable vulnerabilities and outputs a report file in format MM-DD-YYYY-nessus.csv
Import the report data into Excel in Tab Separated Values format.

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
