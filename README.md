# Simple Mod Manager
This tool merges two directories, saves the transaction to a database, and can undo that same transaction.

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

Either unzip the archive to a new directory and then run the snippet as above, or use the apply-zip script

```
apply-zipped -i archive.zip -o <destination_directory>
```

For example 

```
simple-mod-manager -i immersive-driving.zip -o /storage/Games/cyberpunk-2077
```
