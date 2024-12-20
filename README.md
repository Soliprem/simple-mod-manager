# Simple Mod Manager
This tool merges two directories, saves the transaction to a database, and can undo that same transaction.

In this README, I make reference of running main.nu as `simple-mod-manager`, because that's how I symlinked it to $PATH in my system. I do the same with `apply-zipped` and `apply-zipped.nu`.
## Usage
When using two directories

```
simple-mod-manager -i <input_directory> -o <destination_directory>
```

For example

```
simple-mod-manager -i immersive-driving -o /storage/Games/cyberpunk-2077
```

### With zip archives

Either unzip the archive to a new directory and then run the snippet as above, or use the apply-zipped script

```
apply-zipped -i archive.zip -o <destination_directory>
```

For example 

```
apply-zipped -i immersive-driving.zip -o /storage/Games/cyberpunk-2077
```
