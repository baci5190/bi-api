<?php
function is_empty_string($var) {
    $var = trim($var);
    return isset($var) === true && $var === '';
}

function is_not_set_or_empty($var){
    return !isset($var) || is_empty_string($var);
}