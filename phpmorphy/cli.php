<?php
error_reporting(E_ALL | E_STRICT);
require_once(dirname(__FILE__) . '/src/common.php');

// set some options
$opts = array(
// storage type, follow types supported
// PHPMORPHY_STORAGE_FILE - use file operations(fread, fseek) for dictionary access, this is very slow...
// PHPMORPHY_STORAGE_SHM - load dictionary in shared memory(using shmop php extension), this is preferred mode
// PHPMORPHY_STORAGE_MEM - load dict to memory each time when phpMorphy intialized, this useful when shmop ext. not activated. Speed same as for PHPMORPHY_STORAGE_SHM type
'storage' => PHPMORPHY_STORAGE_FILE,
// Extend graminfo for getAllFormsWithGramInfo method call
'with_gramtab' => false,
// Enable prediction by suffix
'predict_by_suffix' => true,
// Enable prediction by prefix
'predict_by_db' => true
);

// Path to directory where dictionaries located
$dir = dirname(__FILE__) . '/dicts';

// Create descriptor for dictionary located in $dir directory with russian language
$dict_bundle = new phpMorphy_FilesBundle($dir, 'rus');

// Create phpMorphy instance
try {
 $morphy = new phpMorphy($dict_bundle, $opts);
} catch(phpMorphy_Exception $e) {
 die('Error occured while creating phpMorphy instance: ' . $e->getMessage());
}

if (!isset($argv[1])) die("Error: no argument given - exit\n");

#$word = iconv("UTF-8", "CP1251", $argv[1]);
$word = mb_convert_case($argv[1], MB_CASE_UPPER, "UTF-8");

$all_forms = $morphy->getAllForms($word);

if(false === $all_forms) {
 die("Error: can`t find or predict \"$word\"\n");
}

echo implode(', ', $all_forms) . "\n";
