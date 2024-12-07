#!/usr/bin/env nu

use std assert

def find_conflict [input_dir: path, input_files: list, output_dir: path] {
    let output_files = (fd . -t f --base-directory $output_dir | lines)
    $input_files | each { if ($in in $output_files) {return $in}}
}

def merge_dir [input_dir: path, input_files: list output_dir: path, database_file: path] {
    let existing_entries = if ($database_file | path exists) {
        open $database_file
    } else {
        {}
    }
    let new_entry = {
        $input_dir: {
        files: $input_files
        output_dir: $output_dir
        }
    } 
    let updated_entries = ($existing_entries | merge $new_entry)
    $updated_entries | to json | save -f $database_file
    $input_files | each { |file| cp -vr ($input_dir | path join $file) $output_dir } | ignore
}

def undo_transaction [
    transaction_name?: string = "", 
    database_file: path = "merge_database.json"
] {

    let database = (open $database_file)
    let transactions = ($database | columns)
    let selected_transaction =  $transactions | input list -f
    if ($selected_transaction not-in $transactions) {
        error make {
            msg: $"No transaction selected or found"
        }
    }

    $database 
    | get $selected_transaction 
    | get files
    | each { |file| 
        try {rm -v (($database | get $selected_transaction).output_dir | path join $file)} catch { |e| 
            print $"Error removing ($file): ($e.msg)"}
    }

    let updated_database = ($database | reject $selected_transaction)
    $updated_database | save -f $database_file
}

# Merges two directories, saving the changes to a database so they can be reverted
def main [
    --input-dir (-i): path, # path of the directory whose files we need to move
    --output-dir (-o): path, # path of the directory we move the files into
    --delete (-d) # option to undo a previously made operation
    --force (-f) #option to remove the assert to check for conflicts
] {
    let database_file = ($env.XDG_DATA_HOME | path join "simple-mod-manager.json")
    if not $delete { 
        echo $input_dir
        let input_files = (glob -D ($input_dir + "/**/*") | path relative-to $input_dir )
        if not $force {
            let conflicts = find_conflict $input_dir $input_files $output_dir 
            assert ($conflicts | is-empty) $"There's a file conflict \(($conflicts) are overlapping). This is currently unsupported"
        }
        merge_dir $input_dir $input_files $output_dir $database_file
    } else { 
        undo_transaction $delete $database_file
    }
}
