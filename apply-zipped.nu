#!/usr/bin/env nu

def main [
    --input-file (-i): path, # path of the directory whose files we need to move
    --output-dir (-o): path, # path of the directory we move the files into
] {
    mkdir archives
    let input_dir = ("archives" | path join $input_file)
    unzip $input_file -d $input_dir
    simple-mod-manager -i $input_dir -o $output_dir
    rm -rI $input_dir
}
