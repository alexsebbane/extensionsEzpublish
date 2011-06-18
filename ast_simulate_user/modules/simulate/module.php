<?php
/**
 * Module used to expose new functionality related to user access
 * @version $Id$
 * @author G. Giunta
 */

$Module = array( 'name' => 'simulate', "variable_params" => true );

$ViewList = array();
$ViewList['impersonate'] = array(
    'script' => 'impersonate.php',
    'params' => array( 'ObjectId' ),
    'functions' => array( 'impersonate_user' )
);

$FunctionList = array();
$FunctionList['impersonate_user'] = array();

?>
