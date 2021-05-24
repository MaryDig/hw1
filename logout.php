<?php
    session_start();
    ini_set("display_errors","1");
    error_reporting(E_ALL);
    header('Access-Control-Allow-Origin: *');
    $logout = 0;
    if(isset($_SESSION["login_studente"])){
        unset($_SESSION["login_studente"]);
        $logout = 1;
    }
    if(isset($_SESSION["login_docente"])){
        unset($_SESSION["login_docente"]);
        $logout = 1;
    }
    if(isset($_SESSION["login_docente"])){
        unset($_SESSION["login_docente"]);
        $logout = 1;
    }
    if($logout==1) session_destroy();
    $return = array("result"=>$logout);
    echo json_encode($return);
?>