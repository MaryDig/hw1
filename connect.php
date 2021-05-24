<?php
    ini_set("display_errors","1");
    error_reporting(E_ALL);
    header('Access-Control-Allow-Origin: *');

    function database_connect(){
        $host = "localhost";
        $user = "root";
        $password = "";
        $database = "Conservatorio2";
        $conn = mysqli_connect($host, $user, $password, $database) or die("errore nella connessione con il database");
        return $conn; 

    }

?>